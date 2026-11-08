from celery import shared_task
from chamify.models import MpesaPayment, MpesaPaymentStatus
from chamify.services.reconciliation_service import ReconciliationService


@shared_task
def process_mpesa_callback(callback_data):
    """Process M-PESA C2B confirmation callback."""
    # Extract callback data
    receipt_code = callback_data.get('TransID')
    phone = callback_data.get('MSISDN')
    amount = callback_data.get('TransAmount')
    reference = callback_data.get('BillRefNumber')
    transaction_date = callback_data.get('TransactionDate')

    # Find or create payment
    payment, created = MpesaPayment.objects.get_or_create(
        mpesa_receipt_code=receipt_code,
        defaults={
            'group_id': callback_data.get('group_id'),
            'phone_number': phone,
            'amount': amount,
            'reference': reference,
            'transaction_date': transaction_date,
            'status': MpesaPaymentStatus.RECEIVED,
        }
    )

    if created:
        # Auto-trigger validation
        from chamify.services.reconciliation_service import ReconciliationService
        ReconciliationService.reconcile_payment(payment)

    return {'status': 'processed', 'payment_id': payment.id}


@shared_task
def calculate_group_health_score(group_id):
    """Calculate health score for a group (scheduled task)."""
    from chamify.services.health_score_service import HealthScoreService
    return HealthScoreService.calculate_score(group_id)


@shared_task
def send_payment_reminder(member_id, message):
    """Send SMS reminder to member."""
    # Placeholder for SMS integration
    from chamify.models import Member
    member = Member.objects.get(id=member_id)
    return {'status': 'reminder_sent', 'member': member.full_name, 'phone': member.phone_number}