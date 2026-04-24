from rest_framework import serializers
from .models import Job , Application

class JobSerializer(serializers.ModelSerializer):
    # This shows the recruiter name instead of just the ID
    recruiter_name = serializers.ReadOnlyField(source='recruiter.recruiterprofile.company_name')

    class Meta:
        model = Job
        fields = ['id' , 'recruiter' , 'recruier_name' , 'title' , 'description' , 'required_skills' , 'location' , 'is_active' , 'created_at']

class ApplicationSerializer(serializers.ModelSerializer):
    # This shows the candidate username instead of just the ID
    candidate_username = serializers.ReadOnlyField(source='candidate.username')
    job_title = serializers.ReadOnlyField(source='job.title')

    class Meta:
        model = Application
        fields = ['id' , 'job' , 'job_title' , 'candidate' , 'candidate_username' , 'match_score' , 'status' , 'applied_at']
        read_only_fields = ['match_score'] # This fields are calculated by the system and should not be editable by the user