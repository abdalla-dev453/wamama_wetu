import uuid
from django.db import models
from .group import Group
from .member import Member
from .contribution import Contribution


class MpesaPaymentStatus(models.TextChoices):
    RECEIVED = 'received', 'Received'
    VALIDATING = 'validating', 'Validating'
    MATCHED = 'matched', 'Matched'
    UNMATCHED = 'unmatched', 'Unmatched'
    ALLOCATED = 'allocated', 'Allocated'
    POSTED = 'posted', 'Posted'
    REVERSED = 'reversed', 'Reversed'


# Valid state transitions for the reconciliation state machine
VALID_TRANSITIONS = {
    MpesaPaymentStatus.RECEIVED: [MpesaPaymentStatus.VALIDATING, MpesaPaymentStatus.REVERSED],
    MpesaPaymentStatus.VALIDATING: [MpesaPaymentStatus.MATCHED, MpesaPaymentStatus.UNMATCHED, MpesaPaymentStatus.REVERSED],
    MpesaPaymentStatus.MATCHED: [MpesaPaymentStatus.ALLOCATED, MpesaPaymentStatus.REVERSED],
    MpesaPaymentStatus.UNMATCHED: [MpesaPaymentStatus.MATCHED, MpesaPaymentStatus.POSTED, MpesaPaymentStatus.REVERSED],
    MpesaPaymentStatus.ALLOCATED: [MpesaPaymentStatus.POSTED, MpesaPaymentStatus.REVERSED],
    MpesaPaymentStatus.POSTED: [MpesaPaymentStatus.REVERSED],
    MpesaPaymentStatus.REVERSED: [],
}


class MpesaPayment(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='mpesa_payments')
    phone_number = models.CharField(max_length=20)
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    transaction_date = models.DateTimeField()
    mpesa_receipt_code = models.CharField(max_length=50)
    reference = models.CharField(max_length=100)  # GROUPCODE#MEMBERNO
    status = models.CharField(max_length=20, choices=MpesaPaymentStatus.choices, default=MpesaPaymentStatus.RECEIVED)
    matched_member = models.ForeignKey(Member, on_delete=models.SET_NULL, null=True, blank=True, related_name='matched_payments')
    matched_contribution = models.ForeignKey(Contribution, on_delete=models.SET_NULL, null=True, blank=True, related_name='matched_payments')
    allocated_amount = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    remaining_amount = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    unmatched_reason = models.TextField(blank=True, null=True)
    requires_treasurer_review = models.BooleanField(default=True)
    assigned_by = models.ForeignKey('auth.User', on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_payments')
    assignment_reason = models.TextField(blank=True, null=True)
    assigned_at = models.DateTimeField(null=True, blank=True)
    approved_by = models.ForeignKey('auth.User', on_delete=models.SET_NULL, null=True, blank=True, related_name='approved_payments')
    approved_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'chamify_mpesa_payments'
        ordering = ['-transaction_date']

    def __str__(self):
        return f'{self.mpesa_receipt_code} - {self.amount} ({self.status})'

    def can_transition(self, new_status):
        """Check if transition to new_status is valid."""
        current = MpesaPaymentStatus(self.status)
        target = MpesaPaymentStatus(new_status)
        return target in VALID_TRANSITIONS.get(current, [])

    def transition(self, new_status, user=None, reason=None):
        """Transition to a new state with validation."""
        if not self.can_transition(new_status):
            raise ValueError(
                f'Invalid transition from {self.status} to {new_status}'
            )
        old_status = self.status
        self.status = new_status

        if new_status == MpesaPaymentStatus.ALLOCATED and user:
            self.assigned_by = user
            self.assignment_reason = reason
            from django.utils import timezone
            self.assigned_at = timezone.now()

        if new_status == MpesaPaymentStatus.POSTED and user:
            self.approved_by = user
            from django.utils import timezone
            self.approved_at = timezone.now()

        self.save()

        # Create audit entry
        from .audit_entry import AuditEntry, AuditAction
        AuditEntry.objects.create(
            id=str(uuid.uuid4()),
            group=self.group,
            actor_id=user.id if user else None,
            action=AuditAction.PAYMENT_RECONCILED if new_status == MpesaPaymentStatus.POSTED else AuditAction.PAYMENT_ASSIGNED,
            before_values={'status': old_status},
            after_values={'status': new_status},
            reason=reason,
            target_type='mpesa_payment',
            target_id=self.id,
        )