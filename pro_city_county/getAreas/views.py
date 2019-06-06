from django.shortcuts import render
from django.http import JsonResponse
from getAreas.models import AreaInfo


# /areas
def areas(request):
    return render(request, 'get_areas.html')

# /cities参数
def cities(request,pid):
    '''获取省级信息以及下级地区'''
    if pid == '':
        areas = AreaInfo.objects.filter(aParent__isnull=True)
    else:
        areas = AreaInfo.objects.filter(aParent__id=pid)

    area_list = []
    for area in areas:
        area_list.append((area.id, area.atitle))

    return JsonResponse({'data':area_list})