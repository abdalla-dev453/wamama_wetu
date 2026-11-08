from rest_framework import serializers
from chamify.models import (
    Group, Member, Contribution, MpesaPayment, MpesaPaymentStatus,
    RotationEntry, AuditEntry, GroupHealthScore, Loan, Fine, PaymentReceipt
)


class GroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = '__all__'
        read_only_fields = ['id', 'created_at', 'updated_at']


class MemberSerializer(serializers.ModelSerializer):
    class Meta:
        model = Member
        fields = '__all__'
        read_only_fields = ['id', 'joined_at']


class ContributionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contribution
        fields = '__all__'
        read_only_fields = ['id', 'created_at']


class MpesaPaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = MpesaPayment
        fields = '__all__'
        read_only_fields = ['id', 'created_at', 'updated_at']

    def validate_status(self, value):
        if self.instance:
            current = self.instance.status
            if not self.instance.can_transition(value):
                raise serializers.ValidationError(
                    f'Invalid transition from {current} to {value}'
                )
        return value


class RotationEntrySerializer(serializers.ModelSerializer):
    class Meta:
        model = RotationEntry
        fields = '__all__'
        read_only_fields = ['id', 'created_at']


class AuditEntrySerializer(serializers.ModelSerializer):
    class Meta:
        model = AuditEntry
        fields = '__all__'
        read_only_fields = ['id', 'timestamp']


class GroupHealthScoreSerializer(serializers.ModelSerializer):
    class Meta:
        model = GroupHealthScore
        fields = '__all__'
        read_only_fields = ['id', 'calculated_at']


class LoanSerializer(serializers.ModelSerializer):
    class Meta:
        model = Loan
        fields = '__all__'
        read_only_fields = ['id', 'issued_at']


class FineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Fine
        fields = '__all__'
        read_only_fields = ['id', 'issued_at']


class PaymentReceiptSerializer(serializers.ModelSerializer):
    class Meta:
        model = PaymentReceipt
        fields = '__all__'
        read_only_fields = ['id', 'generated_at']


class ReconcilePaymentSerializer(serializers.Serializer):
    """Serializer for payment reconciliation action."""
    payment_id = serializers.CharField()
    action = serializers.ChoiceField(choices=['match', 'assign', 'reverse', 'post'])
    member_id = serializers.CharField(required=False, allow_blank=True)
    reason = serializers.CharField(required=False, allow_blank=True)