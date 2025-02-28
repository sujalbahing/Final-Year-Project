
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/user/', include('krishi.urls')),
    path('api/chat/', include('chat.urls')),
    path("api/payment/", include("payment.urls")),
]
