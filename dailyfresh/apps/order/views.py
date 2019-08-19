from django.shortcuts import render,redirect
from django.http import JsonResponse
from django.views.generic import View
from django.core.urlresolvers import reverse
from django.conf import settings
from goods.models import GoodsSKU
from user.models import Address
from order.models import OrderInfo,OrderGoods
from django_redis import get_redis_connection
from utils.mixin import LoginRequiredMixmin
from datetime import datetime
import os

from django.db import transaction
from alipay import AliPay   # 支付

# /order/place
class OrderPlaceView(LoginRequiredMixmin, View):
    '''提交订单页面显示'''
    def post(self, request):
        user = request.user
        # 获取参数
        sku_ids = request.POST.getlist('sku_ids')
        # 校验参数
        if not sku_ids:
            # 跳转到购物车界面
            return redirect(reverse('cart:show'))

        conn = get_redis_connection('default')
        cart_key = 'cart_%d' % user.id
        skus = []
        total_count = 0  # 保存商品的总件数和总价格
        total_price = 0

        # 遍历sku_ids获取用户要购买的商品的信息
        for sku_id in sku_ids:
            sku = GoodsSKU.objects.get(id=sku_id)
            # 获取用户所购买的商品的数量
            count = conn.hget(cart_key, sku_id)
            # 计算商品的小计
            amount = sku.price * int(count)
            # 动态增加商品的属性
            sku.count = count
            sku.amount = amount
            # 累加商品的总件数和价格
            total_count += int(count)
            total_price += amount

            skus.append(sku)

        # 运费：实际开发时需要单独建立一个子系统来计算
        transit_price = 10

        # 实付款
        total_pay = total_price + transit_price

        # 获取用户的收件地址
        address = Address.objects.filter(user=user)

        # 获取用户购买的商品的id字符串
        sku_ids = ','.join(sku_ids)

        # 组织上下文
        context = {
            'skus': skus,
            'total_count': total_count,
            'total_price': total_price,
            'transit_price': transit_price,
            'total_pay': total_pay,
            'address': address,
            'sku_ids': sku_ids
        }

        return render(request, 'place_order.html', context)


# 前端传递的参数：地址id，支付方式，购买的商品id字符串
# mysql事务
# 并发
# /order/commit
class OrderCommitView(View):
    '''创建订单'''
    @transaction.atomic  # 事务
    def post(self, request):
        # 判断用户是否登录
        user = request.user
        if not user.is_authenticated():
            return JsonResponse({'res':0, 'errmsg':'请先登陆'})

        # 获取参数
        addr_id = request.POST.get("addr_id")
        pay_style = request.POST.get('pay_style')
        sku_ids = request.POST.get('sku_ids')

        # 数据校验
        if not all([addr_id, pay_style, sku_ids]):
            return JsonResponse({'res':1, 'errmsg':'数据不完整'})

        # 校验支付方式
        if eval(pay_style) not in OrderInfo.PAY_METHOD_keys:
            return JsonResponse({'res':2, 'errmsg':'非法的支付方式'})

        # 校验地址
        try:
            addr = Address.objects.get(id=addr_id)
        except Address.DoesNotExist:
            return JsonResponse({'res':3, 'errmsg':'地址非法'})

        # todo: 业务处理：创建订单

        # 组织参数
        # 订单id,格式：20190620210930+用户id
        order_id = datetime.now().strftime('%Y%m%d%H%M%S')+ str(user.id)
        # 运费
        transit_price = 10
        # 总数目和总金额
        total_count = 0
        total_price = 0

        # todo: 在操作数据库之前设置保存点
        save_id = transaction.savepoint()
        try:
            # todo: 向df_order_info表中加入一条记录
            order = OrderInfo.objects.create(order_id=order_id,
                                             user=user,
                                             addr=addr,
                                             pay_method=pay_style,
                                             total_count=total_count,
                                             total_price=total_price,
                                             transit_price=transit_price)

            # todo: 用户订单中有几个商品,需要向df_order_goods表中加几条记录
            sku_ids = sku_ids.split(',')
            for sku_id in sku_ids:
                # 获取商品的信息
                for i in range(3):
                    try:
                        sku = GoodsSKU.objects.get(id=sku_id)
                    except:
                        # 回滚
                        transaction.savepoint_rollback(save_id)
                        return JsonResponse({'res':4, 'errmsg':'商品不存在'})

                    # todo: 从redis获取用户所要购买的的商品的数量
                    conn = get_redis_connection('default')
                    cart_key = 'cart_%d' % user.id

                    count = conn.hget(cart_key, sku_id)

                    # todo: 判断商品的库存
                    if int(count)>sku.stock:
                        # 回滚
                        transaction.savepoint_rollback(save_id)
                        return JsonResponse({'res':6, 'errmsg':'商品库存不足'})

                    # todo: 更新商品的库存和销量
                    orgin_stock = sku.stock
                    new_stock = orgin_stock - int(count)
                    new_sales = sku.sales + int(count)

                    # 返回受影响的行数
                    res = GoodsSKU.objects.filter(id=sku_id, stock=orgin_stock).update(stock=new_stock, sales=new_sales)
                    if(res == 0):
                        if i == 2:  # 尝试第三次
                            transaction.savepoint_rollback(save_id)
                            return JsonResponse({'res':7, 'errmsg':'下单失败'})
                        continue

                    # todo: 向df_order_goods表中添加一条记录
                    OrderGoods.objects.create(order=order,
                                              sku = sku,
                                              count=count,
                                              price=sku.price)

                    # todo: 累加计算商品的总数量和总价格
                    amount = sku.price * int(count)
                    total_count += int(count)
                    total_price += amount

                    # 跳出循环
                    break

            # todo: 更新订单表中的商品总数量和价格
            order.total_count = total_count
            order.total_price = total_price
            order.save()
        except Exception as e:
            # 回滚
            transaction.savepoint_rollback(save_id)
            return JsonResponse({"res":9, 'errmsg':'下单失败！！！'})

        # todo：提交save_id到此位置的所有数据库操作
        transaction.savepoint_commit(save_id)

        # todo: 清除用户购物车的对应的记录
        conn.hdel(cart_key, *sku_ids)

        return JsonResponse({'res':5, 'msg':'创建成功'})


