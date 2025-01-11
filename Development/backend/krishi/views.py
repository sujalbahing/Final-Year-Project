from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from krishi.serializers import UserRegistrationSerializer, UserLoginSerializer
from django.contrib.auth import authenticate
from krishi.renders import UserRenderer
from django.http import JsonResponse
import requests
import csv
from io import StringIO
from rest_framework_simplejwt.tokens import RefreshToken

# Generate Token Manually
def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

class UserRegistrationView(APIView):
    renderer_classes = [UserRenderer]

    def post(self, request, format=None):
        serializer = UserRegistrationSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            user = serializer.save()

            # Generate token for the user
            token = get_tokens_for_user(user)

            # Format user data for response
            user_data = {
                'id': user.id,
                'username': user.name,
                'email': user.email,
                'password': str(user.password),  # Avoid sending raw password; this is for demo purposes
                'phone': user.phone if hasattr(user, 'phone') else None,
                'address': user.address if hasattr(user, 'address') else None,
                'created_at': user.created_at.isoformat(),
                'updated_at': user.updated_at.isoformat(),
                'is_admin': user.is_admin,
                'tc': user.tc,
            }
            return Response(
                {
                    "message": "User created successfully",
                    "user": user_data,
                },
                status=status.HTTP_201_CREATED,
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserLoginView(APIView):
    def post(self, request, format=None):
        serializer = UserLoginSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            email = serializer.data.get('email')
            password = serializer.data.get('password')
            user = authenticate(email=email, password=password)
            if user is not None:
                token = get_tokens_for_user(user)
                return Response(
                    {"token": token, "msg": "Login Successful"},
                    status=status.HTTP_200_OK,
                )
            else:
                return Response(
                    {
                        "errors": {
                            "non_field_errors": ["Email or Password is not valid"]
                        }
                    },
                    status=status.HTTP_404_NOT_FOUND,
                )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# View Market Price
def market_price_view(request):
    api_url = "https://opendatanepal.com/dataset/af321d1f-979b-4780-9f87-790413bd2270/resource/06a18d43-c7ef-42d7-96a7-284671f731bd/download/kalimati_tarkari_dataset_cleaned.csv"
    try:
        # Fetch the CSV data
        response = requests.get(api_url)
        response.raise_for_status()
        
        # Parse the CSV data
        csv_data = StringIO(response.text)  # Convert the CSV content into a file-like object
        reader = csv.DictReader(csv_data)  # Parse CSV into a dictionary

        # Convert CSV rows to a list of dictionaries
        market_data = [row for row in reader]
    except requests.exceptions.RequestException as e:
        return JsonResponse({"error": str(e)}, status=500)

    return JsonResponse(market_data, safe=False)  # Return parsed data as JSON