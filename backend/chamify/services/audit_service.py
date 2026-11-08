from chamify.models import AuditEntry, AuditAction


class AuditService:
    """Service for creating immutable audit trail entries."""

    @staticmethod
    def log_action(group, actor, action, before_values=None, after_values=None,
                   reason=None, device_id=None, session_id=None, ip_address=None,
                   target_type=None, target_id=None, approver=None):
        """Create an audit entry for any sensitive action."""
        return AuditEntry.objects.create(
            group=group,
            actor=actor,
            approver=approver,
            action=action,
            before_values=before_values,
            after_values=after_values,
            reason=reason,
            device_id=device_id,
            session_id=session_id,
            ip_address=ip_address,
            target_type=target_type,
            target_id=target_id,
        )