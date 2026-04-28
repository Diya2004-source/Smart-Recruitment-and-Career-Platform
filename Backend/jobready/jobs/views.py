# from rest_framework import viewsets, permissions
# from .models import Job, Application
# from .serializers import JobSerializer, ApplicationSerializer

# class JobViewSet(viewsets.ModelViewSet):
#     queryset = Job.objects.all()
#     serializer_class = JobSerializer
#     permission_classes = [permissions.IsAuthenticated]  

#     def perform_create(self, serializer):
#         serializer.save(recruiter=self.request.user)

# class ApplicationViewSet(viewsets.ModelViewSet):
#     serializer_class = ApplicationSerializer
#     permission_classes = [permissions.IsAuthenticated]

#     def get_queryset(self):
#         user = self.request.user
#         if user.role == 'RECRUITER':
#             return Application.objects.filter(job__recruiter=user)
#         return Application.objects.filter(candidate=user)

#     def perform_create(self, serializer):
#         job = serializer.validated_data['job']
#         candidate_skills = self.request.user.candidate_profile.skills.get('tech', [])
#         required_skills = job.required_skills
        
#         #  Logic: Simple AI Matching Score 
#         if required_skills:
#             matches = set(candidate_skills) & set(required_skills)
#             score = (len(matches) / len(required_skills)) * 100
#         else:
#             score = 0

#         serializer.save(candidate=self.request.user, match_score=score)

from rest_framework import viewsets, permissions
from .models import Job, Application
from .serializers import JobSerializer, ApplicationSerializer


# ================= JOB VIEWSET =================
class JobViewSet(viewsets.ModelViewSet):
    serializer_class = JobSerializer
    permission_classes = [permissions.IsAuthenticated]

    #  FIX: Proper role-based job visibility
    def get_queryset(self):
        user = self.request.user

        # Recruiter sees only their jobs
        if user.role == 'RECRUITER':
            return Job.objects.filter(recruiter=user).order_by('-created_at')

        # Admin sees all jobs
        if user.role == 'ADMIN':
            return Job.objects.all().order_by('-created_at')

        # Candidates see only active jobs
        return Job.objects.filter(is_active=True).order_by('-created_at')

    #  FIX: Automatically assign recruiter
    def perform_create(self, serializer):
        serializer.save(recruiter=self.request.user)


# ================= APPLICATION VIEWSET =================
class ApplicationViewSet(viewsets.ModelViewSet):
    serializer_class = ApplicationSerializer
    permission_classes = [permissions.IsAuthenticated]

    #  FIX: Proper filtering
    def get_queryset(self):
        user = self.request.user

        # Recruiter sees applications for their jobs
        if user.role == 'RECRUITER':
            return Application.objects.filter(job__recruiter=user)

        # Candidate sees only their applications
        return Application.objects.filter(candidate=user)

    # FIX: AI matching logic (safe version)
    def perform_create(self, serializer):
        user = self.request.user
        job = serializer.validated_data['job']

        candidate_skills = []

        # safe extraction of skills
        if hasattr(user, 'candidate_profile') and user.candidate_profile:
            candidate_skills = user.candidate_profile.skills.get('tech', [])

        required_skills = job.required_skills or []

        # AI-like matching score
        if required_skills:
            matches = set(candidate_skills) & set(required_skills)
            score = (len(matches) / len(required_skills)) * 100
        else:
            score = 0

        serializer.save(
            candidate=user,
            match_score=score
        )