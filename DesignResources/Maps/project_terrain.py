"""Reproject public-domain Natural Earth II data to the vector map's coordinates.
Use the bundled Python runtime with Pillow and NumPy. No AI imagery or tiles.
"""
from pathlib import Path
import numpy as np
from PIL import Image
root=Path(__file__).resolve().parents[2]
source=Image.open(Path(__file__).parent/'NE2_flat_ocean.png').convert('RGB')
pixels=np.asarray(source)
w,h=4096,2129
# Invert the same Natural Earth I projection used in generate.py.
y=1.422-(np.arange(h)+.5)/h*2.844
phi=np.clip(y,-1.48,1.48)
for _ in range(12):
 p2=phi*phi;p4=p2*p2
 fy=phi*(1.007226+p2*(.015085+p4*(-.044475+.028874*p2-.005916*p4)))
 derivative=1.007226+p2*(.015085*3+p4*(-.044475*7+.028874*9*p2-.005916*11*p4))
 phi-= (fy-y)/derivative
p2=phi*phi;p4=p2*p2
scale=.8707-.131979*p2+p4*(-.013791+p4*(.003971*p2-.001529*p4))
x=(np.arange(w)+.5)/w*5.472-2.736
lon=x[None,:]/scale[:,None]
lat=phi[:,None]*np.ones((1,w))
sx=(lon/(2*np.pi)+.5)*source.width-.5
sy=(.5-lat/np.pi)*source.height-.5
valid=(np.abs(lon)<=np.pi)&(np.abs(lat)<=np.pi/2)
x0=np.floor(sx).astype(int);y0=np.floor(sy).astype(int)
fx=(sx-x0)[...,None];fy=(sy-y0)[...,None]
x1=np.clip(x0+1,0,source.width-1);y1=np.clip(y0+1,0,source.height-1)
x0=np.clip(x0,0,source.width-1);y0=np.clip(y0,0,source.height-1)
rgb=(pixels[y0,x0]*(1-fx)*(1-fy)+pixels[y0,x1]*fx*(1-fy)+pixels[y1,x0]*(1-fx)*fy+pixels[y1,x1]*fx*fy).astype('uint8')
rgba=np.dstack((rgb,valid.astype('uint8')*255))
path=root/'VisaDone/Resources/Maps/destination-terrain.png'
Image.fromarray(rgba).save(path,optimize=True)
print(source.size,'->',path.name,(w,h))
