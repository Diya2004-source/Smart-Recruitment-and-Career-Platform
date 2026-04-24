from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AIProcessViewSet, MockInterviewViewSet

router = DefaultRouter()
router.register(r'process', AIProcessViewSet, basename='ai-process')
router.register(r'interviews', MockInterviewViewSet, basename='mock-interview')

urlpatterns = [
    path('', include(router.urls)),
]