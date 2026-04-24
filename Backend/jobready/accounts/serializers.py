from rest_framework import serializers
from .models import User, CandidateProfile, RecruiterProfile

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'role', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        # This ensures the password is encrypted properly
        user = User.objects.create_user(**validated_data)
        return user

class CandidateProfileSerializer(serializers.ModelSerializer):
    # Use 'user_details' as the field name to avoid confusion with the 'user' ID field
    user_details = UserSerializer(source='user', read_only=True)

    class Meta:
        model = CandidateProfile
        fields = ['id', 'user', 'user_details', 'resume_file', 'skills', 'experience_years']
        read_only_fields = ['user']

class RecruiterProfileSerializer(serializers.ModelSerializer):
    user_details = UserSerializer(source='user', read_only=True)

    class Meta:
        model = RecruiterProfile
        fields = ['id', 'user', 'user_details', 'company_name', 'company_website']
        read_only_fields = ['user']