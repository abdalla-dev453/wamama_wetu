from django.urls import path, include
from rest_framework.routers import DefaultRouter
from chamify.api.views import (
    GroupViewSet, MemberViewSet, ContributionViewSet,
    MpesaPaymentViewSet, RotationEntryViewSet, AuditEntryViewSet,
    GroupHealthScoreViewSet, LoanViewSet, FineViewSet,
    PaymentReceiptViewSet,
)

router = DefaultRouter()
router.register(r'groups', GroupViewSet)
router.register(r'members', MemberViewSet)
router.register(r'contributions', ContributionViewSet)
router.register(r'mpesa-payments', MpesaPaymentViewSet)
router.register(r'rotations', RotationEntryViewSet)
router.register(r'audit', AuditEntryViewSet)
router.register(r'health-scores', GroupHealthScoreViewSet)
router.register(r'loans', LoanViewSet)
router.register(r'fines', FineViewSet)
router.register(r'receipts', PaymentReceiptViewSet)

urlpatterns = [
    path('', include(router.urls)),
]