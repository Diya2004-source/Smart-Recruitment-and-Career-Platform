from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver
from accounts.models import User, CandidateProfile, RecruiterProfile
# Create your models here.
class MockInterview(models.Model):
    candidate = models.ForeignKey(User, on_delete=models.CASCADE)
    question = models.TextField()
    transcript = models.TextField() # Text converted from Flutter audio
    ai_feedback = models.TextField()
    confidence_rating = models.IntegerField(help_text="Score out of 100")
    created_at = models.DateTimeField(auto_now_add=True)

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        if instance.role == User.Role.CANDIDATE:
            CandidateProfile.objects.create(user=instance)
        elif instance.role == User.Role.RECRUITER:
            RecruiterProfile.objects.create(user=instance)