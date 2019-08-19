from django.core.files.storage import Storage, FileSystemStorage
from fdfs_client.client import Fdfs_client

class FDFSStorage(Storage):
    '''Fast DFS文件存储类'''
    def _open(self, name, mode='rb'):
        '''打开文件时使用'''
        pass

    def _save(self, name, content):
        '''保存文件时使用'''
        # name是文件名字，content是包含文件内容的File对象

        client = Fdfs_client('/etc/fdfs/client.conf')
       # client = Fdfs_client('./utils/client.conf')    两种都可以

        # 通过文件内容上传文件
        res = client.upload_by_buffer(content.read())

        if res.get('Status') != 'Upload successed.':
            print(res.get('Status'))
            raise Exception('上传文件到fast dfs失败')

        # 获取返回的文件id
        filename = res.get('Remote file_id')

        return filename     # 将文件id保存在数据库

    def exists(self, name):
        '''Django判断文件名是否可用'''
        # 重写的函数，False代表可用
        return False

    def url(self, name):
        '''返回访问文件的url路径'''
        # name是save方法返回的文件id
        # goods.image.url 会调用这个方法
        return 'http://127.0.0.1:8888/%s' % name