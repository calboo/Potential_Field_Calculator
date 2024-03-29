; Boobox.pro
; An IDL script for visualising magnetic fields either from  unstructured data files or from data snapshots from Lare3d. 
; The fields are visualised as field lines in a 3D box with the base of the box contoured according to the strength and dirction of Bz at
; that boundary.
; 
; Author: Callum Boocock
; Institution: QMUL
; Email: c.boocock@qmul.ac.uk
; Date : 3rd November 2018
;
; Copyright (C) 2018      Callum Boocok <c.boocock@qmul.ac.uk>
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details:
; <http://www.gnu.org/licenses/>.


;
; Uncomment the following line only if using with data snapshot ds from Lare3d
; pro boobox, ds

; Domain dimensions
nx=100.000
ny=100.000
nz=100.000
; Extents of domain, for tick labels
xmin=-1.0
xmax= 1.0
ymin=-1.0
ymax= 1.0
zmin= 0.0
zmax= 2.0
; Format of tick labels
tikform = '(f5.1)'
; Viewing angles for visualisation
ax=30
az=30
; Arrangement of field lines
; 1 -               starting points distributed uniformly at the photosphere
; Any other value - starting points randomly distributed throughout domain 
GRID = 0

; Uncomment this block for use with .dat files
;
;bx0=dblarr(nx+5,ny+4,nz+4)
;by0=dblarr(nx+4,ny+5,nz+4)
;bz0=dblarr(nx+4,ny+4,nz+5)
;x=dblarr(nx+4)
;y=dblarr(ny+4)
;z=dblarr(nz+4)
;OPENR, 1, 'bx.dat',  /F77_UNFORMATTED
;READU, 1,bx0  
;CLOSE, 1  
;OPENR, 1, 'by.dat',  /F77_UNFORMATTED
;READU, 1,by0
;CLOSE, 1  
;OPENR, 1, 'bz.dat',  /F77_UNFORMATTED
;READU, 1,bz0
;CLOSE, 1 
;for i=0,nx+3 do x(i)=i
;for i=0,ny+3 do y(i)=i
;for i=0,nz+3 do z(i)=i
;bx0=bx0(2:nx+3,2:ny+2,2:nz+2)
;by0=by0(2:nx+2,2:ny+3,2:nz+2)
;bz0=bz0(2:nx+2,2:ny+2,2:nz+3)

; Uncomment this block for use with data snapshot ds from Lare3d
;
;bx0 = ds.bx
;by0 = ds.by
;bz0 = ds.bz
;x = ds.x
;y = ds.y
;z = ds.z

; Calculate and format the tick labels
x2=(xmin+xmax)/2.0
x1=(xmin+x2)/2.0
x3=(x2+xmax)/2.0
y2=(ymin+ymax)/2.0
y1=(ymin+y2)/2.0
y3=(y2+ymax)/2.0
z2=(zmin+zmax)/2.0
z1=(zmin+z2)/2.0
z3=(z2+zmax)/2.0
xmin = string(xmin,FORMAT=tikform)
x2 = string(x2,FORMAT=tikform)
x1 = string(x1,FORMAT=tikform)
x3 = string(x3,FORMAT=tikform)
xmax = string(xmax,FORMAT=tikform)
ymin = string(ymin,FORMAT=tikform)
y2 = string(y2,FORMAT=tikform)
y1 = string(y1,FORMAT=tikform)
y3 = string(y3,FORMAT=tikform)
ymax = string(ymax,FORMAT=tikform)
zmin = string(zmin,FORMAT=tikform)
z2 = string(z2,FORMAT=tikform)
z1 = string(z1,FORMAT=tikform)
z3 = string(z3,FORMAT=tikform)
zmax = string(zmax,FORMAT=tikform)
xt=[strtrim(xmin,2),strtrim(x1,2),strtrim(x2,2),strtrim(x3,2),strtrim(xmax,2)]
yt=[strtrim(ymin,2),strtrim(y1,2),strtrim(y2,2),strtrim(y3,2),strtrim(ymax,2)]
zt=[strtrim(zmin,2),strtrim(z1,2),strtrim(z2,2),strtrim(z3,2),strtrim(zmax,2)]
; Set colours
TVLCT, 255, 255, 255, 254 ; White color
TVLCT, 0, 0, 0, 253       ; Black color
TVLCT, 88, 88, 88, 252    ; Line color
!P.Color = 253
!P.Background = 254
; Clear window
WINDOW, 1, XSIZE=600, YSIZE=500, TITLE='Boobox'
ERASE
; Set up the 3D scaling system:
SCALE3, xr=[0,nx], yr=[0,ny], zr=[0,nz],ax=ax,az=az
; Contour the base:
CONTOUR,bz0(*,*,0),/fill,nlevels=25,/t3d,/noerase,zvalue=0.0,/noclip,$
XSTYLE=1,YSTYLE=1,XRANGE=[0,nx],YRANGE=[0,ny],CHARSIZE=4,$
XTITLE='X',YTITLE='Y',POS=[0.1,0.1,nx,ny],$
XTICKS=4,XTICKNAME=xt,$
YTICKS=4,YTICKNAME=yt,$
ZTICKS=4,ZTICKNAME=zt
; Set the 3D coordinate space with axes.
 SURFACE, [[0,nx],[0,ny]], /NODATA,/SAVE,/noerase,/t3d,$
XSTYLE=1,YSTYLE=1,/noclip,XRANGE=[0,nx],YRANGE=[0,ny],ZRANGE=[0,nz],$
CHARSIZE=4,POS=[0.1,0.1,nx,ny],$
XTICKS=4,XTICKNAME=xt,$
YTICKS=4,YTICKNAME=yt,$
ZTICKS=4,ZTICKNAME=zt
; Plot the vector field
!P.Color = 252
IF (GRID eq 1) THEN BEGIN
k=0
n=0
sx=FLTARR(1000)
sy=FLTARR(1000)
sz=FLTARR(1000)
for j=0,ny-1,(ny/20.0) do begin
   for i=0,nx-1,(nx/20.0) do begin
      sx(n)=i
      sy(n)=j
      sz(n)=k
      n=n+1
   endfor
endfor
ENDIF ELSE BEGIN
seed=12345678
sx = FIX(nx* RANDOMU(seed,250))
sy = FIX(ny* RANDOMU(seed,250))
sz = FIX(nz* RANDOMU(seed,250))
ENDELSE
SCALE3, zr=[0,nz],ax=ax,az=az
FLOW3,  bx0, by0, bz0,ARROWSIZE=0.01,LEN=2.0,NSTEPS=9999,sx=sx,sy=sy,sz=sz
FLOW3, -bx0,-by0,-bz0,ARROWSIZE=0.01,LEN=2.0,NSTEPS=9999,sx=sx,sy=sy,sz=sz
!P.Color = 253

; Uncomment to produce a png file
;write_png, 'Fields.png',tvrd(/true)  

end