# 前端ajax post，传递参数订单id，
# /order/pay
class OrderPayView(View):
    '''订单支付'''
    def post(self, request):
        user = request.user
        if not user.is_authenticated():
            return JsonResponse({'res':0, 'errmsg':'用户未登录'})
        # 接受参数
        order_id = request.POST.get('order_id')

        # 校验参数
        if not order_id:
            return JsonResponse({'res':1, 'errmsg':'无效的订单id'})

        try:
            order = OrderInfo.objects.get(order_id=order_id,
                                          user=user,
                                          pay_method=3,
                                          order_status=1)
        except OrderInfo.DoesNotExist:
            return JsonResponse({'res':2, 'errmsg':'订单错误,不是支付宝支付'})

        # 业务处理，使用python-sdk调用支付宝接口
        # from alipay import AliPay
        # 初始化
        alipay = AliPay(
            appid="2016101100658212",  # 沙箱里的APPID
            app_notify_url=None,  # 默认回调url
            app_private_key_path=os.path.join(settings.BASE_DIR, 'apps/order/app_private_key.pem'),
            alipay_public_key_path=os.path.join(settings.BASE_DIR, 'apps/order/alipay_public_key.pem'),
            sign_type="RSA2",  # RSA 或者 RSA2
            debug = True  # 默认False,用沙箱的地址需要改成True
        )

        # 调用支付接口
        # 电脑网站支付，需要跳转到https://openapi.alipaydev.com/gateway.do? + order_string
        order_string = alipay.api_alipay_trade_page_pay(
            out_trade_no=order_id,  # 订单id
            total_amount=str(order.total_price + order.transit_price),  # 总金额 DecimalField不能序列化
            subject='天天生鲜%s' % order_id,  # 订单主题
            return_url=None,
            notify_url=None  # 可选, 不填则使用默认notify url
        )

        # 返回应答
        pay_url = 'https://openapi.alipaydev.com/gateway.do?' + order_string
        return JsonResponse({'res':3, 'pay_url':pay_url})


