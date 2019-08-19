from django.shortcuts import render
from django.views.generic import View
from utils.mixin import LoginRequiredMixmin
from django.http import JsonResponse
from goods.models import GoodsSKU
from django_redis import get_redis_connection

# /cart/add
class CartAddView(View):
    '''购物车添加'''
    def post(self, request):
        '''添加商品到购物车'''
        user = request.user
        if not user.is_authenticated():
            return JsonResponse({'res':0., 'errmsg':'请先登录'})

        # 接受数据
        sku_id = request.POST.get('sku_id')
        count = request.POST.get('count')

        # 数据校验
        if not all([sku_id, count]):
            return JsonResponse({'res':1, 'errmsg':'数据不完整'})
        try:
            count = int(count)
        except Exception as e:
            return JsonResponse({'res':2, 'errmsg':'商品数目出错'})

        try:
            sku = GoodsSKU.objects.get(id=sku_id)
        except GoodsSKU.DoesNotExist:
            return JsonResponse({'res':3, 'errmsg':'商品不存在'})

        # 业务处理：添加购物车
        conn = get_redis_connection('default')
        cart_key = 'cart_%d' % user.id
        # 1.查看用户购物车是否已经存在相同的商品,如果查不到会返回None
        cart_count = conn.hget(cart_key, sku_id)
        if cart_count:
            # 累加购物车中商品的数目
            count += int(cart_count)
        # 2.查看商品库存是否足够
        if count>sku.stock:
            return JsonResponse({'res':4, 'errmsg':'商品库存不足'})
        # 3.添加购物车
        conn.hset(cart_key, sku_id, count)

        # 计算用户购物车中商品的条目数
        total_count = conn.hlen(cart_key)

        # 返回应答
        return JsonResponse({'res':5, 'msg':'添加成功', 'total_count':total_count})

# /cart
class CartInfoView(LoginRequiredMixmin, View):
    '''购物车页面显示'''
    def get(self, request):
        '''显示购物车页面'''
        # 获取用户购物车中商品的信息
        user = request.user
        conn = get_redis_connection('default')
        cart_key = 'cart_%d' % user.id
        # {'商品id':'商品数目'}
        cart_dict = conn.hgetall(cart_key)
        # 遍历获取商品的信息
        skus = []
        total_count = 0  # 商品的总数目
        total_price = 0  # 商品的总价格
        for sku_id, count in cart_dict.items():
            sku = GoodsSKU.objects.get(id=sku_id)
            amount = sku.price * int(count)  # 商品的小计
            sku.amount = amount  # 动态增加商品属性
            sku.count = count  # 动态增加商品的数量
            skus.append(sku)
            total_count += int(count)
            total_price += amount

        # 组织上下文
        context = {
            'skus': skus,
            'total_count': total_count,
            'total_price': total_price
        }


        return render(request, 'cart.html', context)


# 购物车界面更新商品的数量
# 前端发起ajax请求
# 前端传递的参数：sku_id, count
# /cart/update
class CartUpdateView(View):
    '''购物车记录更新'''
    def post(self, request):
        user = request.user
        if not user.is_authenticated():
            return JsonResponse({'res': 0., 'errmsg': '请先登录'})
        # 接受数据
        sku_id = request.POST.get('sku_id')
        count = request.POST.get('count')

        # 数据校验
        if not all([sku_id, count]):
            return JsonResponse({'res': 1, 'errmsg': '数据不完整'})

        try:
            count = int(count)
        except Exception as e:
            return JsonResponse({'res': 2, 'errmsg': '商品数目出错'})

        try:
            sku = GoodsSKU.objects.get(id=sku_id)
        except GoodsSKU.DoesNotExist:
            return JsonResponse({'res': 3, 'errmsg': '商品不存在'})

        # 业务处理，更新购物车记录
        conn = get_redis_connection('default')
        cart_key = 'cart_%d' % user.id
        # 查看商品库存是否足够
        if count > sku.stock:
            return JsonResponse({'res': 4, 'errmsg': '商品库存不足'})
        # 更新
        conn.hset(cart_key, sku_id, count)

        # 统计用户购物车中商品的总件数
        total_count = 0
        vals = conn.hvals(cart_key)
        for val in vals:
            total_count += int(val)

        return JsonResponse({'res':5, 'msg':'更新成功', 'total_count':total_count})


# 删除购物车中一个商品
# 前端发起ajax post 请求
# 前端传递的参数：sku_id
# /cart/delete
class CartDeleteView(View):
    '''删除购物车中的商品'''
    def post(self, request):
        user = request.user
        if not user.is_authenticated():
            return JsonResponse({'res': 0., 'errmsg': '请先登录'})

        # 接受参数
        sku_id = request.POST.get('sku_id')

        # 数据校验
        try:
            sku = GoodsSKU.objects.get(id=sku_id)
        except Exception as e:
            return JsonResponse({'res':1, 'errmsg':'商品不存在'})

        # 业务处理：删除购物车中的商品
        conn = get_redis_connection('default')
        cart_key = 'cart_%d' % user.id

        # 删除
        conn.hdel(cart_key, sku_id)

        # 统计用户购物车中商品的总件数
        total_count = 0
        vals = conn.hvals(cart_key)
        for val in vals:
            total_count += int(val)

        return JsonResponse({'res':2, 'msg':'删除成功', 'total_count':total_count})
