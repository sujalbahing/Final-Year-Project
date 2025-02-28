from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class ChatRoom(models.Model):
    """Model for storing chat rooms."""
    name = models.CharField(max_length=255, unique=True)
    users = models.ManyToManyField(User, related_name="chat_rooms")

    def __str__(self):
        return self.name

class Message(models.Model):
    """Model for storing messages."""
    chat_room = models.ForeignKey(ChatRoom, on_delete=models.CASCADE, related_name="messages")
    sender = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.sender.username}: {self.content[:30]}"