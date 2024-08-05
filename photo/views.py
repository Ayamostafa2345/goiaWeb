from django.shortcuts import render
# views.py
from . import models
from . import forms
from .forms import ImageForm
from .models import Image








def upload_image(request):
    u= models.Image()
    form = forms.ImageForm(request.POST,request.FILES)

    return render(request, 'pic.html',{'form':form})
