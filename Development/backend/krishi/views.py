from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from krishi.serializers import UserRegistrationSerializer, UserLoginSerializer
from django.contrib.auth import authenticate
from krishi.renders import UserRenderer
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