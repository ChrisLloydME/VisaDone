from PIL import Image,ImageFilter
import numpy as np
from pathlib import Path
root=Path(__file__).resolve().parents[2]
a=np.array(Image.open(root/'DesignResources/Maps/NE2_flat_ocean.png').convert('RGB')).astype(float)
# Keep the geographic source intact; replace the old exaggerated relief palette.
water=np.max(abs(a-np.array([111,171,211])),axis=2)<4
l=a.mean(axis=2)
latitude=np.abs(90-np.arange(a.shape[0])[:,None]/a.shape[0]*180)
sand=np.clip((a[:,:,0]-a[:,:,2]-8)/45,0,1)
snow=np.clip((a.min(axis=2)-205)/40,0,1)*np.clip((latitude-50)/12,0,1)
base=np.array([122,146,130])[None,None,:]*(1-sand[:,:,None])+np.array([177,167,143])[None,None,:]*sand[:,:,None]
relief=np.clip((l-160)*.16,-10,13)
base+=relief[:,:,None]
base=base*(1-snow[:,:,None])+np.array([210,220,218])[None,None,:]*snow[:,:,None]
base[water]=[36,65,86]
img=Image.fromarray(base.clip(0,255).astype('uint8')).filter(ImageFilter.GaussianBlur(.4))
# Geographic borders remain restrained, separate from relief colors.
import json
from PIL import ImageDraw
b=Image.new('RGBA',img.size);d=ImageDraw.Draw(b)
for f in json.loads((root/'DesignResources/Maps/ne_50m_admin_0_countries.geojson').read_text())['features']:
 g=f['geometry'];polys=g['coordinates'] if g['type']=='MultiPolygon' else [g['coordinates']]
 for p in polys:d.line([((x+180)/360*img.width,(90-y)/180*img.height) for x,y,*_ in p[0]],fill=(236,241,231,85),width=1)
Image.alpha_composite(img.convert('RGBA'),b).convert('RGB').save(root/'VisaDone/Resources/Maps/earth-natural.jpg',quality=94)
