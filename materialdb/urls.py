from django.conf.urls import url
from django.contrib import admin
from django.urls import path, include
from materialdb import views
from django.shortcuts import redirect

urlpatterns = [
    path('', lambda req: redirect('/accounts/login')),
    path('admin/', admin.site.urls),
    path('accounts/', include('django.contrib.auth.urls')),
    path('user/tableview', views.RouteTableView.as_view()),
    url('route/adduser', views.addIntersectionView.as_view()),
    url('route/edit', views.EditIntersectionView.as_view()),
]
