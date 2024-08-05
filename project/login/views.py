from django.shortcuts import render , redirect
from .models import Login
from django.contrib.auth.models import User , auth
from django.http import HttpResponse
from . models import Image
from django.views.generic import TemplateView , CreateView
from . forms import ImageForm
from . models import Image
def Loginpage(request):
  if request.method == 'POST':
    
       username = request.POST["username"]
       password = request.POST["password"]
       
       user = auth.authenticate(username = username ,password = password  )
       if user is not None:
        auth.Loginpage(request, user)
        return redirect('home')

     
  else:
      return render(request ,'loginpage/Loginpage.html' )
   # return HttpResponse('welcome to  goia')
def Home (request):
   return render(request ,'home.html' )
def Discribtion (request):
  
    return HttpResponse ('Discribtion')

#def upload (request):

    if request.method == 'POST':
       image = request.FILES.getlist('images')
       for img in image:
          Image.objects.create(image=img)
       image = Image.objects.all()
       return render(request,'Loginpage.html',{'image':image})

def index(request):
   if request.method == 'POST':
       form = ImageForm(data= request.POST, files= request.FILES)
   if form.is_valid():
            form.save()
            obj=form.instance
            return render (request,"home.html",{"obj":obj})
   else:
        form = ImageForm()
        img= Image.objects.all()
   return render (request,"home.html",{"img":img, "form":form})
       


  

