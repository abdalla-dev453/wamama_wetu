import uuid
from decimal import Decimal
from django.utils import timezone
from django.db import transaction
from chamify.models import (
    MpesaPayment, MpesaPaymentStatus, Member, Contribution,
    Group, AuditEntry, AuditAction
)


class ReconciliationService:
    """Service for M-PESA payment reconciliation with state machine."""

    @staticmethod
    def parse_reference(reference):
        """Parse GROUPCODE#MEMBERNO reference format."""
        if '#' not in reference:
            return None, None, 'Invalid reference format: expected GROUPCODE#MEMBERNO'
        parts = reference.split('#', 1)
        return parts[0], parts[1], None

    @staticmethod
    @transaction.atomic
    def reconcile_payment(payment, validated_member=None, user=None):
        """
        Reconcile a M-PESA payment through the state machine:
        received → validating → matched/unmatched → allocated → posted/reversed
        """
        # Transition to validating
        if payment.status != MpesaPaymentStatus.VALIDATING:
            payment.transition(MpesaPaymentStatus.VALIDATING, user=user)

        group_code, member_no, error = ReconciliationService.parse_reference(payment.reference)

        if error:
            payment.transition(
                MpesaPaymentStatus.UNMATCHED,
                user=user,
                reason=error,
            )
            return payment, {'matched': False, 'reason': error}

        # Try to find member
        try:
            member = Member.objects.get(
                group=payment.group,
                member_number=member_no,
                is_active=True,
            )
        except Member.DoesNotExist:
            payment.transition(
                MpesaPaymentStatus.UNMATCHED,
                user=user,
                reason=f'Member {member_no} not found in group',
            )
            return payment, {'matched': False, 'reason': 'Member not found'}

        # Check for duplicate payment (same receipt code already processed)
        existing = MpesaPayment.objects.filter(
            mpesa_receipt_code=payment.mpesa_receipt_code,
            status__in=[MpesaPaymentStatus.POSTED, MpesaPaymentStatus.ALLOCATED],
        ).exclude(id=payment.id).first()

        if existing:
            payment.transition(
                MpesaPaymentStatus.UNMATCHED,
                user=user,
                reason=f'Duplicate payment: receipt {payment.mpesa_receipt_code} already posted',
            )
            return payment, {'matched': False, 'reason': 'Duplicate payment'}

        # Check exact match vs partial vs overpayment
        # Find expected contribution for this member
        expected_contribution = Contribution.objects.filter(
            group=payment.group,
            member=member,
        ).order_by('-date').first()

        if expected_contribution:
            expected_amount = expected_contribution.amount
        else:
            expected_amount = Decimal('0')

        if payment.amount == expected_amount:
            # Exact match
            payment.matched_member = member
            payment.matched_contribution = expected_contribution
            payment.allocated_amount = payment.amount
            payment.remaining_amount = Decimal('0')
            payment.transition(MpesaPaymentStatus.MATCHED, user=user)
            payment.transition(MpesaPaymentStatus.ALLOCATED, user=user, reason='Exact match')
            payment.transition(MpesaPaymentStatus.POSTED, user=user, reason='Exact match posted')
            return payment, {
                'matched': True,
                'member': member,
                'type': 'exact',
                'allocated': payment.allocated_amount,
            }

        elif payment.amount < expected_amount:
            # Partial payment
            payment.matched_member = member
            payment.matched_contribution = expected_contribution
            payment.allocated_amount = payment.amount
            payment.remaining_amount = expected_amount - payment.amount
            payment.transition(MpesaPaymentStatus.MATCHED, user=user)
            payment.transition(MpesaPaymentStatus.ALLOCATED, user=user, reason='Partial payment')
            return payment, {
                'matched': True,
                'member': member,
                'type': 'partial',
                'allocated': payment.allocated_amount,
                'remaining': payment.remaining_amount,
                'requires_treasurer': True,
            }

        else:
            # Overpayment
            payment.matched_member = member
            payment.matched_contribution = expected_contribution
            payment.allocated_amount = expected_amount
            payment.remaining_amount = payment.amount - expected_amount
            payment.transition(MpesaPaymentStatus.MATCHED, user=user)
            payment.transition(MpesaPaymentStatus.ALLOCATED, user=user, reason='Overpayment')
            return payment, {
                'matched': True,
                'member': member,
                'type': 'overpayment',
                'allocated': payment.allocated_amount,
                'excess': payment.remaining_amount,
                'requires_treasurer': True,
            }

    @staticmethod
    @transaction.atomic
    def assign_unmatched_payment(payment, member, user, reason=None):
        """
        Treasurer assigns an unmatched payment to a member.
        Requires treasurer confirmation - never auto-allocate ambiguous payments.
        """
        if payment.status != MpesaPaymentStatus.UNMATCHED:
            raise ValueError(f'Payment is not in unmatched state: {payment.status}')

        payment.matched_member = member
        payment.requires_treasurer_review = False
        payment.assigned_by = user
        payment.assignment_reason = reason
        payment.transition(MpesaPaymentStatus.MATCHED, user=user, reason=reason)

        return payment

    @staticmethod
    @transaction.atomic
    def reverse_payment(payment, user, reason=None):
        """
        Reverse a posted payment. Creates reversing entry only - no direct edits.
        """
        if payment.status != MpesaPaymentStatus.POSTED:
            raise ValueError(f'Only posted payments can be reversed: {payment.status}')

        payment.transition(MpesaPaymentStatus.REVERSED, user=user, reason=reason)

        # Create reversing contribution entry if needed
        if payment.matched_contribution:
            Contribution.objects.create(
                id=str(uuid.uuid4()),
                group=payment.group,
                member=payment.matched_member,
                amount=-payment.allocated_amount,
                type='one_off',
                reference=f'REVERSAL:{payment.mpesa_receipt_code}',
                is_cash=False,
                recorded_by=user,
                is_reconciled=True,
                reconciliation_id=payment.id,
            )

        return payment

    @staticmethod
    def get_unmatched_queue(group):
        """Get all payments requiring treasurer review."""
        return MpesaPayment.objects.filter(
            group=group,
            status=MpesaPaymentStatus.UNMATCHED,
            requires_treasurer_review=True,
        ).order_by('-transaction_date')