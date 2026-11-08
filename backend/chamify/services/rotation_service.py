from chamify.models import RotationEntry, RotationOrderType, Member


class RotationService:
    """Service for transparent rotation engine."""

    @staticmethod
    def get_current_recipient(group):
        """Get the current rotation recipient."""
        return RotationEntry.objects.filter(
            group=group,
            is_paid_out=False,
        ).order_by('position').first()

    @staticmethod
    def get_rotation_history(group):
        """Get full rotation history."""
        return RotationEntry.objects.filter(group=group).order_by('position')

    @staticmethod
    def schedule_swap(group, from_position, to_position, approved_by, reason=None):
        """Schedule a swap between two positions."""
        from chamify.models import AuditEntry, AuditAction
        from django.utils import timezone

        entry_from = RotationEntry.objects.get(group=group, position=from_position)
        entry_to = RotationEntry.objects.get(group=group, position=to_position)

        # Swap positions
        entry_from.position, entry_to.position = to_position, from_position
        entry_from.order_type = RotationOrderType.SWAP
        entry_to.order_type = RotationOrderType.SWAP
        entry_from.swapped_from = entry_from.member
        entry_from.swapped_to = entry_to.member
        entry_to.swapped_from = entry_to.member
        entry_to.swapped_to = entry_from.member
        entry_from.approved_by = approved_by
        entry_to.approved_by = approved_by
        entry_from.save()
        entry_to.save()

        AuditEntry.objects.create(
            group=group,
            actor=approved_by,
            action=AuditAction.ROTATION_SWAP,
            before_values={'position': from_position, 'other_position': to_position},
            after_values={'position': to_position, 'other_position': from_position},
            reason=reason,
            target_type='rotation',
            target_id=entry_from.id,
        )

    @staticmethod
    def postpone_payout(group, position, new_date, approved_by, reason):
        """Postpone a payout date."""
        entry = RotationEntry.objects.get(group=group, position=position)
        entry.payout_date = new_date
        entry.order_type = RotationOrderType.POSTPONEMENT
        entry.postponement_reason = reason
        entry.approved_by = approved_by
        entry.save()
        return entry