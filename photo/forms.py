# forms.py
from django import forms
from .models import Image

class ImageForm(forms.ModelForm):
  name= forms.CharField() 
  img= forms.ImageField()
