from rest_framework import serializers
from .models import EsewaPayment

class EsewaPaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = EsewaPayment
        fields = '__all__'