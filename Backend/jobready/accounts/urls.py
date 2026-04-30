from django.urls import path, include
from rest_framework.routers import DefaultRouter
# ADD AllJobsListView TO YOUR IMPORTS
from .views import (
    UserViewSet, 
    CandidateProfileViewSet, 
    login_view, 
    AdminDashboardView, 
    GenerateReportView,
    AllJobsListView 
)

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')
router.register(r'profiles', CandidateProfileViewSet, basename='candidate-profile')

urlpatterns = [
    path('admin/report/', GenerateReportView.as_view()),
    path('', include(router.urls)),
    path('login/', login_view, name='login'),  
    path('admin/dashboard/', AdminDashboardView.as_view()),
    
    # ADD THIS LINE TO MATCH YOUR FLUTTER CALL
    path('admin/all-jobs/', AllJobsListView.as_view()),
]