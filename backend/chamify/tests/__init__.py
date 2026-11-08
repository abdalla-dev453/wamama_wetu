from django.test import TestCase
from django.contrib.auth.models import User
from chamify.models import (
    Group, Member, MpesaPayment, MpesaPaymentStatus,
    Contribution, AuditEntry, AuditAction, GroupHealthScore, Loan, Fine
)
from chamify.services.reconciliation_service import ReconciliationService


class ReconciliationTestCase(TestCase):
    """Unit tests for M-PESA reconciliation state machine."""

    def setUp(self):
        self.user = User.objects.create_user('treasurer', 'treasurer@test.com', 'pass123')
        self.group = Group.objects.create(
            id='g1',
            name='Test Chama',
            code='TEST',
            treasurer=self.user,
        )
        self.member = Member.objects.create(
            id='m1',
            group=self.group,
            member_number='001',
            full_name='John Doe',
            phone_number='0712345678',
        )

    def test_exact_match_payment(self):
        """Test exact amount match."""
        payment = MpesaPayment.objects.create(
            id='p1',
            group=self.group,
            phone_number='0712345678',
            amount=1000,
            mpesa_receipt_code='TEST123',
            reference='TEST#001',
            transaction_date='2026-11-07T10:00:00Z',
            status=MpesaPaymentStatus.RECEIVED,
        )
        # Create expected contribution
        Contribution.objects.create(
            id='c1',
            group=self.group,
            member=self.member,
            amount=1000,
            type='weekly',
        )

        result, info = ReconciliationService.reconcile_payment(payment, user=self.user)
        payment.refresh_from_db()

        self.assertEqual(payment.status, MpesaPaymentStatus.POSTED)
        self.assertEqual(info['type'], 'exact')
        self.assertTrue(info['matched'])

    def test_partial_payment(self):
        """Test partial payment - less than expected."""
        payment = MpesaPayment.objects.create(
            id='p2',
            group=self.group,
            phone_number='0712345678',
            amount=500,
            mpesa_receipt_code='TEST124',
            reference='TEST#001',
            transaction_date='2026-11-07T10:00:00Z',
            status=MpesaPaymentStatus.RECEIVED,
        )
        Contribution.objects.create(
            id='c2',
            group=self.group,
            member=self.member,
            amount=1000,
            type='weekly',
        )

        result, info = ReconciliationService.reconcile_payment(payment, user=self.user)
        payment.refresh_from_db()

        self.assertEqual(payment.status, MpesaPaymentStatus.ALLOCATED)
        self.assertEqual(info['type'], 'partial')
        self.assertEqual(info['allocated'], 500)
        self.assertEqual(info['remaining'], 500)
        self.assertTrue(info['requires_treasurer'])

    def test_overpayment(self):
        """Test overpayment - more than expected."""
        payment = MpesaPayment.objects.create(
            id='p3',
            group=self.group,
            phone_number='0712345678',
            amount=1500,
            mpesa_receipt_code='TEST125',
            reference='TEST#001',
            transaction_date='2026-11-07T10:00:00Z',
            status=MpesaPaymentStatus.RECEIVED,
        )
        Contribution.objects.create(
            id='c3',
            group=self.group,
            member=self.member,
            amount=1000,
            type='weekly',
        )

        result, info = ReconciliationService.reconcile_payment(payment, user=self.user)
        payment.refresh_from_db()

        self.assertEqual(payment.status, MpesaPaymentStatus.ALLOCATED)
        self.assertEqual(info['type'], 'overpayment')
        self.assertEqual(info['allocated'], 1000)
        self.assertEqual(info['excess'], 500)

    def test_duplicate_payment(self):
        """Test duplicate payment detection."""
        # First payment posted
        payment1 = MpesaPayment.objects.create(
            id='p4',
            group=self.group,
            phone_number='0712345678',
            amount=1000,
            mpesa_receipt_code='DUP001',
            reference='TEST#001',
            transaction_date='2026-11-07T10:00:00Z',
            status=MpesaPaymentStatus.POSTED,
        )
        Contribution.objects.create(
            id='c4',
            group=self.group,
            member=self.member,
            amount=1000,
            type='weekly',
        )

        # Second payment with same receipt code
        payment2 = MpesaPayment.objects.create(
            id='p5',
            group=self.group,
            phone_number='0712345678',
            amount=1000,
            mpesa_receipt_code='DUP001',
            reference='TEST#001',
            transaction_date='2026-11-07T10:00:00Z',
            status=MpesaPaymentStatus.RECEIVED,
        )

        result, info = ReconciliationService.reconcile_payment(payment2, user=self.user)
        payment2.refresh_from_db()

        self.assertEqual(payment2.status, MpesaPaymentStatus.UNMATCHED)
        self.assertFalse(info['matched'])
        self.assertIn('duplicate', info['reason'].lower())

    def test_invalid_transition(self):
        """Test that invalid state transitions are rejected."""
        payment = MpesaPayment.objects.create(
            id='p6',
            group=self.group,
            phone_number='0712345678',
            amount=1000,
            mpesa_receipt_code='TEST126',
            reference='TEST#001',
            transaction_date='2026-11-07T10:00:00Z',
            status=MpesaPaymentStatus.RECEIVED,
        )

        # Cannot go directly from received to posted
        with self.assertRaises(ValueError):
            payment.transition(MpesaPaymentStatus.POSTED, user=self.user)

    def test_reversing_entry(self):
        """Test that reversal creates reversing entry, not direct edit."""
        payment = MpesaPayment.objects.create(
            id='p7',
            group=self.group,
            phone_number='0712345678',
            amount=1000,
            mpesa_receipt_code='TEST127',
            reference='TEST#001',
            transaction_date='2026-11-07T10:00:00Z',
            status=MpesaPaymentStatus.POSTED,
        )
        Contribution.objects.create(
            id='c5',
            group=self.group,
            member=self.member,
            amount=1000,
            type='weekly',
        )
        payment.matched_contribution = Contribution.objects.first()
        payment.matched_member = self.member
        payment.allocated_amount = 1000
        payment.save()

        payment = ReconciliationService.reverse_payment(payment, self.user, reason='Error')
        payment.refresh_from_db()

        self.assertEqual(payment.status, MpesaPaymentStatus.REVERSED)
        # Verify reversing entry exists
        reversal = Contribution.objects.filter(
            reference__startswith='REVERSAL:',
            amount__lt=0,
        ).first()
        self.assertIsNotNone(reversal)


