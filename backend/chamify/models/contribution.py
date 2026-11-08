from django.db import models
from .group import Group
from .member import Member


class ContributionType(models.TextChoices):
    WEEKLY = 'weekly', 'Weekly'
    MONTHLY = 'monthly', 'Monthly'
    ONE_OFF = 'one_off', 'One Off'


class Contribution(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='contributions')
    member = models.ForeignKey(Member, on_delete=models.CASCADE, related_name='contributions')
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    date = models.DateTimeField(auto_now_add=True)
    type = models.CharField(max_length=20, choices=ContributionType.choices)
    cycle_id = models.CharField(max_length=36, blank=True, null=True)
    pot_id = models.CharField(max_length=36, blank=True, null=True)
    mpesa_receipt_code = models.CharField(max_length=50, blank=True, null=True)
    reference = models.CharField(max_length=100, blank=True, null=True)
    is_cash = models.BooleanField(default=False)
    recorded_by = models.ForeignKey('auth.User', on_delete=models.SET_NULL, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    is_reconciled = models.BooleanField(default=False)
    reconciliation_id = models.CharField(max_length=36, blank=True, null=True)

    class Meta:
        db_table = 'chamify_contributions'
        ordering = ['-date']

    def __str__(self):
        return f'{self.member.full_name} - {self.amount}'