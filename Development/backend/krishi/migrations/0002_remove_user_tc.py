# Generated by Django 5.1.4 on 2024-12-21 10:15

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('krishi', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='user',
            name='tc',
        ),
    ]
