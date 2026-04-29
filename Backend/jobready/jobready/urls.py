"""
URL configuration for jobready project.
"""
from accounts.views import login_view
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('admin/', admin.site.urls),

    path('api/login/', login_view),

    path('api/accounts/', include('accounts.urls')),
    path('api/jobs/', include('jobs.urls')),
    path('api/ai/', include('ai_engine.urls')),

    path('api/token/', TokenObtainPairView.as_view()),
    path('api/token/refresh/', TokenRefreshView.as_view()),
]

# ================= MEDIA (RESUME, FILES) =================
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)