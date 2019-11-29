!******************************************
!**********MODULO VARIABLES****************
!******************************************
module variables
implicit none
 integer:: nat,npasos,lattice,part1,part2
 integer:: zbins
 double precision::lx,ly,lz
 double precision::sigma=1.0,eps=1.0,rcorte,upot,ukin
 double precision::temp,tempi,dt
 double precision::veces,deltaz=0.05
 double precision::tini,tfin
 double precision,dimension(:),allocatable::rx,ry,rz
 double precision,dimension(:),allocatable::vx,vy,vz
 double precision,dimension(:),allocatable::fx,fy,fz
 double precision,dimension(:),allocatable::masa
 double precision,dimension(:,:),allocatable::rho
end
!******************************************
!**********MODULO VARIABLES****************
!******************************************
program simulacion 
use variables
implicit none

!call cpu_time(tini)
call lee
call posicion
call pinta
call fuerza
call densidad(0)
call integracion
call densidad(2)
call salva


end program simulacion
!******************************************
!**********SUBROUTINE-LEE****************
!******************************************
subroutine lee !nombre de la subroutina
use variables !!variablespara usar en el modulo variables
implicit none

open(1,file="run.dat",status="old",action="read")
 read(1,*)lattice
 read(1,*)nat
 read(1,*)npasos
 read(1,*)lx,ly,lz
 read(1,*)dt
 read(1,*)rcorte
 read(1,*)temp
close(1)
allocate ( rx(nat),ry(nat),rz(nat) )
allocate ( vx(nat),vy(nat),vz(nat) )
allocate ( fx(nat),fy(nat),fz(nat))
allocate ( masa(nat))
masa=1.0
open(1,file="posicion.xyz",status="replace",action="write")
end subroutine lee ! terminacion de sbroutina lee

!******************************************
!**********SUBROUTINE-POSICION*************
!******************************************
subroutine posicion !nombre de la subroutina
use variables   !variablespara usar en el modulo variables
implicit none

integer::i,j
double precision :: rndx,rndy,rndz
double precision :: dx,dy,dz,rij,minima


if(lattice==0)then
  do i=1,nat
100 call random_number(rndx)
    call random_number(rndy)
    call random_number(rndz)
    rx(i)=rndx*lx 
    ry(i)=rndy*ly 
    rz(i)=rndz*lz 
    do j=1,i-1
     dx=rx(i)-rx(j)
     dy=ry(i)-ry(j)
     dz=rz(i)-rz(j) 
     dx = minima(dx,lx)
     dy = minima(dy,ly)
     dz = minima(dz,lz)
     rij=sqrt(dx**2+dy**2+dz**2)
     if(rij<=sigma) goto 100 
    enddo
  enddo
  call velocidad

else

 open(99,file='configuracion.dat',status='old',action='read')
  read(99,*)nat
  read(99,*)lx,ly,lz
  do i=1,nat
   read(99,*)rx(i),ry(i),rz(i)
  enddo
  read(99,*)
  do i=1,nat
   read(99,*)vx(i),vy(i),vz(i)
  enddo
 close(99)

endif
end subroutine posicion
!******************************************
!**********SUBROUTINE-PINTA****************
!******************************************
subroutine pinta
use variables
implicit none 
integer::i

 write(1,*)nat
 write(1,*)
 do i=1,nat
  write(1,*)"c",rx(i),ry(i),rz(i)
 enddo

end subroutine pinta
!******************************************
!**********SUBROUTINE-VELOCIDAD************
!******************************************
subroutine velocidad !nombre de la subroutina
use variables  
implicit none

integer:: i
double precision::rndx,rndy,rndz,mx,my,mz !

 do i=1,nat
  call random_number(rndx) 
  call random_number(rndy)
  call random_number(rndz)
  vx(i)=2*rndx-1.0
  vy(i)=2*rndy-1.0
  vz(i)=2*rndz-1.0
 enddo
 mx=sum(masa*vx)
 my=sum(masa*vy)
 mz=sum(masa*vz)
  
 vx=vx-mx/dble(nat)
 vy=vy-my/dble(nat)
 vz=vz-mz/dble(nat)

 ukin = 0.50*(sum(masa*(vx**2+vy**2+vz**2)))
 tempi= 2.0*ukin/(dble(3*nat))

 vx = vx*sqrt(temp/tempi)
 vy = vy*sqrt(temp/tempi)
 vz = vz*sqrt(temp/tempi)

 ukin = 0.50*(sum(masa*(vx**2+vy**2+vz**2)))
 tempi= 2.0*ukin/(dble(3*nat))

end subroutine velocidad
!******************************************
!**********SUBROUTINE-FUERZA***************
!******************************************
subroutine fuerza 
use variables    
implicit none   

