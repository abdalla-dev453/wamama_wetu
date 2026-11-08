from chamify.models import Member, Contribution, Fine


class CollectionService:
    """Service for collection-day mode operations."""

    @staticmethod
    def get_collection_status(group):
        """Get collection status for all members."""
        members = Member.objects.filter(group=group, is_active=True)
        total_expected = sum(m.outstanding_balance + m.total_contributed for m in members)
        total_collected = sum(m.total_contributed for m in members)
        total_outstanding = total_expected - total_collected

        paid = members.filter(outstanding_balance=0).count()
        partial = members.filter(outstanding_balance__gt=0, outstanding_balance__lt=1000).count()
        unpaid = members.filter(outstanding_balance__gte=1000).count()

        return {
            'expected': total_expected,
            'collected': total_collected,
            'outstanding': total_outstanding,
            'paid_count': paid,
            'partial_count': partial,
            'unpaid_count': unpaid,
            'members': members,
        }

    @staticmethod
    def record_cash_contribution(member, amount, recorded_by):
        """Record a cash contribution during a meeting."""
        from chamify.models import Contribution
        contribution = Contribution.objects.create(
            member=member,
            group=member.group,
            amount=amount,
            date__=None,  # Will be set by auto_now
            type='one_off',
            is_cash=True,
            recorded_by=recorded_by,
        )
        member.total_contributed += amount
        member.outstanding_balance = max(0, member.outstanding_balance - amount)
        member.save()
        return contribution