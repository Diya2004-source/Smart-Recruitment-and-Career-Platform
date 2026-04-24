from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import action
from .models import MockInterview
from .serializers import MockInterviewSerializer

class AIProcessViewSet(viewsets.ViewSet):
    
    @action(detail=False, methods=['POST'])
    def process_resume(self, request):
        file = request.FILES.get('resume')
        if not file:
            return Response({"error": "No file"}, status=status.HTTP_400_BAD_REQUEST)
        
        # Simulated AI Extraction
        extracted_data = {
            "tech": ["Flutter", "Dart", "Python", "Django"],
            "summary": "Full-Stack Developer with a focus on AI integration."
        }
        
        # Update Candidate Profile
        profile = request.user.candidate_profile
        profile.skills = extracted_data
        profile.save()
        
        return Response(extracted_data)

class MockInterviewViewSet(viewsets.ModelViewSet):
    serializer_class = MockInterviewSerializer
    
    def get_queryset(self):
        return MockInterview.objects.filter(candidate=self.request.user)