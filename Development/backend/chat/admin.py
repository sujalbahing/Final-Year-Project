# from django.contrib import admin
# from .models import ChatRoom, Message

# # ✅ Register ChatRoom Model
# @admin.register(ChatRoom)
# class ChatRoomAdmin(admin.ModelAdmin):
#     list_display = ('id', 'name')  # Shows ID and name in the admin panel
#     search_fields = ('name',)  # Adds a search box for chat rooms

# # ✅ Register Message Model
# @admin.register(Message)
# class MessageAdmin(admin.ModelAdmin):
#     list_display = ('id', 'chat_room', 'sender', 'content', 'timestamp')
#     list_filter = ('chat_room', 'sender')  # Adds filters to filter by room or sender
#     search_fields = ('content', 'sender__username')  # Enables searching messages
#     ordering = ('-timestamp',)  # Sorts messages by latest first