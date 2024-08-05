from django.db import models
class Login(models.Model):
    username = models.CharField(max_length=50)
    password = models.CharField(max_length=50)

# Create your models here.
# models.py
class Image(models.Model):
    caption = models.CharField(max_length=100)
    image = models.ImageField(upload_to='img/%y')
    #title = models.CharField(max_length=50, default='null')
   # banner = models.ImageField(upload_to='Image/banner',default='null')
def __str__(self):
    return self. caption 

#class Images(models.Model):
    Image = models.ForeignKey(Image ,on_delete=models.CASCADE, null=True , blank=True )
    images= models.ImageField(upload_to='Image/images')
