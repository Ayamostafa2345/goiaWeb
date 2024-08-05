from django.urls import path , include
from . import views
#from views import upload_image
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [


 path('pic', views.upload_image, name='pic'),
]