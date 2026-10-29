"""Generate offline map paths from public-domain Natural Earth country polygons.
Natural Earth I projection coefficients follow d3-geo (ISC; see Licenses/d3-geo-ISC.txt).
The 60°E split in Russia is a simplified geographic division for this region picker.
"""
import json, math
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
source = json.loads((Path(__file__).parent / 'ne_110m_admin_0_countries.geojson').read_text())

def project(lon, lat):
    l, p = math.radians(lon), math.radians(max(-85, min(85, lat)))
    p2, p4 = p*p, p**4
    x = l*(.8707-.131979*p2+p4*(-.013791+p4*(.003971*p2-.001529*p4)))
    y = p*(1.007226+p2*(.015085+p4*(-.044475+.028874*p2-.005916*p4)))
    return [round((x+2.736)/5.472,6),round((1.422-y)/2.844,6)]

def clip(ring, bound, left):
    out=[]
    for a,b in zip(ring,ring[1:]+ring[:1]):
        ina = a[0]<=bound if left else a[0]>=bound
        inb = b[0]<=bound if left else b[0]>=bound
        if ina: out.append(a)
        if ina != inb:
            t=(bound-a[0])/(b[0]-a[0]);out.append([bound,a[1]+t*(b[1]-a[1])])
    return out

names={'Europe':'欧洲','Asia':'亚洲','Africa':'非洲','North America':'北美洲','South America':'南美洲','Oceania':'大洋洲','Antarctica':'南极洲'}
centers={'Europe':(19,53),'Asia':(97,43),'Africa':(19,2),'North America':(-105,41),'South America':(-60,-18),'Oceania':(137,-27),'Antarctica':(12,-77)}
continents={k:dict(id=k,name=v,label=project(*centers[k]),rings=[]) for k,v in names.items()}
countries=[]
for f in source['features']:
    p=f['properties'];g=f['geometry'];region=p['CONTINENT'];code=p['ADM0_A3']
    if region not in continents: continue
    polys=g['coordinates'] if g['type']=='MultiPolygon' else [g['coordinates']]
    countryRings=[]
    for poly in polys:
        ring=poly[0] # Outer coastlines only; the picker has no lake interactions.
        parts=[(region,ring)]
        if code=='RUS':
            # Natural Earth splits Chukotka at the antimeridian. Negative
            # longitudes here are eastern Asia, not the west-of-60°E Europe.
            if max(pt[0] for pt in ring)<0:
                parts=[('Asia',ring)]
            else:
                parts=[('Europe',clip(ring,60,True)),('Asia',clip(ring,60,False))]
        if code=='FRA' and sum(pt[1] for pt in ring)/len(ring)<20: parts=[('South America',ring)]
        for target,part in parts:
            if len(part)<3:continue
            projected=[project(*pt[:2]) for pt in part]
            continents[target]['rings'].append(projected)
            if target=='Europe' and max(pt[1] for pt in part)>30:
                countryRings.append(projected)
    if region=='Europe' and countryRings:
        countries.append(dict(id=code,name=p.get('NAME_ZH') or p['NAME'],english=p['NAME_LONG'],
                              label=project(p['LABEL_X'],p['LABEL_Y']),rings=countryRings))
# Focus on geographic Europe. Overseas polygons are not destinations in this picker.
for c in countries:
    c['rings']=[ring for ring in c['rings'] if min(pt[1] for pt in ring)<.4 and max(pt[0] for pt in ring)>.39]
# The Europe close-up uses finer coastlines, simplified before bundling.
def simplify(points, tolerance=.025):
    if len(points)<4:return points
    a,b=points[0],points[-1];dx,dy=b[0]-a[0],b[1]-a[1];den=dx*dx+dy*dy
    def distance(p):
        t=max(0,min(1,((p[0]-a[0])*dx+(p[1]-a[1])*dy)/den)) if den else 0
        return (p[0]-a[0]-t*dx)**2+(p[1]-a[1]-t*dy)**2
    index=max(range(1,len(points)-1),key=lambda i:distance(points[i]))
    if distance(points[index])>tolerance*tolerance:
        return simplify(points[:index+1],tolerance)[:-1]+simplify(points[index:],tolerance)
    return [a,b]

countries=[]
fine=json.loads((Path(__file__).parent/'ne_50m_admin_0_countries.geojson').read_text())
for f in fine['features']:
    p=f['properties'];g=f['geometry'];code=p['ADM0_A3']
    if p['CONTINENT']!='Europe':continue
    polys=g['coordinates'] if g['type']=='MultiPolygon' else [g['coordinates']]
    rings=[]
    for poly in polys:
        ring=poly[0]
        if code=='RUS':
            if max(pt[0] for pt in ring)<0:continue
            ring=clip(ring,60,True)
        if len(ring)<4 or max(pt[1] for pt in ring)<30:continue
        ring=simplify(ring)
        if len(ring)>3:rings.append([project(*pt[:2]) for pt in ring])
    if rings:
        countries.append(dict(id=code,name=p.get('NAME_ZH') or p['NAME'],english=p['NAME_LONG'],label=project(p['LABEL_X'],p['LABEL_Y']),rings=rings))
output=dict(continents=list(continents.values()),countries=countries)
(ROOT/'VisaDone/Resources/Maps/destination-map.json').write_text(json.dumps(output,separators=(',',':'),ensure_ascii=False))
print(len(countries),'countries;',sum(len(c['rings']) for c in output['continents']),'land polygons')