integer::i,j
double precision::rij,dx,dy,dz,dulj,minima

 fx  = 0.0
 fy  = 0.0
 fz  = 0.0
 upot= 0.0
 
 do i=1,nat-1
  do j=i+1,nat
   dx = rx(i)-rx(j)
   dy = ry(i)-ry(j)
   dz = rz(i)-rz(j)
   dx = minima(dx,lx)
   dy = minima(dy,ly)
   dz = minima(dz,lz)
   rij= sqrt(dx**2+dy**2+dz**2)
   if(rij<=rcorte)then
    upot = upot + 4.0*eps*( (sigma/rij)**12 - (sigma/rij)**6 )
    dulj = 48.0*eps*((sigma/rij)**12 - 0.50*(sigma/rij)**6)/rij
    fx(i)= fx(i) + dulj*dx/rij
    fy(i)= fy(i) + dulj*dy/rij
    fz(i)= fz(i) + dulj*dz/rij
    fx(j)= fx(j) - dulj*dx/rij
    fy(j)= fy(j) - dulj*dy/rij
    fz(j)= fz(j) - dulj*dz/rij
   endif
   enddo
enddo
end subroutine fuerza 
!******************************************
!**********FUNCION*************************
!******************************************
double precision function  minima (dd,ll) !nombre de la funcion
implicit none 

double precision :: dd,ll,l2

 l2=ll*0.50
 if(dd>l2)then
  dd = dd - ll
 elseif(dd<-l2)then
  dd = dd + ll
 endif
 minima=dd
end
!******************************************
!**********SUBROUTINE-INTEGRACION**********
!******************************************
subroutine integracion
use variables
implicit none

integer ::i,paso

  do paso=1,npasos
   do i=1,nat
    vx(i) = vx(i) + 0.50*fx(i)/masa(i)*dt
    vy(i) = vy(i) + 0.50*fy(i)/masa(i)*dt
    vz(i) = vz(i) + 0.50*fz(i)/masa(i)*dt
    rx(i) = rx(i) + vx(i)*dt
    ry(i) = ry(i) + vy(i)*dt
    rz(i) = rz(i) + vz(i)*dt
    if(rx(i)>lx )rx(i)=rx(i)-lx
    if(ry(i)>ly )ry(i)=ry(i)-ly
    if(rz(i)>lz )rz(i)=rz(i)-lz  
    if(rx(i)<0.0)rx(i)=rx(i)+lx
    if(ry(i)<0.0)ry(i)=ry(i)+ly
    if(rz(i)<0.0)rz(i)=rz(i)+lz
   enddo
   if( mod(paso,100)==0 ) call densidad(1)
   if( mod(paso,100)==0 ) call pinta
   call fuerza
   do i=1,nat 
    vx(i) = vx(i) + 0.50*fx(i)*dt/masa(i)
    vy(i) = vy(i) + 0.50*fy(i)*dt/masa(i)
    vz(i) = vz(i) + 0.50*fz(i)*dt/masa(i)
   enddo
   ukin = 0.50*(sum(masa*(vx**2+vy**2+vz**2)))
   tempi= 2.0*ukin/(dble(3*nat))
    
   vx = vx*sqrt(temp/tempi)
   vy = vy*sqrt(temp/tempi)
   vz = vz*sqrt(temp/tempi)
   !write(*,'(i6,3f12.6)')paso,(ukin/nat),(upot/nat),tempi
  enddo
end

subroutine densidad(flag)
use variables
implicit none

integer :: flag,bin,i

 if(flag==0)then

  zbins = int(lz/deltaz)
  allocate(rho(3,0:zbins))
  rho=0.0
  veces=0.0
 elseif(flag==1)then

  veces=veces+1.0
  do i=1,nat
   bin=int(rx(i)/deltaz)
   rho(1,bin)=rho(1,bin)+1.0

   bin=int(ry(i)/deltaz)
   rho(2,bin)=rho(2,bin)+1.0

   bin=int(rz(i)/deltaz)
   rho(3,bin)=rho(3,bin)+1.0
  enddo

 else

  open(2,file='densidadX.dat',status='replace',action='write')
  open(3,file='densidadY.dat',status='replace',action='write')
  open(4,file='densidadZ.dat',status='replace',action='write')
   do i=0,zbins-1
    rho(1,i) = rho(1,i)/(deltaz*lz*ly*veces)
    rho(2,i) = rho(2,i)/(deltaz*lx*lz*veces)
    rho(3,i) = rho(3,i)/(deltaz*lx*ly*veces)
    write(2,*)dble(i)*deltaz,rho(1,i)
    write(3,*)dble(i)*deltaz,rho(2,i)
    write(4,*)dble(i)*deltaz,rho(3,i)
   enddo
  close(2)
  close(3)
  close(4)

 endif
end

subroutine salva
use variables
implicit none

integer :: i

 open(99,file='configuracion.dat',status='replace',action='write')
  write(99,*)nat
  write(99,*)lx,ly,lz
  do i=1,nat
   write(99,*)rx(i),ry(i),rz(i)
  enddo
  write(99,*)
  do i=1,nat
   write(99,*)vx(i),vy(i),vz(i)
  enddo
 close(99)
end
