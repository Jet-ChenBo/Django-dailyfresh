from django.shortcuts import render,redirect
from django.core.urlresolvers import reverse
from django.views.generic import View
from goods.models import GoodsType,GoodsSKU,IndexGoodsBanner,IndexPromotionBanner,IndexTypeGoodsBanner
from order.models import OrderGoods
from django.core.cache import cache
from django_redis import get_redis_connection
from django.core.paginator import Paginator


# /index
class IndexView(View):
    '''首页'''
    def get(self, request):
        '''首页'''
        # 尝试从缓存获取数据
        context = cache.get('index_page_data')
        if context is None:
            print('\n设置缓存\n')

            # 获取商品的种类信息
            types = GoodsType.objects.all()

            # 获取首页轮播商品信息
            goods_banners = IndexGoodsBanner.objects.all().order_by('index')

            # 获取首页促销活动信息
            promotion_banners = IndexPromotionBanner.objects.all().order_by('index')

            # 获取首页分类商品展示信息
            for type in types:
                # 获取type种类首页分类商品的图片展示信息
                image_banners = IndexTypeGoodsBanner.objects.filter(type=type, display_type=1).order_by('index')
                # 获取type种类首页分类商品的文字展示信息
                title_banners = IndexTypeGoodsBanner.objects.filter(type=type, display_type=0).order_by('index')

                # 动态给type增加属性，分别保存首页分类商品的图片展示信息和文字展示信息
                type.image_banners = image_banners
                type.title_banners = title_banners

            # 组织模板上下文
            context = {
                'types': types,
                'goods_banners': goods_banners,
                'promotion_banners': promotion_banners
            }

            # 设置缓存
            cache.set('index_page_data', context, 3600)

        # 获取用户购物车中商品的数量
        user = request.user
        cart_count = 0
        if user.is_authenticated():
            conn = get_redis_connection('default')
            cart_key = 'cart_%d' % user.id
            cart_count = conn.hlen(cart_key)

        context.update(cart_count=cart_count)

        return render(request, 'index.html', context)


# /goods/商品id
class DetailView(View):
    '''详情页'''
    def get(self, request, goods_id):
        '''显示详情页'''
        # 获取商品
        try:
            sku = GoodsSKU.objects.get(id=goods_id)
        except GoodsSKU.DoesNotExist:
            return redirect(reverse('goods：index'))

        # 获取商品的分类信息
        types = GoodsType.objects.all()

        # 获取商品的评论信息
        sku_orders = OrderGoods.objects.filter(sku=sku).exclude(comment='')

        # 获取新品信息
        new_skus = GoodsSKU.objects.filter(type=sku.type).order_by('-create_time')[:2]

        # 获取同一个SPU的其他规格的商品
        same_spu_skus = GoodsSKU.objects.filter(goods=sku.goods).exclude(id=goods_id)

        # 获取用户购物车中商品的数量
        user = request.user
        cart_count = 0
        if user.is_authenticated():
            conn = get_redis_connection('default')
            cart_key = 'cart_%d' % user.id
            cart_count = conn.hlen(cart_key)

            # 添加用户的历史浏览记录
            # 1.移除已经浏览过的重复的商品,没有的话不会报错
            history_key = 'history_%d' % user.id
            conn.lrem(history_key,0,goods_id)
            # 2.存储历史浏览记录，左侧插入
            conn.lpush(history_key, goods_id)
            # 3.只保存五条
            conn.ltrim(history_key,0,4)



        # 组织模板上下文
        context = {
            'sku': sku,
            'types': types,
            'sku_orders': sku_orders,
            'same_spu_skus': same_spu_skus,
            'new_skus': new_skus,
            'cart_count': cart_count
        }

        return render(request, 'detail.html', context)


# /list/种类id/页码/排序方式
# /list?tyep_id=种类id&page=页码&sort=排序方式
# /list/种类id/页码？sort=排序方式    [采用这种]
class ListView(View):
    '''列表页'''
    def get(self, request, type_id, page):
        '''显示列表页'''
        # 获取种类信息
        try:
            type = GoodsType.objects.get(id=type_id)
        except GoodsType.DoesNotExist:
            return redirect(reverse('goods:index'))

        # 获取排序的方式
        # sort=default  按照id排序
        # sort=price    按照价格排序
        # sort=hot      按照销量排序
        sort = request.GET.get('sort')

        # 获取商品分类信息
        types = GoodsType.objects.all()

        # 获取分类商品的信息
        if sort == 'price':
            skus = GoodsSKU.objects.filter(type=type).order_by('price')
        elif sort == 'hot':
            skus = GoodsSKU.objects.filter(type=type).order_by('-sales')
        else:
            sort = 'default'
            skus = GoodsSKU.objects.filter(type=type).order_by('-id')

        # 分页
        paginator = Paginator(skus, 1)

        # 获取第page页的内容
        try:
            page = int(page)
        except Exception as e:
            page = 1
        if page > paginator.num_pages:
            page = 1

        # 获取第page页的实例对象
        skus_page = paginator.page(page)

        # todo: 进行页码控制，页面上最多显示5个页码
        # 1.总页数小于等于五页，页面上显示所有页码
        # 2.如果当前是前三页，显示1-5页
        # 3.如果当前是倒数后三页，显示倒数1-5页
        # 4.其他情况，显示当前页和前后2页
        num_pages = paginator.num_pages
        if num_pages <= 5:
            pages = range(1, num_pages+1)
        elif num_pages <= 3:
            pages = range(1,6)
        elif num_pages-page <=2:
            pages = range(num_pages-4,num_pages+1)
        else:
            pages = range(num_pages-2, num_pages+3)

        # 获取新品信息
        new_skus = GoodsSKU.objects.filter(type=type).order_by('-create_time')[:2]

        # 获取用户购物车中商品的数量
        user = request.user
        cart_count = 0
        if user.is_authenticated():
            conn = get_redis_connection('default')
            cart_key = 'cart_%d' % user.id
            cart_count = conn.hlen(cart_key)

        # 组织模板上下文
        context = {
            'type': type,
            'types': types,
            'skus_page': skus_page,
            'new_skus': new_skus,
            'cart_count': cart_count,
            'pages': pages,
            'sort': sort
        }

        return render(request, 'list.html', context)