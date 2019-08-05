from django.shortcuts import render,redirect
from django.http import HttpResponse
from user.models import User,Address
from goods.models import GoodsSKU
from order.models import OrderInfo,OrderGoods
from django.core.urlresolvers import reverse
from django.core.mail import send_mail
from django.views.generic import View
from django.core.paginator import Paginator

from itsdangerous import TimedJSONWebSignatureSerializer as Serializer
from itsdangerous import SignatureExpired
from django.conf import settings
from celery_tasks.tasks import send_register_active_emali
from django.contrib.auth import authenticate,login,logout

from utils.mixin import LoginRequiredMixmin
from redis import StrictRedis
from django_redis import get_redis_connection
import re


# /user/register
class RegisterView(View):
    '''注册'''
    def get(self, request):
        '''显示注册页面'''
        return render(request, 'register.html')

    def post(self, request):
        '''进行注册的处理'''
        # 1.接收数据
        username = request.POST.get('user_name')
        password = request.POST.get('pwd')
        cpassword = request.POST.get('cpwd')
        email = request.POST.get('email')
        allow = request.POST.get('allow')

        # 2.数据校验
        if not all((username, password, cpassword, email)):
            return render(request, 'register.html', {'errmsg': '数据不完整'})

        if password != cpassword:
            return render(request, 'register.html', {'errmsg': '两次密码不一致'})
        # 校验邮箱
        if not re.match(r'^[a-z0-9][\w.\-]*@[a-z0-9\-]+(\.[a-z]{2,5}){1,2}$', email):
            return render(request, 'register.html', {'errmsg': '邮箱格式不正确'})

        if allow != 'on':
            return render(request, 'register.html', {'errmsg': '请同意协议'})
        # 校验用户名是否重复
        try:
            user = User.objects.get(username=username)
        except Exception:
            # 用户名已存在
            user = None
        if user:
            return render(request, 'register.html', {'errmsg': '用户名已存在'})

        # 3.进行业务处理
        user = User.objects.create_user(username, email, password)
        user.is_active = 0  # 初始状态是未激活
        user.save()

        # 发送激活邮件，包含激活链接 /user/active/用户id(需要加密)
        # 加密用户信息
        serilalizer = Serializer(settings.SECRET_KEY, 3600)
        info = {'id':user.id}
        token = serilalizer.dumps(info)  # 加密，返回加密后的byte字符串
        token = token.decode('utf-8')
        # 发送邮件
        send_register_active_emali.delay(email, username, token)  # 发出任务
        # 4.返回应答，跳转到首页
        return redirect(reverse('goods:index'))


# /user/active/加密信息token
class ActiveView(View):
    '''用户激活'''
    def get(self, request, token):
        # 解密，获取用户id
        serilalizer = Serializer(settings.SECRET_KEY, 3600)
        try:
            info = serilalizer.loads(token)
            user_id = info['id']

            # 根据id获取用户信息
            user = User.objects.get(id=user_id)
            user.is_active = 1
            user.save()

            # 返回应答，跳转到登录页面
            return redirect(reverse('user:login'))

        except SignatureExpired as e:
            return HttpResponse('激活链接已过期')


# /user/login
class LoginView(View):
    def get(self, request):
        '''显示登录页面'''
        # 判断是否记住了用户名
        if 'username' in request.COOKIES:
            username = request.COOKIES['username']
            checked = 'checked'
        else:
            username = ''
            checked = ''
        return render(request, 'login.html', {'username':username, 'checked':checked})

    def post(self, request):
        '''登录校验'''
        username = request.POST.get('username')
        password = request.POST.get('pwd')
        remember = request.POST.get('remember')

        if not all([username, password]):
            return render(request, 'login.html', {'errmsg':'数据不完整'})

        # 用户认证
        user = authenticate(username=username, password=password)
        if user is not None:
            # 认证成功
            if user.is_active:
                # 保存用户登录状态
                login(request, user)
                # 获取登录后所要跳转的地址，默认跳转到首页
                next_url = request.GET.get('next', reverse('goods:index'))
                # 是否记住用户名
                response  = redirect(next_url)
                if remember == 'on':
                    response.set_cookie('username', username, max_age=7*24*3600)
                else:
                    response.delete_cookie('username')
                # 跳转
                return response
            else:
                return render(request, 'login.html', {'errmsg':'用户未激活'})
        else:
            return render(request, 'login.html', {'errmsg':'用户名或密码错误'})


