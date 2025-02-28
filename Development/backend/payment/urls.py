from django.urls import path
from .views import EsewaPaymentRequestView, EsewaPaymentSuccessView, EsewaPaymentFailureView

urlpatterns = [
    path("esewa-payment/", EsewaPaymentRequestView.as_view(), name="esewa-payment"),  # ✅ Fix: Add .as_view()
    path("esewa-success/", EsewaPaymentSuccessView.as_view(), name="esewa-success"),  # ✅ Fix: Add .as_view()
    path("esewa-failure/", EsewaPaymentFailureView.as_view(), name="esewa-failure"),  # ✅ Fix: Add .as_view()
]