from django.db import models
from django.contrib.auth.models import User


class Group(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    name = models.CharField(max_length=200)
    code = models.CharField(max_length=20, unique=True, help_text='GROUPCODE for M-PESA reference')
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)
    currency = models.CharField(max_length=3, default='KES')
    total_contributions = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    total_payouts = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    current_pot_balance = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    paybill_number = models.CharField(max_length=20, blank=True, null=True)
    member_count = models.IntegerField(default=0)
    chairperson = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='chaired_groups')
    treasurer = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='treasured_groups')

    class Meta:
        db_table = 'chamify_groups'
        ordering = ['-created_at']

    def __str__(self):
        return self.name