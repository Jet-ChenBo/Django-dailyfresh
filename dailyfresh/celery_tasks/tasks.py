# 使用celery
from celery import Celery
from django.core.mail import send_mail
from django.conf import settings
from django.template import loader,RequestContext


# 任务处理者加下面的初始化代码
import os
import django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "dailyfresh.settings")
django.setup()

from goods.models import GoodsType,IndexGoodsBanner,IndexPromotionBanner,IndexTypeGoodsBanner



# 创建一个Celery的实力对象，第一个参数可随便写，第二个参数指定用redis作为broker，用第8个数据库
app = Celery('celery_tasks.tasks', broker='redis://127.0.0.1:6379/8')

# 创建任务函数
@app.task  # 装饰器将任务注册到broker的队列中。
def send_register_active_emali(to_email, username, token):
    '''发送激活邮件'''
    subject = '天天生鲜欢迎您'  # 主题
    message = ''  # 正文，不能传html标签
    sender = settings.EMAIL_FROM  # 发送者
    receiver = [to_email]  # 收件人邮箱
    html_message = '''
                           <h1>%s,欢迎您成为天天生鲜会员</h1>请点击下面的链接激活您的账户</br>
                           <a href="http:127.0.0.1:8000/user/active/%s">激活账户</a>
                          ''' % (username, token)  # 正文，可以传html标签
    send_mail(subject, message, sender, receiver, html_message=html_message)

@app.task
def generate_static_index_html():
    '''产生首页静态页面'''
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

    # 使用模板
    # 1.加载模板文件
    temp = loader.get_template('static_index.html')
    # 2.模板渲染
    static_index_html = temp.render(context)

    # 生成首页对应的静态文件
    save_path = '/home/cb/dailyfresh_static/index.html'
    with open(save_path, 'w') as f:
        f.write(static_index_html)