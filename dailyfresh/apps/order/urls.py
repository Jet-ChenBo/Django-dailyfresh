from django.conf.urls import url
from order import views

urlpatterns = [
    url(r'^place$', views.OrderPlaceView.as_view(), name='place'),  # 显示提交订单页面
    url(r'^commit$', views.OrderCommitView.as_view(), name='commit'),  # 创建订单
    url(r'^pay$', views.OrderPayView.as_view(), name='pay'),  # 订单支付
    url(r'^check$', views.CheckPayView.as_view(), name='check'),  # 查询支付结果
    url(r'^comment/(?P<order_id>.+)$', views.CommentView.as_view(), name='comment'),  # 订单评论
]
