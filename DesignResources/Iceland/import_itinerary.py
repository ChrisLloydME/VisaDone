import json
from pathlib import Path
from openpyxl import load_workbook
root=Path('/Users/lloyd/Developer/Xcode/VisaDone')
s=load_workbook(root/'DesignResources/Iceland/Itinerary.original.xlsx',data_only=True).active
starts=[r for r in range(3,s.max_row+1) if isinstance(s.cell(r,1).value,int)]
starts.append(s.max_row+1)
titles=['出发前夜，机场报到','经慕尼黑抵达哥本哈根','哥本哈根与冰岛的衔接','雷克雅未克市区','斯奈山半岛一日小团','黄金圈，向南岸出发','冰河湖、冰川与冰洞','沿南岸返回雷克雅未克','雷克雅内斯半岛与极光','小团后的机动与休息','蓝湖与离开冰岛','哥本哈根，经慕尼黑返程','返回上海']
routes=['上海浦东机场','上海 → 慕尼黑 → 哥本哈根','哥本哈根 → 凯夫拉维克 → 雷克雅未克','雷克雅未克市区','雷克雅未克 → 斯奈山半岛 → 雷克雅未克','雷克雅未克 → 黄金圈 → 南岸','冰岛东南部 · 冰河湖与瓦特纳冰川','南岸 → 雷克雅未克','雷克雅内斯半岛 → 雷克雅未克','雷克雅未克市区','雷克雅未克 → 蓝湖 → 凯夫拉维克 → 哥本哈根','哥本哈根 → 慕尼黑','慕尼黑 → 上海']
notes=['3月1日晚报到；LH727 于3月2日 00:10 起飞。','慕尼黑为首次申根入境地，中转4小时15分。LH4122 / VL2440 为原草稿中的航班标识。','FI213 20:45–23:15，之后乘 Flybus 入城；核对深夜抵达与酒店入住。','深夜抵达后的第一天，原草稿有8个停留点，可按体力删减。','Tröll Expeditions 一日小团作为计划保留，尚未据此确认真实预订。','Arctic Adventures 四日小团第1天。黄金圈与南岸衔接较长，停留以实际运营安排为准。','四日小团第2天；冰川徒步、冰洞与道路受天气影响。','四日小团第3天；今晚住宿为 Hotel Ísland – Comfort。','四日小团第4天。火山徒步地点由运营方决定；极光不保证可见。','预计凌晨00:00–01:00返回；白天以休息和机动为主。','SK2596 18:05–22:05；蓝湖接驳、机场报到和航班之间需留余量。','LH4133 / VL2443 18:20–20:00；慕尼黑中转2小时15分，LH726 于22:15离开申根。','LH726 于3月12日22:15从慕尼黑出发，3月13日16:50抵达上海。']
translations={
'Check in at Shanghai Pudong International Airport (PVG) for flight LH727 to Munich, scheduled to depart at 00:10 on Feb 2, 2027':'上海浦东机场报到，准备搭乘3月2日00:10的 LH727',
'Flight from Shanghai Pudong International Airport (PVG) to Munich Airport (MUC)':'LH727 · 上海 00:10 → 慕尼黑 06:35',
'Connection in Munich Airport (MUC) for 4 hours and 15 minutes':'慕尼黑中转 · 4小时15分',
'Flight from Munich Airport (MUC) to Copenhagen Kastrup Airport (CPH)':'LH4122 / VL2440 · 慕尼黑 10:50 → 哥本哈根 12:25',
'Sightseeing in Copenhagen downtown':'哥本哈根市区游览',
'Flight from Copenhagen Kastrup Airport (CPH) to Keflavik International Airport (KEF)':'FI213 · 哥本哈根 20:45 → 凯夫拉维克 23:15',
'Transfer from Keflavík International Airport (KEF) to hotel accommodation in Reykjavík':'乘 Flybus 从机场前往雷克雅未克酒店',
'Sightseeing in Reykjavík downtown':'雷克雅未克市区游览',
'1-day guided tour operated by Troll Expeditions':'Tröll Expeditions · 一日小团计划',
'Pickup in Reykjavík':'雷克雅未克集合接驳',
'Back to Reykjavík':'返回雷克雅未克',
'Day 1 of 4-day guided tour operated by Arctic Adventures':'Arctic Adventures · 四日小团第1天',
'Proceed to accommodation in Kirkjubæjarklaustur':'前往 Kirkjubæjarklaustur 住宿',
'Day 2 of 4-day guided tour operated by Arctic Adventures':'Arctic Adventures · 四日小团第2天',
'Return to accommodation in Kirkjubæjarklaustur':'返回 Kirkjubæjarklaustur 住宿',
'Day 3 of 4-day guided tour operated by Arctic Adventures':'Arctic Adventures · 四日小团第3天',
'Day 4 of 4-day guided tour operated by Arctic Adventures':'Arctic Adventures · 四日小团第4天',
'Guided hike near a recently erupted volcanic site on the Reykjanes Peninsula - 雷克雅内斯半岛火山遗址徒步\n(The exact location will be determined by the tour operator.)':'雷克雅内斯半岛火山遗址徒步 · 具体地点由运营方决定',
'Northern Lights hunting tour in the countryside away from Reykjavík city lights':'乡间极光寻找活动 · 视天气情况',
'Back to Reykjavík between 00:00 - 01:00':'凌晨00:00–01:00返回雷克雅未克',
'Leisure day in Reykjavík after the multi-day tour':'小团结束后的机动休息日',
'Walk around Reykjavík downtown':'雷克雅未克市区散步',
'Laugavegur Street':'洛加维格街', 'Old Harbour':'老港口',
'Purchase souvenirs and travel necessities, including a visit to Kringlan Shopping Centre.':'前往 Kringlan 购物中心，购买纪念品与旅行用品',
'Transfer to Blue Lagoon':'乘接驳车前往蓝湖',
'Blue Lagoon geothermal spa':'蓝湖温泉',
'Transfer to Keflavik International Airport (KEF)':'接驳前往凯夫拉维克机场',
'Flight from Keflavik International Airport (KEF) to Copenhagen Kastrup Airport (CPH)':'SK2596 · 凯夫拉维克 18:05 → 哥本哈根 22:05',
'Leisure and shopping in Copenhagen downtown':'哥本哈根市区购物与机动',
'Flight from Copenhagen Kastrup Airport (CPH) to Munich Airport (MUC)':'LH4133 / VL2443 · 哥本哈根 18:20 → 慕尼黑 20:00',
'Connection in Munich Airport (MUC) for 2 hours and 15 minutes':'慕尼黑中转 · 2小时15分',
'Flight from Munich Airport (MUC) to Shanghai Pudong International Airport (PVG)':'LH726 · 慕尼黑3月12日22:15 → 上海3月13日16:50'
}
transports=['国际航班前报到','LH727 · LH4122 / VL2440 · 市内公共交通','步行与公共交通 · FI213 · Flybus','步行与雷克雅未克公共交通','Tröll Expeditions 小巴一日团 [计划]','Arctic Adventures 小巴四日团 [计划]','Arctic Adventures 小巴四日团 [计划]','Arctic Adventures 小巴四日团 [计划]','Arctic Adventures 小巴四日团 [计划]','步行与雷克雅未克公共交通','蓝湖接驳巴士 · SK2596','步行与公共交通 · LH4133 / VL2443 · LH726','LH726 国际航班']
output=[]
for i,(start,end) in enumerate(zip(starts,starts[1:])):
    activities=[]
    for row in range(start,end):
        value=s.cell(row,5).value
        if value is None: continue
        text=str(value).strip()
        title=translations.get(text,text.split(' - ',1)[-1] if ' - ' in text else text)
        activities.append({'id':f'{i}-{row}','time':'行程','title':title})
    stay=str(s.cell(start,7).value or '夜间航班').split('\n')[0]
    if stay=='In Transit': stay='途中 / 夜间航班'
    if i==12: stay='抵达上海，不安排申根住宿'
    output.append(dict(id=i,title=titles[i],route=routes[i],transport=transports[i],stay=stay,confirmed=False,note=notes[i],activities=activities))
# Retain the curated English copy when refreshing the original workbook import.
existing_path=root/'VisaDone/Resources/Iceland/itinerary.json'
if existing_path.exists():
    existing={day['id']:day for day in json.loads(existing_path.read_text())}
    for day in output:
        previous=existing.get(day['id'],{})
        for key in ('titleEnglish','routeEnglish','transportEnglish','noteEnglish','stayDetails','transportDetails'):
            if key in previous: day[key]=previous[key]
        english={activity['id']:activity.get('english') for activity in previous.get('activities',[])}
        for activity in day['activities']:
            if english.get(activity['id']): activity['english']=english[activity['id']]
(root/'VisaDone/Resources/Iceland/itinerary.json').write_text(json.dumps(output,ensure_ascii=False,indent=2)+'\n')
print('Imported 13 itinerary sections; March 1–13, 2027; Schengen March 2–12. Original workbook unchanged.')
