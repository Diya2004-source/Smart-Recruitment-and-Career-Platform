from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, CandidateProfileViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')
router.register(r'profiles', CandidateProfileViewSet, basename='candidate-profile')

urlpatterns = [
    path('', include(router.urls)),
]