"""Full WGS84 longitude/latitude continent geometry and masks for SceneKit.
Natural Earth, public domain. Independent of the flat map projection.
"""
from pathlib import Path
import json
root = Path(__file__).resolve().parents[2]
folder = Path(__file__).parent
out = root / 'VisaDone/Resources/Maps'
def polygons(feature):
    g=feature['geometry']
    return g['coordinates'] if g['type']=='MultiPolygon' else [g['coordinates']]
def clip(ring, bound, left):
    result=[]
    for a,b in zip(ring,ring[1:]+ring[:1]):
        ina=a[0]<=bound if left else a[0]>=bound
        inb=b[0]<=bound if left else b[0]>=bound
        if ina: result.append(a[:2])
        if ina != inb:
            t=(bound-a[0])/(b[0]-a[0])
            result.append([bound,a[1]+t*(b[1]-a[1])])
    return result
names={'Europe':'欧洲','Asia':'亚洲','Africa':'非洲','North America':'北美洲','South America':'南美洲','Oceania':'大洋洲','Antarctica':'南极洲'}
regions={key:dict(id=key,name=name,rings=[]) for key,name in names.items()}
source=json.loads((folder/'ne_110m_admin_0_countries.geojson').read_text())
for feature in source['features']:
    props=feature['properties'];region=props['CONTINENT'];code=props['ADM0_A3']
    if region not in regions: continue
    for polygon in polygons(feature):
        ring=polygon[0]
        parts=[(region,ring)]
        if code=='RUS':
            parts=[('Asia',ring)] if max(pt[0] for pt in ring)<0 else [('Europe',clip(ring,60,True)),('Asia',clip(ring,60,False))]
        if code=='FRA' and sum(pt[1] for pt in ring)/len(ring)<20:
            parts=[('South America',ring)]
        for target,part in parts:
            if len(part)>=3: regions[target]['rings'].append([[round(pt[0],6),round(pt[1],6)] for pt in part])
(out/'globe-regions.json').write_text(json.dumps(list(regions.values()),ensure_ascii=False,separators=(',',':')))
print('Seven complete geographic regions written')


# Alpha masks share the complete equirectangular extent of the terrain.
from PIL import Image, ImageDraw
w,h=4000,2000
for region in regions.values():
    mask=Image.new('L',(w,h));draw=ImageDraw.Draw(mask)
    for ring in region['rings']:
        draw.polygon([((lon+180)/360*w,(90-lat)/180*h) for lon,lat in ring],fill=255)
    image=Image.new('RGBA',(w,h),(255,255,255,0));image.putalpha(mask)
    image.save(out/('globe-mask-'+region['id'].lower().replace(' ','-')+'.png'),optimize=True)
