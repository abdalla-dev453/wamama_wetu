from django.db import models
from .group import Group
from .member import Member


class FineStatus(models.TextChoices):
    ACTIVE = 'active', 'Active'
    PAID = 'paid', 'Paid'
    WAIVED = 'waived', 'Waived'


class Fine(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='fines')
    member = models.ForeignKey(Member, on_delete=models.CASCADE, related_name='fines')
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    reason = models.TextField()
    status = models.CharField(max_length=20, choices=FineStatus.choices, default=FineStatus.ACTIVE)
    issued_at = models.DateTimeField(auto_now_add=True)
    paid_at = models.DateTimeField(null=True, blank=True)
    recorded_by = models.ForeignKey('auth.User', on_delete=models.SET_NULL, null=True, blank=True)

    class Meta:
        db_table = 'chamify_fines'
        ordering = ['-issued_at']

    def __str__(self):
        return f'Fine {self.id[:8]} - {self.member.full_name} - {self.amount}'