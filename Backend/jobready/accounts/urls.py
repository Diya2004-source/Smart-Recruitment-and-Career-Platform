from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, CandidateProfileViewSet, login_view , AdminDashboardView , GenerateReportView

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')
router.register(r'profiles', CandidateProfileViewSet, basename='candidate-profile')

urlpatterns = [
    path('admin/report/', GenerateReportView.as_view()),
    path('', include(router.urls)),
    path('login/', login_view, name='login'),  
    path('admin/dashboard/', AdminDashboardView.as_view()),

]