# Generated by Django 5.0.7 on 2024-08-04 20:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('login', '0003_delete_image'),
    ]

    operations = [
        migrations.CreateModel(
            name='Image',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.FileField(upload_to='')),
            ],
        ),
    ]
