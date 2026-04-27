from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.views import APIView

from django.contrib.auth import authenticate
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator

from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.tokens import RefreshToken
from django.http import HttpResponse

from .models import User, CandidateProfile, RecruiterProfile
from .serializers import (
    UserSerializer,
    CandidateProfileSerializer,
    RecruiterProfileSerializer
)
from reportlab.pdfgen import canvas
from rest_framework.permissions import IsAuthenticated



# ================= CUSTOM PERMISSION =================
from rest_framework.permissions import BasePermission

class IsAdminUserRole(BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.role == 'admin'


# ================= USER =================
@method_decorator(csrf_exempt, name='dispatch')
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    authentication_classes = [JWTAuthentication]

    def get_permissions(self):
        if self.action == 'create':  # REGISTER
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]


# ================= CANDIDATE PROFILE =================
@method_decorator(csrf_exempt, name='dispatch')
class CandidateProfileViewSet(viewsets.ModelViewSet):
    queryset = CandidateProfile.objects.all()
    serializer_class = CandidateProfileSerializer

    authentication_classes = [JWTAuthentication]
    permission_classes = [permissions.IsAuthenticated]

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

    authentication_classes = [JWTAuthentication]
    permission_classes = [permissions.IsAuthenticated]


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
        user_obj = User.objects.get(email=email)
        username = user_obj.username
    except User.DoesNotExist:
        return Response(
            {"error": "Invalid credentials"},
            status=status.HTTP_401_UNAUTHORIZED
        )

    user = authenticate(username=username, password=password)

    if user:
        refresh = RefreshToken.for_user(user)

        return Response({
            "message": "login successful",
            "access": str(refresh.access_token),
            "refresh": str(refresh),
            "user": {
                "id": user.id,
                "email": user.email,
                "role": user.role
            }
        }, status=status.HTTP_200_OK)

    return Response(
        {"error": "Invalid credentials"},
        status=status.HTTP_401_UNAUTHORIZED
    )


# ================= ADMIN DASHBOARD API =================
class AdminDashboardView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [permissions.IsAuthenticated, IsAdminUserRole]

    def get(self, request):
        total_users = User.objects.count()  
        candidates = User.objects.filter(role='candidate').count()
        employers = User.objects.filter(role='employer').count()

        return Response({
            "total_users": total_users,
            "candidates": candidates,
            "employers": employers,
            "system_health": "99.8%"
        })

# ======================== PDF GENERATE ====================
class GenerateReportView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        response = HttpResponse(content_type='application/pdf')
        response['Content-Disposition'] = 'attachment; filename="report.pdf"'

        p = canvas.Canvas(response)

        users = User.objects.all()

        y = 800
        for user in users:
            p.drawString(100, y, f"{user.email} - {user.role}")
            y -= 20

        p.save()
        return response