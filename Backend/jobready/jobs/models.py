from django.db import models
from accounts.models import User

# Create your models here.
class Job(models.Model):
    recruiter = models.ForeignKey(User, on_delete=models.CASCADE, related_name='posted_jobs')
    title = models.CharField(max_length=255)
    description = models.TextField()
    required_skills = models.JSONField(default=list, blank=True)  # List of required skills
    location = models.CharField(max_length=255)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    company_name = models.CharField(max_length=255, default="Independent")
    def __str__(self):
        return self.title

class Application(models.Model):
    class Status(models.TextChoices):
        PENDING = "PENDING", "Pending"
        SHORTLISTED = "SHORTLISTED", "Shortlisted"
        REJECTED = "REJECTED", "Rejected"

    job = models.ForeignKey(Job, on_delete=models.CASCADE, related_name='applications')
    candidate = models.ForeignKey(User, on_delete=models.CASCADE, related_name='my_applications')
    match_score = models.FloatField(default=0.0) # Calculated by AI logic
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    employer_message = models.TextField(null=True, blank=True)
    applied_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.candidate.username} - {self.job.title} ({self.status})"
