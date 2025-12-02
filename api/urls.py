from django.urls import path
from .views import health, register, me
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
	path("health/", health, name="health"),
	path('auth/register/', register, name='register'),
	#JWT endpoints
	path('auth/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
	path('auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
	path('auth/me/', me, name='me'),
]
