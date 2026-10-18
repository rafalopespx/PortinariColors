import numpy as np, potrace, cv2, cairosvg, sys, json
from fontTools.ttLib import TTFont
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen

INDIGO, ULTRA, COBALT, LBLUE, PGREEN, CITRINE, ORANGE = "#2A1E4A","#24408E","#3F6FB5","#9CC3D9","#B9D8C8","#DCE3AE","#E07A3A"
cfg = dict(border=ORANGE, scale=0.84, ox=48, oy=58, text_y=528, text_size=52, text_color=INDIGO, band=None)
cfg.update(json.loads(sys.argv[1]) if len(sys.argv)>1 else {})
lvl=np.load('levels.npy')

def trace(binary):
    bm=potrace.Bitmap(~binary)
    path=bm.trace(turdsize=12, alphamax=1.1, opticurve=True, opttolerance=0.3)
    d=[]
    for curve in path:
        d.append(f"M{curve.start_point.x:.1f},{curve.start_point.y:.1f}")
        for seg in curve.segments:
            if seg.is_corner:
                d.append(f"L{seg.c.x:.1f},{seg.c.y:.1f}L{seg.end_point.x:.1f},{seg.end_point.y:.1f}")
            else:
                d.append(f"C{seg.c1.x:.1f},{seg.c1.y:.1f} {seg.c2.x:.1f},{seg.c2.y:.1f} {seg.end_point.x:.1f},{seg.end_point.y:.1f}")
        d.append("Z")
    return "".join(d)

sil=(lvl!=255)
layers=[(COBALT,sil),(LBLUE,sil&(lvl>=1)),(PGREEN,sil&(lvl>=2)),(CITRINE,sil&(lvl==3))]
portrait=[f'<path fill="{c}" fill-rule="evenodd" d="{trace(b)}"/>' for c,b in layers]
glasses=f'''<g fill="none" stroke="#A8352E" stroke-width="4.2" stroke-linecap="round">
  <ellipse cx="193" cy="203" rx="35" ry="25"/>
  <ellipse cx="283" cy="203" rx="31" ry="26.5"/>
  <path d="M228,191 Q240,183 252,191"/>
  <path d="M158,195 L150,186"/><path d="M314,196 L344,188"/>
</g>'''

# text to outlined path
font=TTFont('/usr/share/fonts/opentype/inter/InterDisplay-SemiBold.otf')
gs=font.getGlyphSet(); cmap=font.getBestCmap(); upm=font['head'].unitsPerEm
def text_path(text,size,cx,base_y,tracking=0):
    s=size/upm; names=[cmap[ord(ch)] for ch in text]
    widths=[gs[n].width*s for n in names]; total=sum(widths)+tracking*(len(text)-1)
    x=cx-total/2; out=[]
    for n,wd in zip(names,widths):
        pen=SVGPathPen(gs); tp=TransformPen(pen,(s,0,0,-s,x,base_y)); gs[n].draw(tp)
        out.append(pen.getCommands()); x+=wd+tracking
    return "".join(out), total

W,H=518,600
hexpts=[(259,0),(518,150),(518,450),(259,600),(0,450),(0,150)]
def hexpath(inset):
    cx,cy=259,300; pts=[(cx+(x-cx)*(1-inset),cy+(y-cy)*(1-inset)) for x,y in hexpts]
    return "M"+" L".join(f"{x:.2f},{y:.2f}" for x,y in pts)+" Z"
bw=cfg.get('border_w',0.045)
tpath,tw=text_path("PortinariColors",cfg['text_size'],259,cfg['text_y'],tracking=-0.5)
band = ''
if cfg['band']:
    by=cfg["band_y"]
    band=(f'<path fill="{cfg["band"]}" d="M0,{by} H518 V600 H0 Z"/>'
          f'<path stroke="{cfg.get("rule", "none")}" stroke-width="3" d="M0,{by} H518"/>')
GUERRA=["#2A1E4A","#24408E","#3F6FB5","#9CC3D9","#B9D8C8","#DCE3AE","#E07A3A","#D9748A","#A8352E"]
sw,sh,sy=cfg.get("strip_w",17),cfg.get("strip_h",9),cfg.get("strip_y",515)
x0=259-sw*len(GUERRA)/2
strip="".join(f'<rect x="{x0+i*sw:.1f}" y="{sy}" width="{sw}" height="{sh}" fill="{c}"/>' for i,c in enumerate(GUERRA))
strip=f'<g stroke="#DCE3AE" stroke-width="0">{strip}</g><rect x="{x0:.1f}" y="{sy}" width="{sw*len(GUERRA)}" height="{sh}" fill="none" stroke="#DCE3AE" stroke-width="1.2"/>'
svg=f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}">
<defs><clipPath id="hex"><path d="{hexpath(bw)}"/></clipPath></defs>
<path d="{hexpath(0)}" fill="{cfg['border']}"/>
<g clip-path="url(#hex)">
  <path d="{hexpath(bw)}" fill="{INDIGO}"/>
  <g transform="translate({cfg['ox']},{cfg['oy']}) scale({cfg['scale']})">
    {''.join(portrait)}
    {glasses}
  </g>
  {band}
  <path fill="{cfg['text_color']}" d="{tpath}"/>
  {strip}
</g>
</svg>'''
name=cfg.get('out','logo')
open(f'{name}.svg','w').write(svg)
cairosvg.svg2png(bytestring=svg.encode(),write_to=f'{name}.png',output_width=518*2,output_height=600*2)
print(name, 'text width', round(tw), 'svg bytes', len(svg))
