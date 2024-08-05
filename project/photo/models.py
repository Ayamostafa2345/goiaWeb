from django.db import models

class Image(models.Model):
    #name = models.TextField(max_length=50)
    image = models.ImageField(upload_to='photo/static/image/')
    description = models.TextField(blank=True, null=True)
    active = models.BooleanField(default=True)
    def __str__(self):
        return self.description or 'No Description'

# Create your models here.
