from rest_framework import serializers
from .models import Job, Application

class JobSerializer(serializers.ModelSerializer):
    recruiter_name = serializers.SerializerMethodField()
    # We remove SerializerMethodField for company_name so it can be SAVED from Flutter
    # If your Model has a company_name field, use a standard field. 
    # If it's a profile property, keep it as MethodField but handle it in create()

    class Meta:
        model = Job
        fields = [
            'id', 'recruiter', 'recruiter_name', 'title', 
            'company_name', 'description', 'required_skills', 
            'location', 'is_active', 'created_at'
        ]
        read_only_fields = ['recruiter', 'created_at']

    def get_recruiter_name(self, obj):
        try:
            return obj.recruiter.get_full_name() or obj.recruiter.username
        except:
            return "Unknown Recruiter"

    def validate_required_skills(self, value):
        # Converts "Flutter, Dart" string into ["Flutter", "Dart"] list
        if isinstance(value, str):
            return [s.strip() for s in value.split(',') if s.strip()]
        return value

class ApplicationSerializer(serializers.ModelSerializer):
    candidate_username = serializers.ReadOnlyField(source='candidate.username')
    job_title = serializers.ReadOnlyField(source='job.title')

    class Meta:
        model = Application
        fields = [
            'id', 'job', 'job_title', 'candidate', 
            'candidate_username', 'match_score', 'status', 'applied_at',
            'employer_message' # Add this to ensure it's serialized
        ]
        # ADD 'candidate' and 'status' TO READ_ONLY
        read_only_fields = ['candidate', 'match_score', 'status', 'applied_at']