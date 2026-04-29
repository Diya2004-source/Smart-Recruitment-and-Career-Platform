from rest_framework import serializers
from .models import Job , Application

class JobSerializer(serializers.ModelSerializer):
    recruiter_name = serializers.SerializerMethodField()

    class Meta:
        model = Job
        fields = [
            'id',
            'recruiter',
            'recruiter_name',
            'title',
            'description',
            'required_skills',
            'location',
            'is_active',
            'created_at'
        ]

        read_only_fields = [
            'recruiter',
            'created_at'
        ]

    # ================= SAFE RECRUITER NAME =================
    def get_recruiter_name(self, obj):
        try:
            # Try recruiter profile first
            if hasattr(obj.recruiter, 'recruiter_profile'):
                return obj.recruiter.recruiter_profile.company_name
        except:
            pass

        # fallback (always safe)
        return obj.recruiter.username if obj.recruiter else "Unknown"

    # ================= FIX SKILLS INPUT =================
    def validate_required_skills(self, value):
        
        if isinstance(value, str):
            return [s.strip() for s in value.split(",") if s.strip()]

        if isinstance(value, list):
            return value

        return []

class ApplicationSerializer(serializers.ModelSerializer):
    # This shows the candidate username instead of just the ID
    candidate_username = serializers.ReadOnlyField(source='candidate.username')
    job_title = serializers.ReadOnlyField(source='job.title')

    class Meta:
        model = Application
        fields = ['id' , 'job' , 'job_title' , 'candidate' , 'candidate_username' , 'match_score' , 'status' , 'applied_at']
        read_only_fields = ['match_score'] # This fields are calculated by the system and should not be editable by the user