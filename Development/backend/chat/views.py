from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from .models import ChatRoom, Message
from .serializers import ChatRoomSerializer, MessageSerializer
from django.contrib.auth import get_user_model

User = get_user_model()

# ✅ List or Create Chat Rooms
class ChatRoomView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        chat_rooms = ChatRoom.objects.filter(users=request.user)
        serializer = ChatRoomSerializer(chat_rooms, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        """Create a new chat room."""
        name = request.data.get("name")
        if ChatRoom.objects.filter(name=name).exists():
            return Response({"error": "Room already exists"}, status=status.HTTP_400_BAD_REQUEST)

        chat_room = ChatRoom.objects.create(name=name)
        chat_room.users.add(request.user)
        serializer = ChatRoomSerializer(chat_room)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

# ✅ Fetch or Send Messages
class MessageView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, room_id):
        messages = Message.objects.filter(chat_room_id=room_id).order_by("timestamp")
        serializer = MessageSerializer(messages, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request, room_id):
        """Send a new message."""
        chat_room = ChatRoom.objects.get(id=room_id)
        message = Message.objects.create(
            chat_room=chat_room,
            sender=request.user,
            content=request.data["content"]
        )
        serializer = MessageSerializer(message)
        return Response(serializer.data, status=status.HTTP_201_CREATED)