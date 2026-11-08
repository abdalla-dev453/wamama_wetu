from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from chamify.models import (
    Group, Member, Contribution, MpesaPayment, MpesaPaymentStatus,
    RotationEntry, AuditEntry, GroupHealthScore, Loan, Fine, PaymentReceipt
)
from chamify.api.serializers import (
    GroupSerializer, MemberSerializer, ContributionSerializer,
    MpesaPaymentSerializer, RotationEntrySerializer, AuditEntrySerializer,
    GroupHealthScoreSerializer, LoanSerializer, FineSerializer,
    PaymentReceiptSerializer, ReconcilePaymentSerializer
)
from chamify.services.reconciliation_service import ReconciliationService
from chamify.services.receipt_service import ReceiptService
from chamify.services.health_score_service import HealthScoreService
from chamify.services.collection_service import CollectionService
from chamify.services.rotation_service import RotationService
from chamify.services.audit_service import AuditService
from chamify.permissions import IsTreasurerOrChairperson


class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer
    permission_classes = [IsAuthenticated]


class MemberViewSet(viewsets.ModelViewSet):
    queryset = Member.objects.all()
    serializer_class = MemberSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        group_id = self.request.query_params.get('group')
        if group_id:
            return self.queryset.filter(group_id=group_id, is_active=True)
        return self.queryset.filter(is_active=True)


class ContributionViewSet(viewsets.ModelViewSet):
    queryset = Contribution.objects.all()
    serializer_class = ContributionSerializer
    permission_classes = [IsAuthenticated]


class MpesaPaymentViewSet(viewsets.ModelViewSet):
    queryset = MpesaPayment.objects.all()
    serializer_class = MpesaPaymentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        group_id = self.request.query_params.get('group')
        status = self.request.query_params.get('status')
        qs = self.queryset.all()
        if group_id:
            qs = qs.filter(group_id=group_id)
        if status:
            qs = qs.filter(status=status)
        return qs

    @action(detail=False, methods=['post'])
    def reconcile(self, request):
        """Reconcile a M-PESA payment."""
        serializer = ReconcilePaymentSerializer(data=request.data)
        if serializer.is_valid():
            payment_id = serializer.validated_data['payment_id']
            action = serializer.validated_data['action']
            user = request.user

            try:
                payment = MpesaPayment.objects.get(id=payment_id)
            except MpesaPayment.DoesNotExist:
                return Response({'error': 'Payment not found'}, status=status.HTTP_404_NOT_FOUND)

            if action == 'match':
                result = ReconciliationService.reconcile_payment(payment, user=user)
                return Response({'status': 'reconciled', 'result': result[1]})
            elif action == 'assign':
                member_id = serializer.validated_data.get('member_id')
                reason = serializer.validated_data.get('reason')
                try:
                    member = Member.objects.get(id=member_id)
                except Member.DoesNotExist:
                    return Response({'error': 'Member not found'}, status=status.HTTP_404_NOT_FOUND)
                payment = ReconciliationService.assign_unmatched_payment(payment, member, user, reason)
                return Response({'status': 'assigned', 'payment': MpesaPaymentSerializer(payment).data})
            elif action == 'reverse':
                reason = serializer.validated_data.get('reason')
                payment = ReconciliationService.reverse_payment(payment, user, reason)
                return Response({'status': 'reversed', 'payment': MpesaPaymentSerializer(payment).data})
            elif action == 'post':
                if payment.status == MpesaPaymentStatus.ALLOCATED:
                    payment.transition(MpesaPaymentStatus.POSTED, user=user, reason='Posted by treasurer')
                    return Response({'status': 'posted', 'payment': MpesaPaymentSerializer(payment).data})
                return Response({'error': 'Payment must be allocated before posting'}, status=status.HTTP_400_BAD_REQUEST)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['get'])
    def unmatched_queue(self, request):
        """Get unmatched payments requiring treasurer review."""
        group_id = request.query_params.get('group')
        if not group_id:
            return Response({'error': 'group parameter required'}, status=status.HTTP_400_BAD_REQUEST)
        queue = ReconciliationService.get_unmatched_queue(group_id)
        serializer = self.get_serializer(queue, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def generate_receipt(self, request, pk=None):
        """Generate a payment proof receipt."""
        payment = self.get_object()
        allocation_type = request.data.get('allocation_type', 'contribution')
        allocation_reference = request.data.get('allocation_reference')

        if not payment.matched_member:
            return Response({'error': 'Payment must be matched to a member'}, status=status.HTTP_400_BAD_REQUEST)

        receipt = ReceiptService.generate_receipt(
            payment, payment.matched_member, allocation_type, allocation_reference
        )
        return Response(PaymentReceiptSerializer(receipt).data)


class RotationEntryViewSet(viewsets.ModelViewSet):
    queryset = RotationEntry.objects.all()
    serializer_class = RotationEntrySerializer
    permission_classes = [IsAuthenticated]


class AuditEntryViewSet(viewsets.ReadOnlyModelViewSet):
    """Audit trail is read-only - entries cannot be modified."""
    queryset = AuditEntry.objects.all()
    serializer_class = AuditEntrySerializer
    permission_classes = [IsAuthenticated]


class GroupHealthScoreViewSet(viewsets.ModelViewSet):
    queryset = GroupHealthScore.objects.all()
    serializer_class = GroupHealthScoreSerializer
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['post'])
    def calculate(self, request):
        """Calculate health score for a group."""
        group_id = request.data.get('group_id')
        if not group_id:
            return Response({'error': 'group_id required'}, status=status.HTTP_400_BAD_REQUEST)
        score = HealthScoreService.calculate_score(group_id)
        return Response(GroupHealthScoreSerializer(score).data)


class LoanViewSet(viewsets.ModelViewSet):
    queryset = Loan.objects.all()
    serializer_class = LoanSerializer
    permission_classes = [IsAuthenticated]


class FineViewSet(viewsets.ModelViewSet):
    queryset = Fine.objects.all()
    serializer_class = FineSerializer
    permission_classes = [IsAuthenticated]


class PaymentReceiptViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = PaymentReceipt.objects.all()
    serializer_class = PaymentReceiptSerializer
    permission_classes = [IsAuthenticated]