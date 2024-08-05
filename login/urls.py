from django.urls import path , include
from . import views
#from .views import upload

from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path ('', views.Loginpage , name= 'Loginpage' ),
    path ('home',views.Home , name = 'Home'),
    path('dicsr', views.Discribtion, name ='Discribtion'),
    #path('home',views.upload, name='upload')
    #path('home', HomeView, name='upload')

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
   