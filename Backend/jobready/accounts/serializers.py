from rest_framework import serializers
from .models import User, CandidateProfile, RecruiterProfile


# ================= USER SERIALIZER =================
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password', 'role']
        extra_kwargs = {
            'password': {'write_only': True},
            'role': {'required': False}  # ✅ NOT REQUIRED (default will be used)
        }

    def create(self, validated_data):
        # ✅ Default role = CANDIDATE if not provided
        role = validated_data.pop('role', 'CANDIDATE')

        # ✅ Create user with hashed password
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
        )

        # ✅ Assign role safely
        user.role = role
        user.save()

        return user


# ================= CANDIDATE PROFILE =================
class CandidateProfileSerializer(serializers.ModelSerializer):
    user_details = UserSerializer(source='user', read_only=True)

    class Meta:
        model = CandidateProfile
        fields = [
            'id',
            'user',
            'user_details',
            'resume_file',
            'skills',
            'experience_years'
        ]
        read_only_fields = ['user']


# ================= RECRUITER PROFILE =================
class RecruiterProfileSerializer(serializers.ModelSerializer):
    user_details = UserSerializer(source='user', read_only=True)

    class Meta:
        model = RecruiterProfile
        fields = [
            'id',
            'user',
            'user_details',
            'company_name',
            'company_website'
        ]
        read_only_fields = ['user']