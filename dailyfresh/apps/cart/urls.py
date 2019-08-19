from django.conf.urls import url
from cart import views

urlpatterns = [
    url(r'^add$', views.CartAddView.as_view(), name='add'),  # 购物车添加
    url(r'^$', views.CartInfoView.as_view(), name='show'),  # 购物车页面
    url(r'^update$', views.CartUpdateView.as_view(), name='update'),  # 更新购物车记录
    url(r'^delete$', views.CartDeleteView.as_view(), name='delete'),  # 删除购物车中的商品
]
