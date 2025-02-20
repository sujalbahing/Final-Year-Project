from django.urls import path
from krishi.views import UserRegistrationView, UserLoginView, MarketPriceView, WeatherAPIView, LogoutView, UserProfileView

urlpatterns = [
    path('register/', UserRegistrationView.as_view(), name='register'),
    path('login/', UserLoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('market-price/',MarketPriceView.as_view(), name='market'),
    path('weather/',WeatherAPIView.as_view(), name='weather'),
    path('profile/', UserProfileView.as_view(), name='profile'),
]
