from django.db import models
from .group import Group
from .member import Member


class RotationOrderType(models.TextChoices):
    BALLOT = 'ballot', 'Ballot'
    MANUAL = 'manual', 'Manual'
    SWAP = 'swap', 'Swap'
    POSTPONEMENT = 'postponement', 'Postponement'


class RotationEntry(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='rotations')
    member = models.ForeignKey(Member, on_delete=models.CASCADE, related_name='rotation_entries')
    position = models.IntegerField()
    payout_date = models.DateTimeField()
    pot_amount = models.DecimalField(max_digits=15, decimal_places=2)
    is_paid_out = models.BooleanField(default=False)
    paid_out_at = models.DateTimeField(null=True, blank=True)
    order_type = models.CharField(max_length=20, choices=RotationOrderType.choices, default=RotationOrderType.MANUAL)
    swapped_from = models.ForeignKey(Member, on_delete=models.SET_NULL, null=True, blank=True, related_name='swapped_from_entries')
    swapped_to = models.ForeignKey(Member, on_delete=models.SET_NULL, null=True, blank=True, related_name='swapped_to_entries')
    postponement_reason = models.TextField(blank=True, null=True)
    approved_by = models.ForeignKey('auth.User', on_delete=models.SET_NULL, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'chamify_rotation_entries'
        unique_together = ['group', 'position']
        ordering = ['position']

    def __str__(self):
        return f'Position {self.position}: {self.member.full_name}'