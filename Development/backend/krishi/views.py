from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from krishi.serializers import UserRegistrationSerializer, UserLoginSerializer, UserProfileSerializer
from django.contrib.auth import authenticate
from krishi.renders import UserRenderer
from django.http import JsonResponse
import requests
import csv
from io import StringIO
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated

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
    

class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data.get("refresh")  # Get refresh token
            if not refresh_token:
                return Response({"error": "Refresh token is required"}, status=status.HTTP_400_BAD_REQUEST)

            token = RefreshToken(refresh_token)
            token.blacklist()  # Blacklist the refresh token

            return Response({"message": "Logout successful"}, status=status.HTTP_205_RESET_CONTENT)

        except Exception as e:
            return Response({"error": f"Logout failed: {str(e)}"}, status=status.HTTP_400_BAD_REQUEST)
        


class MarketPriceView(APIView):
    def get(self, request):
        api_url = "https://opendatanepal.com/dataset/af321d1f-979b-4780-9f87-790413bd2270/resource/06a18d43-c7ef-42d7-96a7-284671f731bd/download/kalimati_tarkari_dataset_cleaned.csv"
        
        try:
            # Fetch the CSV data
            response = requests.get(api_url)
            response.raise_for_status()  # Raise an error for bad responses (4xx, 5xx)

            # Convert CSV text into a file-like object
            csv_data = StringIO(response.text)
            reader = csv.DictReader(csv_data)

            # Convert CSV rows into a list of dictionaries
            market_data = [row for row in reader]
            
            return Response(market_data, status=status.HTTP_200_OK)
        
        except requests.exceptions.RequestException as e:
            return Response({"error": f"Failed to fetch market price data: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        except csv.Error as e:
            return Response({"error": f"CSV parsing error: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        
class WeatherAPIView(APIView):
    def get(self, request):
        city = request.query_params.get("city", "Kathmandu")  # Default city is Kathmandu
        api_key = "f5131087005445fd17663c90fc3dc391"  # Replace with your OpenWeatherMap API key
        weather_api_url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"

        try:
            # Fetch data from OpenWeatherMap API
            response = requests.get(weather_api_url)
            response.raise_for_status()  # Raise an error for HTTP errors
            weather_data = response.json()

            # Extract relevant information
            formatted_data = {
                "location": weather_data["name"],  # City name
                "temperature": weather_data["main"]["temp"],  # Current temperature
                "high": weather_data["main"]["temp_max"],  # Maximum temperature
                "low": weather_data["main"]["temp_min"],  # Minimum temperature
                "weather": weather_data["weather"][0]["description"],  # Weather description
            }

            return Response(formatted_data, status=status.HTTP_200_OK)

        except requests.exceptions.RequestException as e:
            return Response({"error": f"Failed to fetch weather data: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        except KeyError as e:
            return Response({"error": f"Missing data field: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user  # Get the logged-in user
        serializer = UserProfileSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)