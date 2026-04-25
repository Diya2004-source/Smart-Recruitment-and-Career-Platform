from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from rest_framework.decorators import action, api_view, permission_classes
from django.contrib.auth import authenticate
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator

from .models import User, CandidateProfile, RecruiterProfile
from .serializers import (
    UserSerializer,
    CandidateProfileSerializer,
    RecruiterProfileSerializer
)

# ================= USER =================
@method_decorator(csrf_exempt, name='dispatch')
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    authentication_classes = []   
    permission_classes = [permissions.AllowAny]

    def get_permissions(self):
        if self.action == 'create':   # REGISTER
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]


# ================= CANDIDATE PROFILE =================
@method_decorator(csrf_exempt, name='dispatch')
class CandidateProfileViewSet(viewsets.ModelViewSet):
    queryset = CandidateProfile.objects.all()
    serializer_class = CandidateProfileSerializer

    authentication_classes = []
    permission_classes = [permissions.AllowAny]

    @action(detail=False, methods=['get', 'patch'])
    def me(self, request):
        profile, created = CandidateProfile.objects.get_or_create(user=request.user)

        if request.method == 'GET':
            return Response(self.get_serializer(profile).data)

        serializer = self.get_serializer(profile, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)


# ================= RECRUITER PROFILE =================
@method_decorator(csrf_exempt, name='dispatch')
class RecruiterProfileViewSet(viewsets.ModelViewSet):
    queryset = RecruiterProfile.objects.all()
    serializer_class = RecruiterProfileSerializer

    authentication_classes = []
    permission_classes = [permissions.AllowAny]


# ================= LOGIN API =================
@api_view(['POST'])
@permission_classes([permissions.AllowAny])
@csrf_exempt
def login_view(request):
    email = request.data.get('email')
    password = request.data.get('password')

    if not email or not password:
        return Response(
            {"error": "Email and password required"},
            status=status.HTTP_400_BAD_REQUEST
        )

    try:
        user = User.objects.get(email=email)
        username = user.username
    except User.DoesNotExist:
        return Response(
            {"error": "Invalid credentials"},
            status=status.HTTP_401_UNAUTHORIZED
        )

    user = authenticate(username=username, password=password)

    if user:
        return Response({
            "message": "Login successful",
            "user_id": user.id,
            "email": user.email,
            "role": user.role
        }, status=status.HTTP_200_OK)

    return Response(
        {"error": "Invalid credentials"},
        status=status.HTTP_401_UNAUTHORIZED
    )