# /user/logout
class LogoutView(View):
    '''退出登录'''
    def get(self, requset):
        # 退出登录，清除用户的session信息
        logout(requset)
        # 跳转到首页
        return redirect(reverse('goods:index'))


# /user
class UserInfoView(LoginRequiredMixmin, View):
    '''用户中心-信息页'''
    def get(self, request):
        '''显示'''
        # 获取用户个人信息
        user = request.user
        address = Address.objects.get_default_address(user)

        # 获取用户历史浏览记录
        #sr = StrictRedis(db=9)
        con = get_redis_connection('default')  # default对应缓存配置中的键名
        history_key = "history_%d" % user.id

        # 获取历史浏览记录前五个商品的id
        sku_ids = con.lrange(history_key, 0, 4)

        # 从数据库中查询商品的具体信息
        # 数据库查询是至上而下的，所以就不能保持原来的顺序，例如[2,3,1],用filter查出来是[1,2,3]
        goods_li = []
        for id in sku_ids:
            goods = GoodsSKU.objects.get(id=id)
            goods_li.append(goods)

        context = {'page':'info',
                   'address':address,
                   'goods_li':goods_li
                    }
        return render(request, 'user_center_info.html', context)

# /user/order
class UserOrderView(LoginRequiredMixmin, View):
    '''用户中心-订单页'''
    def get(self, request, page):
        '''显示'''
        # 获取用户订单信息
        user = request.user
        orders = OrderInfo.objects.filter(user=user).order_by('-create_time')

        # 遍历获取订单商品的信息
        for order in orders:
            order_skus = OrderGoods.objects.filter(order=order.order_id)
            # 计算商品小计
            for order_sku in order_skus:
                amount = order_sku.count * order_sku.price
                # 动态增加属性
                order_sku.amount = amount

            order.status_name = OrderInfo.ORDER_STATUS[order.order_status]

            # 动态增加属性，保存订单商品的信息
            order.order_skus = order_skus


        # 分页
        paginator = Paginator(orders, 1)

        # 获取第page页的内容
        try:
            page = int(page)
        except Exception as e:
            page = 1
        if page > paginator.num_pages:
            page = 1

        # 获取第page页的实例对象
        order_page = paginator.page(page)

        # todo: 进行页码控制，页面上最多显示5个页码
        # 1.总页数小于等于五页，页面上显示所有页码
        # 2.如果当前是前三页，显示1-5页
        # 3.如果当前是倒数后三页，显示倒数1-5页
        # 4.其他情况，显示当前页和前后2页
        num_pages = paginator.num_pages
        if num_pages <= 5:
            pages = range(1, num_pages + 1)
        elif num_pages <= 3:
            pages = range(1, 6)
        elif num_pages - page <= 2:
            pages = range(num_pages - 4, num_pages + 1)
        else:
            pages = range(num_pages - 2, num_pages + 3)

        # 组织上下文
        context = {
            'order_page': order_page,
            'pages': pages,
            'page': 'order'
        }

        return render(request, 'user_center_order.html', context)

# /user/site
class UserSiteView(LoginRequiredMixmin, View):
    '''用户中心-地址页'''
    def get(self, request):
        '''显示'''
        # 获取用户默认收获地址
        user = request.user
        address = Address.objects.get_default_address(user)
        return render(request, 'user_center_site.html', {'page':'site','address':address})

    def post(self, request):
        '''地址的添加'''
        # 接受数据
        receiver = request.POST['receiver']
        addr = request.POST['addr']
        zip_code = request.POST['zip_code']
        phone = request.POST['phone']

        # 数据校验
        if not all([receiver, addr, phone]):
            return render(request, 'user_center_site.html', {'errmsg':'数据不完整'})
        if not re.match(r'^1[3|4|5|7|8][0-9]{9}$', phone):
            return render(request, 'user_center_site.html', {'errmsg':'手机号码不存在'})

        # 业务处理：添加地址
        # 如果用户没有默认地址，就设置为默认地址
        user = request.user
        address = Address.objects.get_default_address(user)

        if address:
            is_default = False
        else:
            is_default = True
        # 添加地址
        Address.objects.create(user=user, receiver=receiver, addr = addr,
                               zip_code = zip_code, phone=phone, is_default=is_default)

        # 返回应答，刷新页面
        return redirect(reverse('user:site'))