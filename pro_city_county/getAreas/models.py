from django.db import models

class AreaInfo(models.Model):
    '''省市县模型类'''
    atitle = models.CharField(max_length=20)
    aParent = models.ForeignKey('self', null=True, blank=True)

    class Meta:
        db_table = 'areas'