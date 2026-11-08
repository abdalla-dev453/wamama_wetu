from django.db.models import Sum, Count, Q
from django.utils import timezone
from chamify.models import GroupHealthScore, Member, Contribution, MpesaPayment, MpesaPaymentStatus, Loan, Fine


class HealthScoreService:
    """Service for calculating group health score (0-100)."""

    WEIGHTS = {
        'collection_rate': 30,
        'arrears_rate': 25,
        'loan_repayment_rate': 25,
        'meeting_attendance': 10,
        'unmatched_payments': 10,
    }

    @staticmethod
    def calculate_score(group):
        """Calculate health score for a group."""
        members = Member.objects.filter(group=group, is_active=True)

        # Collection rate
        total_expected = members.aggregate(
            total=Sum('outstanding_balance') + Sum('total_contributed')
        )['total'] or 0
        total_collected = members.aggregate(total=Sum('total_contributed'))['total'] or 0
        collection_rate = (total_collected / total_expected * 100) if total_expected > 0 else 100

        # Arrears rate
        members_with_arrears = members.filter(outstanding_balance__gt=0).count()
        arrears_rate = (members_with_arrears / members.count() * 100) if members.count() > 0 else 0

        # Loan repayment rate
        loans = Loan.objects.filter(group=group)
        total_loan_amount = loans.aggregate(total=Sum('total_amount'))['total'] or 0
        total_repaid = loans.aggregate(total=Sum('amount_repaid'))['total'] or 0
        loan_repayment_rate = (total_repaid / total_loan_amount * 100) if total_loan_amount > 0 else 100

        # Meeting attendance (placeholder - would come from meeting model)
        meeting_attendance_rate = 85  # Placeholder

        # Unmatched payments
        unmatched_count = MpesaPayment.objects.filter(
            group=group,
            status=MpesaPaymentStatus.UNMATCHED,
        ).count()

        # Calculate weighted score
        collection_score = min(collection_rate, 100) * HealthScoreService.WEIGHTS['collection_rate'] / 100
        arrears_score = max(0, 100 - arrears_rate) * HealthScoreService.WEIGHTS['arrears_rate'] / 100
        loan_score = min(loan_repayment_rate, 100) * HealthScoreService.WEIGHTS['loan_repayment_rate'] / 100
        attendance_score = meeting_attendance_rate * HealthScoreService.WEIGHTS['meeting_attendance'] / 100
        unmatched_score = max(0, 100 - unmatched_count * 10) * HealthScoreService.WEIGHTS['unmatched_payments'] / 100

        total_score = int(collection_score + arrears_score + loan_score + attendance_score + unmatched_score)

        # Generate recommended actions
        recommendations = []
        if collection_rate < 80:
            recommendations.append(f'Send reminders to {members_with_arrears} members with arrears')
        if arrears_rate > 20:
            recommendations.append('Schedule meeting to discuss collection strategy')
        if loan_repayment_rate < 70:
            recommendations.append('Follow up on overdue loans')
        if unmatched_count > 0:
            recommendations.append(f'Review {unmatched_count} unmatched M-PESA payments')
        if meeting_attendance_rate < 70:
            recommendations.append('Improve meeting attendance')

        if not recommendations:
            recommendations.append('Group is performing well - maintain current practices')

        score = GroupHealthScore.objects.create(
            group=group,
            score=min(100, max(0, total_score)),
            collection_rate=collection_rate,
            arrears_rate=arrears_rate,
            loan_repayment_rate=loan_repayment_rate,
            meeting_attendance_rate=meeting_attendance_rate,
            unmatched_payments_count=unmatched_count,
            recommended_actions=recommendations,
        )
        return score