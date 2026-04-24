from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.
class User(AbstractUser):
    class Role(models.TextChoices):
        ADMIN = "ADMIN", "Admin"
        RECRUITER = "RECRUITER", "Recruiter"
        CANDIDATE = "CANDIDATE", "Candidate"

    role = models.CharField(
        max_length=10, 
        choices=Role.choices, 
        default=Role.CANDIDATE
    )
    is_verified = models.BooleanField(default=False) 

class CandidateProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='candidate_profile')
    resume_file = models.FileField(upload_to='resumes/', null=True, blank=True)
    # JSONField stores extracted skills like {"tech": ["Python", "Flutter"], "soft": ["Teamwork"]}
    skills = models.JSONField(default=dict, blank=True)
    ai_career_summary = models.TextField(blank=True)
    experience_years = models.IntegerField(default=0)

    def __str__(self):
        return f"Candidate: {self.user.username}"
    
class RecruiterProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='recruiter_profile')
    company_name = models.CharField(max_length=255)
    company_website = models.URLField(blank=True)
    
    def __str__(self):
        return f"Recruiter: {self.company_name}"