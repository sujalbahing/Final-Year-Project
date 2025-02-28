from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class EsewaPayment(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)  # Link to user
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    transaction_id = models.CharField(max_length=100, unique=True)
    status = models.CharField(
        max_length=20, choices=[("Pending", "Pending"), ("Completed", "Completed"), ("Failed", "Failed")]
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"eSewa Payment {self.transaction_id} - {self.status}"