# Generated by Django 5.0.7 on 2024-08-04 22:58

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('login', '0004_image'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='image',
            name='image',
        ),
        migrations.AddField(
            model_name='image',
            name='banner',
            field=models.ImageField(default='null', upload_to='Image/banner'),
        ),
        migrations.AddField(
            model_name='image',
            name='title',
            field=models.CharField(default='null', max_length=50),
        ),
        migrations.CreateModel(
            name='Images',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('images', models.ImageField(upload_to='Image/images')),
                ('Image', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='login.image')),
            ],
        ),
    ]
