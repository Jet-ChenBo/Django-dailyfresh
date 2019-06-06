
from django.conf.urls import url
from getAreas import views


urlpatterns = [
    url(r'^areas$', views.areas),  # 省市县选择案例
    url(r'^cities(\d*)$', views.cities),  # 省级信息以及下级地区
]
