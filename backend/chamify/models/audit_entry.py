from django.db import models
from django.contrib.auth.models import User
from .group import Group


class AuditAction(models.TextChoices):
    CONTRIBUTION_RECORDED = 'contribution_recorded', 'Contribution Recorded'
    CONTRIBUTION_REVERSED = 'contribution_reversed', 'Contribution Reversed'
    PAYMENT_RECONCILED = 'payment_reconciled', 'Payment Reconciled'
    PAYMENT_ASSIGNED = 'payment_assigned', 'Payment Assigned'
    PAYMENT_REVERSED = 'payment_reversed', 'Payment Reversed'
    MEMBER_ADDED = 'member_added', 'Member Added'
    MEMBER_UPDATED = 'member_updated', 'Member Updated'
    MEMBER_REMOVED = 'member_removed', 'Member Removed'
    ROTATION_PAYOUT = 'rotation_payout', 'Rotation Payout'
    ROTATION_SWAP = 'rotation_swap', 'Rotation Swap'
    ROTATION_POSTPONEMENT = 'rotation_postponement', 'Rotation Postponement'
    GROUP_CREATED = 'group_created', 'Group Created'
    GROUP_UPDATED = 'group_updated', 'Group Updated'
    LOAN_ISSUED = 'loan_issued', 'Loan Issued'
    LOAN_REPAID = 'loan_repaid', 'Loan Repaid'
    FINE_ISSUED = 'fine_issued', 'Fine Issued'
    FINE_PAID = 'fine_paid', 'Fine Paid'
    SETTINGS_CHANGED = 'settings_changed', 'Settings Changed'
    DATA_IMPORTED = 'data_imported', 'Data Imported'


class AuditEntry(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='audit_entries')
    actor = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='audit_actions')
    approver = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='audit_approvals')
    action = models.CharField(max_length=50, choices=AuditAction.choices)
    timestamp = models.DateTimeField(auto_now_add=True)
    before_values = models.JSONField(null=True, blank=True)
    after_values = models.JSONField(null=True, blank=True)
    reason = models.TextField(blank=True, null=True)
    device_id = models.CharField(max_length=100, blank=True, null=True)
    session_id = models.CharField(max_length=100, blank=True, null=True)
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    target_type = models.CharField(max_length=50, blank=True, null=True)
    target_id = models.CharField(max_length=36, blank=True, null=True)

    class Meta:
        db_table = 'chamify_audit_entries'
        ordering = ['-timestamp']

    def __str__(self):
        return f'{self.action} - {self.actor} - {self.timestamp}'