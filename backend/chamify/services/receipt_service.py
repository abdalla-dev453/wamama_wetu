from django.utils import timezone
from chamify.models import PaymentReceipt, MpesaPayment, Member


class ReceiptService:
    """Service for generating payment proof receipts."""

    @staticmethod
    def generate_receipt(mpesa_payment, member, allocation_type, allocation_reference=None):
        """
        Generate an immutable receipt after reconciliation.
        """
        receipt = PaymentReceipt.objects.create(
            mpesa_payment=mpesa_payment,
            member=member,
            amount=mpesa_payment.allocated_amount,
            payment_method='M-PESA',
            mpesa_receipt_code=mpesa_payment.mpesa_receipt_code,
            transaction_date=mpesa_payment.transaction_date,
            allocation_type=allocation_type,
            allocation_reference=allocation_reference,
            status='issued',
        )
        return receipt

    @staticmethod
    def get_receipt_data(receipt):
        """Get receipt data for display/sharing."""
        return {
            'receipt_id': receipt.id,
            'member_name': receipt.member.full_name,
            'member_number': receipt.member.member_number,
            'amount': str(receipt.amount),
            'payment_method': receipt.payment_method,
            'mpesa_receipt_code': receipt.mpesa_receipt_code,
            'date': receipt.transaction_date.isoformat(),
            'allocation_type': receipt.allocation_type,
            'allocation_reference': receipt.allocation_reference,
            'status': receipt.status,
            'generated_at': receipt.generated_at.isoformat(),
        }

    @staticmethod
    def mark_shared(receipt, via_sms=False, via_whatsapp=False):
        """Mark receipt as shared."""
        if via_sms:
            receipt.shared_via_sms = True
        if via_whatsapp:
            receipt.shared_via_whatsapp = True
        receipt.save()