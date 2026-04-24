from rest_framework import serializers
from .models import MockInterview

class MockInterviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = MockInterview
        fields = ['id', 'candidate', 'question', 'transcript', 'ai_feedback', 'confidence_rating', 'created_at']