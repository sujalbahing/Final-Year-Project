from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated
from .models import User
from .serializers import UserSerializer, LoginSerializer


# Create your views here.

# class UserApi(APIView):
#     permission_classes = [IsAuthenticated]
#     def get(self, request):
#         queryset = User.objects.all()
#         serializer = UserSerializer(queryset, many=True)
#         return Response({
#             "status" : True,
#             "data" : serializer.data
#         })
        
        
# class LoginApi(APIView):
#     def post(self, request):
#         data = request.data
#         serializer = LoginSerializer(data=data)
#         if not serializer.is_valid():
#             return Response({
#                 "status" : False,
#                 "data " : serializer.errors
#             })
        
#         username = serializer.data['username']
#         password = serializer.data['password']
        
#         user_obj = authenticate(username=username, password=password)
#         if user_obj:
#             token , _ = Token.objects.get_or_create(user=user_obj)
#             return Response({
#                 "status" : True,
#                 "data" : {
#                     "token" : str(token),
#                 }
#             })
            
            
#         return Response({
#             "status" : False,
#             "data" : {},
#             "message" : "Invalid credentials"
#         })

class UserApi(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        queryset = User.objects.all()
        serializer = UserSerializer(queryset, many=True)
        return Response({
            "status": True,
            "data": serializer.data
        })

class RegisterApi(APIView):
    def post(self, request):
        data = request.data
        serializer = UserSerializer(data=data)
        if not serializer.is_valid():
            return Response({
                "status": False,
                "errors": serializer.errors
            }, status=400)

        user = serializer.save()
        token, _ = Token.objects.get_or_create(user=user)
        return Response({
            "status": True,
            "message": "User registered successfully",
            "data": {
                "username": user.username,
                "email": user.email,
                "token": token.key
            }
        }, status=201)

class LoginApi(APIView):
    def post(self, request):
        data = request.data
        serializer = LoginSerializer(data=data)
        if not serializer.is_valid():
            return Response({
                "status": False,
                "errors": serializer.errors
            }, status=400)

        username = serializer.validated_data['username']
        password = serializer.validated_data['password']

        user_obj = authenticate(username=username, password=password)
        if user_obj:
            token, _ = Token.objects.get_or_create(user=user_obj)
            return Response({
                "status": True,
                "message": "Login successful",
                "data": {
                    "username": user_obj.username,
                    "token": token.key
                }
            }, status=200)

        return Response({
            "status": False,
            "message": "Invalid credentials"
        }, status=401)
