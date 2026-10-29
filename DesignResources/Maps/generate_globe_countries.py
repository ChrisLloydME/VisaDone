"""Public-domain Natural Earth 50m country outlines in geodetic coordinates.
Independent of the projected flat map; shared by globe picking and highlight.
"""
import json
from pathlib import Path
folder = Path(__file__).parent
root = folder.parents[1]
metadata = {c['id']: c for c in json.loads((root/'VisaDone/Resources/Maps/destination-map.json').read_text())['countries']}
def clip(ring, bound):
    output = []
    for a,b in zip(ring, ring[1:]+ring[:1]):
        ina, inb = a[0] <= bound, b[0] <= bound
        if ina: output.append(a[:2])
        if ina != inb:
            t = (bound-a[0])/(b[0]-a[0])
            output.append([bound,a[1]+t*(b[1]-a[1])])
    return output
countries = []
for feature in json.loads((folder/'ne_50m_admin_0_countries.geojson').read_text())['features']:
    code = feature['properties']['ADM0_A3']
    if code not in metadata: continue
    geometry = feature['geometry']
    polygons = geometry['coordinates'] if geometry['type']=='MultiPolygon' else [geometry['coordinates']]
    rings = []
    for polygon in polygons:
        ring = polygon[0]
        if code == 'RUS':
            if max(p[0] for p in ring) < 0: continue
            ring = clip(ring, 60)
        if len(ring)<4 or max(p[1] for p in ring)<30: continue
        rings.append([[round(p[0],5),round(p[1],5)] for p in ring])
    meta = metadata[code]
    countries.append(dict(id=code,name=meta['name'],english=meta['english'],rings=rings))
(root/'VisaDone/Resources/Maps/globe-countries.json').write_text(json.dumps(countries,ensure_ascii=False,separators=(',',':')))
print('Geodetic country outlines:', len(countries))
