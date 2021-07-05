! BooTsik.f90
! A FORTRAN 90 code designed to calculate a potential magnetic field 
! by extrapolating the normal field given at the base of the domain.
! 
! Author: Callum Boocock
! Institution: QMUL
! Email: c.boocock@qmul.ac.uk
! Date : 3rd November 2018
!
! Copyright (C) 2018      Callum Boocok <c.boocock@qmul.ac.uk>
!
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details:
! <http://www.gnu.org/licenses/>.

MODULE constants
IMPLICIT NONE

! Dimension of domain in which to calculate 3D potential field.
INTEGER, PARAMETER :: nx = 100, ny = 100, nz = 100
!
! Set parameter for grid spacing.
DOUBLE PRECISION, PARAMETER :: d=0.01
!
! Set size of input region
! Uncomment 1st line for standard, 2nd line for extended
!DOUBLE PRECISION, PARAMETER :: nx0=-1, nx1=nx+2, ny0=-1, ny1=ny+2
!DOUBLE PRECISION, PARAMETER :: nx0=-nx-3, nx1=2*nx+4, ny0=-ny-3, ny1=2*ny+4
!
! Parameters for defining normal field Bz0 at base of domain z=0.
DOUBLE PRECISION, PARAMETER :: x01=0.0, y01=0.0, x02=0.0, y02=0.5, sigma=1.0, amp=1.0
!
! Value for pi
DOUBLE PRECISION, PARAMETER :: pi = 3.14159265358979323
!
! Arrrays and indices
DOUBLE PRECISION, DIMENSION(-3:nx+4,-3:ny+4,-3:nz+4) :: phi
DOUBLE PRECISION, DIMENSION(-2:nx+2,-1:ny+2,-1:nz+2) :: bx
DOUBLE PRECISION, DIMENSION(-1:nx+2,-2:ny+2,-1:nz+2) :: by
DOUBLE PRECISION, DIMENSION(-1:nx+2,-1:ny+2,-2:nz+2) :: bz 
REAL, DIMENSION(nx0:nx1,ny0:ny1) :: bz0
INTEGER :: i,j,k,i1,j1

END MODULE constants

PROGRAM potential
USE constants 
IMPLICIT NONE
phi=0.0

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Below are three options for the Bz0 field that needs to be specified at the lower boundary.
! The options are a)Dipole loop, b)Gaussian pole, c)Input from data file. For options (a) and 
! (b) the parameters can be set at the top of this code. Uncomment whichever Bz0 profile you
! want to use or alternatively specify your own Bz0 field.

!Dipole loop
!do j=ny0,ny1
!do i=nx0,nx1
!bz0(i,j)= amp*((1.0/((((real(i)-(nx/2.0))/(nx/2.0))-x01)**2+&
!                     (((real(j)-(ny/2.0))/(ny/2.0))-y01)**2+1.0**2)**(3.0/2.0))&
!              -(1.0/((((real(i)-(nx/2.0))/(nx/2.0))-x02)**2+&
!                     (((real(j)-(ny/2.0))/(ny/2.0))-y02)**2+1.0**2)**(3.0/2.0)))
!end do
!end do

!Gaussian pole
!do j=ny0,ny1
!do i=nx0,nx1
!bz0(i,j)=amp*exp(-((((real(i)-(nx/2.0))/(nx/2.0))-x01)**2.0+ &
!                   (((real(j)-(ny/2.0))/(ny/2.0))-y01)**2.0+1.0**2.0)/(2.0*sigma**2))
!end do
!end do

!Read in Bz0 from unformatted data file
!Make sure that the size of the imported array is equal to the size of bz0 as defined in constants. 
!OPEN(unit=12, FORM = 'UNFORMATTED', STATUS='OLD', ACTION='READ', FILE = 'bz0.dat')
!READ(12) bz0
!CLOSE(12)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! This loop calculates the magnetic potential using a Modified Green's Function method
! 
do k=-3,nz+4
do j=-3,ny+4
do i=-3,nx+4
do i1=nx0,nx1
do j1=ny0,ny1
phi(i,j,k)=phi(i,j,k)+bz0(i1,j1)*d/(2.0*pi*sqrt( (i-i1)**2+(j-j1)**2+ (k+4+1/sqrt(2.0*pi))**2 ) )
end do
end do
end do
end do
print*,'Calculating Phi at HIGHT =',k+4,' out of ',nz+8
end do

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! This section calculates the magnetic field components by numerical differentiation
! of the magnetic potential.
! 
bx=0.0
by=0.0
bz=0.0
do k=-1,nz+2
do j=-1,ny+2
do i=-2,nx+2
bx(i,j,k)=-(phi(i-1,j,k)-27.0*phi(i,j,k)+27.0*phi(i+1,j,k)-phi(i+2,j,k))/(24.0*d)
end do
end do
print*,'Now calculating Bx at HEIGHT =',k+2,' out of ',nz+4
end do
do k=-1,nz+2
do j=-2,ny+2
do i=-1,nx+2
by(i,j,k)=-(phi(i,j-1,k)-27.0*phi(i,j,k)+27.0*phi(i,j+1,k)-phi(i,j+2,k))/(24.0*d)
end do
end do
print*,'Now calculating By at HEIGHT =',k+2,' out of ',nz+4
end do
do k=-2,nz+2
do j=-1,ny+2
do i=-1,nx+2
bz(i,j,k)=-(phi(i,j,k-1)-27.0*phi(i,j,k)+27.0*phi(i,j,k+1)-phi(i,j,k+2))/(24.0*d)
end do
end do
print*,'Now calculating Bz at HEIGHT =',k+2,' out of ',nz+4
end do

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! This section writes the magnetic field components to three files
! bx.dat, by.dat and bz.dat
! 
OPEN(unit=66, FORM = 'UNFORMATTED', FILE = 'bx.dat')
WRITE(66) bx
CLOSE(66)
OPEN(unit=66, FORM = 'UNFORMATTED', FILE = 'by.dat')
WRITE(66) by
CLOSE(66)
OPEN(unit=66, FORM = 'UNFORMATTED', FILE = 'bz.dat')
WRITE(66) bz
CLOSE(66)
END PROGRAM  
