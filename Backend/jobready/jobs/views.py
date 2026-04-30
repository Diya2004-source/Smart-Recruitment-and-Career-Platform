from rest_framework import viewsets, permissions
from .models import Job, Application
from .serializers import JobSerializer, ApplicationSerializer


# ================= JOB VIEWSET =================
class JobViewSet(viewsets.ModelViewSet):
    serializer_class = JobSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user

        # 🔥 RECRUITER: only their jobs
        if hasattr(user, 'role') and user.role == 'RECRUITER':
            return Job.objects.filter(recruiter=user).order_by('-created_at')

        # 🔥 ADMIN: all jobs
        if hasattr(user, 'role') and user.role == 'ADMIN':
            return Job.objects.all().order_by('-created_at')

        # 🔥 CANDIDATE: always see active jobs
        return Job.objects.filter(is_active=True).order_by('-created_at')

    def perform_create(self, serializer):
        user = self.request.user

        # 🔒 Safety check
        if not user or not user.is_authenticated:
            raise permissions.PermissionDenied("Login required")

        # 🔥 FORCE recruiter assignment
        serializer.save(recruiter=user)


# ================= APPLICATION VIEWSET =================
class ApplicationViewSet(viewsets.ModelViewSet):
    serializer_class = ApplicationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user

        # 🔥 RECRUITER: applications on their jobs
        if hasattr(user, 'role') and user.role == 'RECRUITER':
            return Application.objects.filter(job__recruiter=user).order_by('-applied_at')

        # 🔥 CANDIDATE: only their applications
        return Application.objects.filter(candidate=user).order_by('-applied_at')

    def perform_create(self, serializer):
        user = self.request.user
        job = serializer.validated_data['job']

        # 🔥 safe skill extraction
        candidate_skills = []

        if hasattr(user, 'candidate_profile') and user.candidate_profile:
            candidate_skills = user.candidate_profile.skills.get('tech', [])

        required_skills = job.required_skills or []

        # 🔥 AI MATCH SCORE
        if required_skills:
            matches = set(candidate_skills) & set(required_skills)
            score = (len(matches) / len(required_skills)) * 100
        else:
            score = 0

        serializer.save(
            candidate=user,
            match_score=score
        )