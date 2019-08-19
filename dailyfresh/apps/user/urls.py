from django.conf.urls import url
from user import views

urlpatterns = [
    url(r'^register$', views.RegisterView.as_view(), name='register'),  # 注册、处理
    url(r'^active/(?P<token>.*)$', views.ActiveView.as_view(), name='active'),  # 用户激活
    url(r'^login$', views.LoginView.as_view(), name='login'),  # 登录
    url(r'^logout$', views.LogoutView.as_view(), name='logout'),  # 退出登录

    url(r'^$', views.UserInfoView.as_view(), name='user'),  # 用户中心-信息页
    url(r'^order/(?P<page>\d+)$', views.UserOrderView.as_view(), name='order'),  # 用户中心-订单页
    url(r'^site$', views.UserSiteView.as_view(), name='site'),  # 用户中心-地址页
]
