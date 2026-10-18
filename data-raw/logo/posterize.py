import cv2, numpy as np
img=cv2.imread('portinari_1962.png',cv2.IMREAD_GRAYSCALE); m=cv2.imread('mask.png',0)>0
h,w=img.shape
g=cv2.createCLAHE(clipLimit=2.5,tileGridSize=(6,6)).apply(img)
gh=cv2.bilateralFilter(g,9,45,7)
gb=cv2.medianBlur(cv2.bilateralFilter(g,15,60,15),15)
yy=np.arange(h)[:,None]*np.ones((1,w))
# head region: above a line under the chin/collar
head=(yy<335)&m
body=(yy>=335)&m
face=np.zeros_like(m); face[60:340,140:380]=True; face&=m
qh=np.percentile(gh[face],[26,55,82])
lvl=np.full((h,w),255,np.uint8)
lh=np.digitize(gh,qh).astype(np.uint8)
qb=np.percentile(gb[body],[4,35])
lb=np.digitize(gb,qb).astype(np.uint8)     # 0 deep shadow,1 shadow,2 light
lb=np.choose(lb,[0,2,3]).astype(np.uint8)
lvl[head]=lh[head]; lvl[body]=lb[body]
lvl=cv2.medianBlur(lvl,5)
for _ in range(2): lvl=cv2.medianBlur(lvl,7)
lvl[~m]=255
np.save('levels.npy',lvl)
pal={0:(0x3F,0x6F,0xB5),1:(0x9C,0xC3,0xD9),2:(0xB9,0xD8,0xC8),3:(0xDC,0xE3,0xAE),255:(0x2A,0x1E,0x4A)}
out=np.zeros(lvl.shape+(3,),np.uint8)
for k,c in pal.items(): out[lvl==k]=c[::-1]
# glasses guide overlay (BGR cobalt)
cob=(0xB5,0x6F,0x3F)
cv2.imwrite('poster_preview.png',out); print(qh,qb)
