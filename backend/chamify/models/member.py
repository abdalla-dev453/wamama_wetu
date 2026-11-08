from django.db import models
from django.contrib.auth.models import User
from .group import Group


class Member(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='members')
    member_number = models.CharField(max_length=20)
    full_name = models.CharField(max_length=200)
    phone_number = models.CharField(max_length=20)
    id_number = models.CharField(max_length=20, blank=True, null=True)
    joined_at = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)
    total_contributed = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    total_received = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    outstanding_balance = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    is_chairperson = models.BooleanField(default=False)
    is_treasurer = models.BooleanField(default=False)
    email = models.EmailField(blank=True, null=True)
    next_of_kin = models.CharField(max_length=200, blank=True, null=True)
    next_of_kin_phone = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        db_table = 'chamify_members'
        unique_together = ['group', 'member_number']
        ordering = ['member_number']

    def __str__(self):
        return self.full_name