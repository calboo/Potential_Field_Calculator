nx=200.000
ny=200.000
nz=200.000
ax=30
az=30

; Uncomment for use with .dat files
;
bx0=dblarr(nx+5,ny+4,nz+4)
by0=dblarr(nx+4,ny+5,nz+4)
bz0=dblarr(nx+4,ny+4,nz+5)
x=dblarr(nx+4)
y=dblarr(ny+4)
z=dblarr(nz+4)
OPENR, 1, 'bx.dat',  /F77_UNFORMATTED
READU, 1,bx0  
CLOSE, 1  
OPENR, 1, 'by.dat',  /F77_UNFORMATTED
READU, 1,by0
CLOSE, 1  
OPENR, 1, 'bz.dat',  /F77_UNFORMATTED
READU, 1,bz0
CLOSE, 1 
for i=0,nx+3 do x(i)=i
for i=0,ny+3 do y(i)=i
for i=0,nz+3 do z(i)=i

; Clear window

WINDOW, 0, XSIZE=600, YSIZE=500, TITLE='BooBox'
ERASE

; Set up the 3D scaling system:
SCALE3, xr=[min(x),max(x)], yr=[min(y),max(y)], zr=[min(z),max(z)],ax=ax,az=az


; Set the 3D coordinate space with axes.
SURFACE, [[0,200],[0,200]], /NODATA, /SAVE,/noerase,/t3d,$
XSTYLE=1,YSTYLE=1,/noclip,XRANGE=[0,nx],YRANGE=[0,ny],ZRANGE=[0,nz],$
CHARSIZE=4,POS=[0.1,0.1,nx,ny]

seed=12345678
sx = FIX(nx* RANDOMU(seed,500))
sy = FIX(ny* RANDOMU(seed,500))
sz = FIX(nz* RANDOMU(seed,500))
FLOW3,  bx0, by0, bz0,ARROWSIZE=0.01,LEN=2.8,NSTEPS=15480,sx=sx,sy=sy,sz=sz
FLOW3, -bx0,-by0,-bz0,ARROWSIZE=0.01,LEN=2.8,NSTEPS=15480,sx=sx,sy=sy,sz=sz

; Uncomment to produce a png file
;
;write_png, 'BooBox.png',tvrd(/true)  
;
;;;;;;;;;;;;;;;;;;;;;

end
