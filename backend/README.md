# Chamify Backend

Django REST API for the Chamify chama management app.

## Setup

```bash
cd backend
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

## Celery (for background tasks)

```bash
celery -A chamify worker -l info
celery -A chamify beat -l info
```

## API Endpoints

- `GET/POST /api/groups/` - Group management
- `GET/POST /api/members/` - Member management
- `GET/POST /api/contributions/` - Contribution ledger
- `GET/POST /api/mpesa-payments/` - M-PESA payments
- `POST /api/mpesa-payments/reconcile/` - Reconcile payment
- `GET /api/mpesa-payments/unmatched_queue/` - Unmatched payments
- `POST /api/mpesa-payments/{id}/generate_receipt/` - Generate receipt
- `GET/POST /api/rotations/` - Rotation engine
- `GET /api/audit/` - Audit trail (read-only)
- `GET/POST /api/health-scores/` - Health scores
- `POST /api/health-scores/calculate/` - Calculate score
- `GET/POST /api/loans/` - Loans
- `GET/POST /api/fines/` - Fines
- `GET/POST /api/receipts/` - Payment receipts

## M-PESA Reconciliation State Machine

received → validating → matched/unmatched → allocated → posted/reversed

- Exact match: auto-allocated and posted
- Partial/overpayment: allocated, requires treasurer review
- Unmatched: requires treasurer assignment with reason
- Posted payments: can only be reversed (creating reversing entry)