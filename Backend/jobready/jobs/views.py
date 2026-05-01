from rest_framework.response import Response
from rest_framework import status  
from rest_framework.decorators import action 
from rest_framework import viewsets, permissions
from .models import Job, Application
from .serializers import JobSerializer, ApplicationSerializer

# ================= JOB VIEWSET =================
class JobViewSet(viewsets.ModelViewSet):
    serializer_class = JobSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        role = str(getattr(user, 'role', 'CANDIDATE')).upper()

        # Employers only see jobs THEY created
        if role in ['RECRUITER', 'EMPLOYER']:
            return Job.objects.filter(recruiter=user).order_by('-created_at')

        # Admins see everything
        if role == 'ADMIN' or user.is_superuser:
            return Job.objects.all().order_by('-created_at')

        # Candidates see all active jobs
        return Job.objects.filter(is_active=True).order_by('-created_at')

    def perform_create(self, serializer):
        # Automatically assign the logged-in Employer as the recruiter
        serializer.save(recruiter=self.request.user)
    
# ================= APPLICATION VIEWSET =================
class ApplicationViewSet(viewsets.ModelViewSet):
    serializer_class = ApplicationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        role = str(getattr(user, 'role', 'CANDIDATE')).upper() # Added .upper() for safety

        if role in ['RECRUITER', 'EMPLOYER']:
            return Application.objects.filter(job__recruiter=user).order_by('-applied_at')

        return Application.objects.filter(candidate=user).order_by('-applied_at')

    def perform_create(self, serializer):
        user = self.request.user
        job = serializer.validated_data['job']
        
        # Skill matching logic
        candidate_skills = []
        if hasattr(user, 'candidate_profile') and user.candidate_profile:
            candidate_skills = user.candidate_profile.skills.get('tech', [])

        required_skills = job.required_skills or []

        if required_skills:
            matches = set(candidate_skills) & set(required_skills)
            score = (len(matches) / len(required_skills)) * 100
        else:
            score = 0

        serializer.save(candidate=user, match_score=score)

    # --- NEW ACTION FOR MESSAGING ---
@action(detail=True, methods=['patch'])
def update_application(self, request, pk=None):
    """
    Endpoint: PATCH /api/applications/{id}/update_application/
    Used by Employers to change status and send a message.
    """
    application = self.get_object()
    user = request.user
    
    # Verify this employer actually owns the job
    if application.job.recruiter != user:
        return Response({"error": "Unauthorized"}, status=status.HTTP_403_FORBIDDEN)

    new_status = request.data.get('status')
    message = request.data.get('message')

    if new_status:
        application.status = new_status
    if message:
        application.employer_message = message
    
    application.save()
    
    # Returning explicit 200 OK status
    return Response({
        "status": "success",
        "new_status": application.status,
        "message_sent": message
    }, status=status.HTTP_200_OK)