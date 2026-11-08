import csv
import io
from decimal import Decimal
from chamify.models import Member, Contribution, Fine, Loan


class CsvImportService:
    """Service for CSV/Excel migration assistant."""

    COLUMN_MAPPING = {
        'member_name': ['member_name', 'name', 'full_name'],
        'phone': ['phone', 'phone_number', 'telephone'],
        'amount': ['amount', 'contribution_amount'],
        'date': ['date', 'contribution_date'],
        'contribution_type': ['contribution_type', 'type'],
        'fine': ['fine', 'fine_amount'],
        'loan_repayment': ['loan_repayment', 'loan_paid'],
    }

    @staticmethod
    def parse_csv(file_content):
        """Parse CSV content and return rows."""
        reader = csv.DictReader(io.StringIO(file_content))
        return list(reader)

    @staticmethod
    def validate_row(row):
        """Validate a single row and return errors."""
        errors = []

        # Validate phone
        phone = row.get('phone') or row.get('phone_number') or ''
        if phone and not phone.startswith('07') and not phone.startswith('+254'):
            errors.append(f'Invalid phone number: {phone}')

        # Validate amount
        amount = row.get('amount') or row.get('contribution_amount') or ''
        if amount:
            try:
                Decimal(str(amount))
            except Exception:
                errors.append(f'Invalid amount: {amount}')

        # Validate date
        date = row.get('date') or row.get('contribution_date') or ''
        if date:
            try:
                from datetime import datetime
                datetime.strptime(date, '%Y-%m-%d')
            except Exception:
                errors.append(f'Invalid date: {date}')

        return errors

    @staticmethod
    def import_members(group, rows, user):
        """Import members from validated rows."""
        imported = 0
        skipped = 0
        errors = []

        for i, row in enumerate(rows):
            row_errors = CsvImportService.validate_row(row)
            if row_errors:
                skipped += 1
                errors.append(f'Row {i + 1}: {"; ".join(row_errors)}')
                continue

            Member.objects.create(
                group=group,
                member_number=row.get('member_number', f'M{i+1:03d}'),
                full_name=row.get('member_name', row.get('name', '')),
                phone_number=row.get('phone', row.get('phone_number', '')),
                id_number=row.get('id_number', ''),
                recorded_by=user,
            )
            imported += 1

        return {'imported': imported, 'skipped': skipped, 'errors': errors}