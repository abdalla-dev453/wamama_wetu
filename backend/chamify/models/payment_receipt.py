from django.db import models
from .group import Group
from .member import Member
from .mpesa_payment import MpesaPayment


class PaymentReceipt(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    mpesa_payment = models.ForeignKey(MpesaPayment, on_delete=models.CASCADE, related_name='receipts')
    member = models.ForeignKey(Member, on_delete=models.CASCADE, related_name='receipts')
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    payment_method = models.CharField(max_length=20, default='M-PESA')
    mpesa_receipt_code = models.CharField(max_length=50)
    transaction_date = models.DateTimeField()
    allocation_type = models.CharField(max_length=50)  # contribution, pot, loan_repayment
    allocation_reference = models.CharField(max_length=100, blank=True, null=True)
    status = models.CharField(max_length=20, default='issued')
    generated_at = models.DateTimeField(auto_now_add=True)
    shared_via_sms = models.BooleanField(default=False)
    shared_via_whatsapp = models.BooleanField(default=False)

    class Meta:
        db_table = 'chamify_payment_receipts'
        ordering = ['-generated_at']

    def __str__(self):
        return f'Receipt {self.id[:8]} - {self.member.full_name}'