from django.db import models
from .group import Group
from .member import Member


class LoanStatus(models.TextChoices):
    ACTIVE = 'active', 'Active'
    REPAID = 'repaid', 'Repaid'
    DEFAULTED = 'defaulted', 'Defaulted'
    WRITTEN_OFF = 'written_off', 'Written Off'


class Loan(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='loans')
    member = models.ForeignKey(Member, on_delete=models.CASCADE, related_name='loans')
    principal_amount = models.DecimalField(max_digits=15, decimal_places=2)
    interest_rate = models.DecimalField(max_digits=5, decimal_places=2)
    total_amount = models.DecimalField(max_digits=15, decimal_places=2)
    amount_repaid = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    status = models.CharField(max_length=20, choices=LoanStatus.choices, default=LoanStatus.ACTIVE)
    issued_at = models.DateTimeField(auto_now_add=True)
    due_date = models.DateTimeField(null=True, blank=True)
    repaid_at = models.DateTimeField(null=True, blank=True)
    purpose = models.TextField(blank=True, null=True)
    guarantors = models.ManyToManyField(Member, related_name='guaranteed_loans', blank=True)

    class Meta:
        db_table = 'chamify_loans'
        ordering = ['-issued_at']

    def __str__(self):
        return f'Loan {self.id[:8]} - {self.member.full_name}'

    @property
    def remaining_balance(self):
        return self.total_amount - self.amount_repaid

    @property
    def repayment_progress(self):
        if self.total_amount > 0:
            return (self.amount_repaid / self.total_amount) * 100
        return 0