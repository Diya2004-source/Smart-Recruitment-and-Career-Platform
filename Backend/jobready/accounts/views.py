from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from rest_framework.decorators import action
from .models import User, CandidateProfile, RecruiterProfile
from .serializers import (
    UserSerializer, 
    CandidateProfileSerializer, 
    RecruiterProfileSerializer
)

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def get_permissions(self):
        if self.action == 'create': # Anyone can register
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]

class CandidateProfileViewSet(viewsets.ModelViewSet):
    queryset = CandidateProfile.objects.all()
    serializer_class = CandidateProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    # Helper method to get the current user's profile easily
    @action(detail=False, methods=['get', 'patch'])
    def me(self, request):
        profile, created = CandidateProfile.objects.get_or_create(user=request.user)
        if request.method == 'GET':
            serializer = self.get_serializer(profile)
            return Response(serializer.data)
        
        serializer = self.get_serializer(profile, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)