class HealthScoreTestCase(TestCase):
    """Tests for group health score calculation."""

    def setUp(self):
        self.user = User.objects.create_user('treasurer', 't@test.com', 'pass')
        self.group = Group.objects.create(id='g1', name='Test', code='TST', treasurer=self.user)
        self.member = Member.objects.create(
            id='m1', group=self.group, member_number='001',
            full_name='John', phone_number='0712345678',
            total_contributed=5000, outstanding_balance=1000,
        )

    def test_score_calculation(self):
        score = GroupHealthScore.objects.create(
            group=self.group,
            score=75,
            collection_rate=80,
            arrears_rate=20,
            loan_repayment_rate=90,
            meeting_attendance_rate=85,
            unmatched_payments_count=2,
            recommended_actions=['Send reminders'],
        )
        self.assertEqual(score.score_label, 'Good')


class AuditTrailTestCase(TestCase):
    """Tests for immutable audit trail."""

    def setUp(self):
        self.user = User.objects.create_user('treasurer', 't@test.com', 'pass')
        self.group = Group.objects.create(id='g1', name='Test', code='TST', treasurer=self.user)

    def test_audit_entry_creation(self):
        entry = AuditEntry.objects.create(
            id='a1',
            group=self.group,
            actor=self.user,
            action=AuditAction.CONTRIBUTION_RECORDED,
            before_values={},
            after_values={'amount': 1000},
            reason='Test contribution',
        )
        self.assertEqual(entry.action, AuditAction.CONTRIBUTION_RECORDED)
        self.assertEqual(entry.actor, self.user)