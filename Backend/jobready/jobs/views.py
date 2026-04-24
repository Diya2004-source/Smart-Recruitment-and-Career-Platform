from rest_framework import viewsets, permissions
from .models import Job, Application
from .serializers import JobSerializer, ApplicationSerializer

class JobViewSet(viewsets.ModelViewSet):
    queryset = Job.objects.filter(is_active=True)
    serializer_class = JobSerializer

    def perform_create(self, serializer):
        # Automatically set the recruiter as the logged-in user
        serializer.save(recruiter=self.request.user)

class ApplicationViewSet(viewsets.ModelViewSet):
    serializer_class = ApplicationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == 'RECRUITER':
            return Application.objects.filter(job__recruiter=user)
        return Application.objects.filter(candidate=user)

    def perform_create(self, serializer):
        job = serializer.validated_data['job']
        candidate_skills = self.request.user.candidate_profile.skills.get('tech', [])
        required_skills = job.required_skills
        
        #  Logic: Simple AI Matching Score 
        if required_skills:
            matches = set(candidate_skills) & set(required_skills)
            score = (len(matches) / len(required_skills)) * 100
        else:
            score = 0

        serializer.save(candidate=self.request.user, match_score=score)