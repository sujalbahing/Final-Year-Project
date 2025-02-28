from django.urls import path
from .views import ChatRoomView, MessageView

urlpatterns = [
    path('chatrooms/', ChatRoomView.as_view(), name='chatrooms'),
    path('messages/<str:room_name>/', MessageView.as_view(), name='messages'),  # ✅ Accepts string room names
]