# 前端ajax post，传递订单id
# /order/check
class CheckPayView(View):
    '''查询支付结果'''
    def post(self, request):
        user = request.user
        if not user.is_authenticated():
            return JsonResponse({'res': 0, 'errmsg': '用户未登录'})
        # 接受参数
        order_id = request.POST.get('order_id')

        # 校验参数
        if not order_id:
            return JsonResponse({'res': 1, 'errmsg': '无效的订单id'})

        try:
            order = OrderInfo.objects.get(order_id=order_id,
                                          user=user,
                                          pay_method=3,
                                          order_status=1)
        except OrderInfo.DoesNotExist:
            return JsonResponse({'res': 2, 'errmsg': '订单错误,不是支付宝支付'})

        # 业务处理，使用python-sdk调用支付宝接口
        # from alipay import AliPay
        # 初始化
        alipay = AliPay(
            appid="2016101100658212",  # 沙箱里的APPID
            app_notify_url=None,  # 默认回调url
            app_private_key_path=os.path.join(settings.BASE_DIR, 'apps/order/app_private_key.pem'),
            alipay_public_key_path=os.path.join(settings.BASE_DIR, 'apps/order/alipay_public_key.pem'),
            sign_type="RSA2",  # RSA 或者 RSA2
            debug=True  # 默认False,用沙箱的地址需要改成True
        )

        # 调用支付宝的交易查询接口
        while True:
            response = alipay.api_alipay_trade_query(order_id)
            """
                   response = {           
                       "trade_no": "2017032121001004070200176844",  # 支付宝的交易号
                       "code": "10000",   # 接口调用是否成功
                       "invoice_amount": "20.00",
                       "open_id": "20880072506750308812798160715407",
                       "fund_bill_list": [
                         {
                           "amount": "20.00",
                           "fund_channel": "ALIPAYACCOUNT"
                         }
                       ],
                       "buyer_logon_id": "csq***@sandbox.com",
                       "send_pay_date": "2017-03-21 13:29:17",
                       "receipt_amount": "20.00",
                       "out_trade_no": "out_trade_no15",
                       "buyer_pay_amount": "20.00",
                       "buyer_user_id": "2088102169481075",
                       "msg": "Success",
                       "point_amount": "0.00",
                       "trade_status": "TRADE_SUCCESS",  # 支付结果
                       "total_amount": "20.00"
                   }
            """
            code = response.get('code')
            trade_status = response.get('trade_status')
            if code == '10000' and trade_status == 'TRADE_SUCCESS':
                # 支付成功
                # 获取支付宝交易号
                trade_no = response.get('trade_no')
                # 更新订单状态
                order.trade_no = trade_no
                order.order_status = 4  # 待评价
                order.save()

                return JsonResponse({'res':3, 'msg':'支付成功'})

            elif code == '40004' or (code == '10000' and trade_status == 'WAIT_BUYER_PAY'):
                # 等待买家付款
                # 业务处理失败，可能等一会就会成功
                import time
                time.sleep(5)
                continue

            else:
                # 支付出错
                return JsonResponse({"res":4, 'errmsg':'支付失败'})


# /order/comment/订单id
class CommentView(View):
    '''订单评论'''
    def get(self, request, order_id):
        '''显示评价页面'''
        user = request.user

        if not order_id:
            return redirect(reverse('user:order'))

        try:
            order = OrderInfo.objects.get(order_id=order_id, user=user)
        except OrderInfo.DoesNotExist:
            return redirect(reverse('user:order'))

        # 根据订单的状态获取订单的标题
        order.status_name = OrderInfo.ORDER_STATUS[order.order_status]

        # 获取订单商品信息
        order_skus = OrderGoods.objects.filter(order=order_id)
        for order_sku in order_skus:
            # 计算商品的小计
            amount = order_sku.count * order_sku.price
            order_sku.amount = amount
        order.order_skus = order_skus

        return render(request, 'order_comment.html', {'order':order})

    def post(self, request, order_id):
        '''处理评论信息'''
        user = request.user

        if not order_id:
            return redirect(reverse('user:order'))

        try:
            order = OrderInfo.objects.get(order_id=order_id, user=user)
        except OrderInfo.DoesNotExist:
            return redirect(reverse('user:order'))

        # 获取评论条数
        total_count = request.POST.get('total_count')
        total_count = int(total_count)

        # 循环获取订单中商品的评论内容
        for i in range(1, total_count+1):
            # 获取评论的商品的id
            sku_id = request.POST.get('sku_%d' % i)
            # 获取评论商品的内容
            content = request.POST.get('content_%d' % i, '')
            try:
                order_goods = OrderGoods.objects.get(order=order,sku=sku_id)
            except OrderGoods.DoesNotExist:
                continue
            order_goods.comment = content
            order_goods.save()

        order.order_status = 5  # 已完成
        order.save()

        return redirect(reverse('user:order', kwargs={'page':1}))

