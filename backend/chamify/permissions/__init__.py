from rest_framework import permissions


class IsTreasurerOrChairperson(permissions.BasePermission):
    """Permission for treasurer or chairperson actions."""

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        # Allow treasurer or chairperson of the group
        if hasattr(obj, 'group'):
            group = obj.group
        elif hasattr(obj, 'group_id'):
            from chamify.models import Group
            try:
                group = Group.objects.get(id=obj.group_id)
            except Group.DoesNotExist:
                return False
        else:
            return False

        return (
            group.treasurer_id == request.user.id or
            group.chairperson_id == request.user.id or
            request.user.is_staff
        )


class CanReconcilePayments(permissions.BasePermission):
    """Permission for M-PESA reconciliation - treasurer only."""

    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        from chamify.models import Group
        try:
            group = Group.objects.get(id=obj.group_id)
        except Group.DoesNotExist:
            return False
        return group.treasurer_id == request.user.id or request.user.is_staff