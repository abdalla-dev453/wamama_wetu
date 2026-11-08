from django.db import models
from .group import Group


class GroupHealthScore(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='health_scores')
    score = models.IntegerField(default=0)  # 0-100
    collection_rate = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    arrears_rate = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    loan_repayment_rate = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    meeting_attendance_rate = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    unmatched_payments_count = models.IntegerField(default=0)
    recommended_actions = models.JSONField(default=list)
    calculated_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'chamify_group_health_scores'
        ordering = ['-calculated_at']

    def __str__(self):
        return f'{self.group.name} - {self.score}/100'

    @property
    def score_label(self):
        if self.score >= 80:
            return 'Excellent'
        elif self.score >= 60:
            return 'Good'
        elif self.score >= 40:
            return 'Fair'
        elif self.score >= 20:
            return 'Poor'
        return 'Critical'