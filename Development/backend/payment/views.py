from django.conf import settings
from django.shortcuts import redirect
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import EsewaPayment
import uuid
import requests
from django.conf import settings

# class EsewaPaymentRequestView(APIView):
#     def post(self, request):
#         user = request.user  # Ensure user is authenticated
#         amount = request.data.get("amount")

#         if not amount:
#             return Response({"error": "Amount is required"}, status=status.HTTP_400_BAD_REQUEST)

#         # Generate Unique Transaction ID
#         transaction_id = str(uuid.uuid4().hex[:12])  # Unique 12-character transaction ID

#         # Store payment in database (Pending)
#         EsewaPayment.objects.create(
#             user=user,
#             amount=amount,
#             transaction_id=transaction_id,
#             status="Pending"
#         )

#         # eSewa Payment URL
#         esewa_url = f"https://uat.esewa.com.np/epay/main"
        
#         # Redirect to eSewa with required parameters
#         payment_url = f"{esewa_url}?amt={amount}&scd={settings.ESEWA_MERCHANT_ID}&txAmt=0&psc=0&dc=0&pid={transaction_id}&su={settings.ESEWA_SUCCESS_URL}&fu={settings.ESEWA_FAILURE_URL}"

#         return Response({"esewa_url": payment_url}, status=status.HTTP_200_OK)

# import requests

# class EsewaPaymentSuccessView(APIView):
#     def get(self, request):
#         transaction_id = request.GET.get("oid")
#         amount = request.GET.get("amt")
#         ref_id = request.GET.get("refId")

#         # Verify payment with eSewa
#         verification_response = requests.post(settings.ESEWA_VERIFICATION_API, data={
#             "amt": amount,
#             "scd": settings.ESEWA_MERCHANT_ID,
#             "rid": ref_id,
#             "pid": transaction_id,
#         })

#         if verification_response.status_code == 200:
#             # Update payment status
#             payment = EsewaPayment.objects.get(transaction_id=transaction_id)
#             payment.status = "Completed"
#             payment.save()

#             return Response({"message": "Payment Successful", "transaction_id": transaction_id}, status=status.HTTP_200_OK)
#         else:
#             return Response({"error": "Payment verification failed"}, status=status.HTTP_400_BAD_REQUEST)

# class EsewaPaymentFailureView(APIView):
#     def get(self, request):
#         transaction_id = request.GET.get("oid")

#         # Mark transaction as failed
#         payment = EsewaPayment.objects.get(transaction_id=transaction_id)
#         payment.status = "Failed"
#         payment.save()

#         return Response({"error": "Payment Failed"}, status=status.HTTP_400_BAD_REQUEST)



class EsewaPaymentRequestView(APIView):
    
    authentication_classes = []
    def post(self, request):
        print("🔹 Received Payment Request:", request.data)  # ✅ Log request data

        user = request.user  # Ensure user is authenticated
        amount = request.data.get("amount")

        if not amount:
            print("Error: Amount is missing")
            return Response({"error": "Amount is required"}, status=status.HTTP_400_BAD_REQUEST)

        # Generate Unique Transaction ID
        transaction_id = str(uuid.uuid4().hex[:12])  # Unique 12-character transaction ID
        print(f"✅ Generated Transaction ID: {transaction_id}")

        # Store payment in database (Pending)
        try:
            EsewaPayment.objects.create(
                user=user,
                amount=amount,
                transaction_id=transaction_id,
                status="Pending"
            )
            print("✅ Payment entry saved in database")
        except Exception as e:
            print(f"Error saving payment: {e}")
            return Response({"error": "Database error"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # eSewa Payment URL
        esewa_url = f"https://uat.esewa.com.np/epay/main"

        # Redirect to eSewa with required parameters
        payment_url = f"{esewa_url}?amt={amount}&scd={settings.ESEWA_MERCHANT_ID}&txAmt=0&psc=0&dc=0&pid={transaction_id}&su={settings.ESEWA_SUCCESS_URL}&fu={settings.ESEWA_FAILURE_URL}"
        print(f"✅ Generated Payment URL: {payment_url}")

        return Response({"esewa_url": payment_url}, status=status.HTTP_200_OK)
    
class EsewaPaymentSuccessView(APIView):
    def get(self, request):
        transaction_id = request.GET.get("oid")
        amount = request.GET.get("amt")
        ref_id = request.GET.get("refId")

        # Verify payment with eSewa
        verification_response = requests.post(settings.ESEWA_VERIFICATION_API, data={
            "amt": amount,
            "scd": settings.ESEWA_MERCHANT_ID,
            "rid": ref_id,
            "pid": transaction_id,
        })

        if verification_response.status_code == 200:
            # Update payment status
            try:
                payment = EsewaPayment.objects.get(transaction_id=transaction_id)
                payment.status = "Completed"
                payment.save()
                return Response({"message": "Payment Successful", "transaction_id": transaction_id}, status=status.HTTP_200_OK)
            except EsewaPayment.DoesNotExist:
                return Response({"error": "Payment record not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "Payment verification failed"}, status=status.HTTP_400_BAD_REQUEST)

class EsewaPaymentFailureView(APIView):
    def get(self, request):
        transaction_id = request.GET.get("oid")

        try:
            payment = EsewaPayment.objects.get(transaction_id=transaction_id)
            payment.status = "Failed"
            payment.save()
            return Response({"error": "Payment Failed"}, status=status.HTTP_400_BAD_REQUEST)
        except EsewaPayment.DoesNotExist:
            return Response({"error": "Payment record not found"}, status=status.HTTP_404_NOT_FOUND)