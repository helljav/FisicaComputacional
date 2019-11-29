module variables
	implicit none
	integer:: npart, npasos, zbins, lattice, acomodar
	double precision:: lx, ly, lz, energia_potencial, dtiempo=0.031, energia_cinetica
	double precision:: corte=2.5, volumenparticula=1.0, epsi=1.0, temperatura=0.80, tempi
	double precision:: veces, deltaz = 0.05
    double precision:: tini, tfin
	double precision, dimension(:), allocatable:: x, y, z
	double precision, dimension(:), allocatable:: velx, vely, velz
	double precision, dimension(:), allocatable:: fx, fy, fz, mp
	double precision, dimension(:,:), allocatable:: densi
	!logical:: acomodar
end

program particulas
use variables
implicit none


call inicio
call colocar
call escribe
call fuerza
call densidad(0)
call integracion
call densidad(2)
call salva


end program particulas


subroutine inicio
use variables
implicit none

    write(*,*) '-------------------------------------------------'
	write(*,*) 'BIENVENIDO AL GENERADOR DE N PARTICULAS EN 3 EJES'
	write(*,*) '-------------------------------------------------'
	write(*,*) 'Dame la cantidad de particulas que deseas'
	read(*,*) npart
	write(*,*) 'Dame la dimension en el eje "x" que deseas'
	read(*,*) lx
	write(*,*) 'Dame la dimension en el eje "y" que deseas'
	read(*,*) ly
	write(*,*) 'Dame la dimension en el eje "z" que deseas'
	read(*,*) lz
	write(*,*) '¿Quieres que las particulas esten acomodadas? responde --> .true. o .false.'
	read(*,*) acomodar
	write(*,*) 'Dame las veces que quieras mover las particulas'
	read(*,*) npasos

    allocate ( x(npart),y(npart),z(npart) )
    allocate ( velx(npart),vely(npart),velz(npart) )
    allocate ( fx(npart),fy(npart),fz(npart))
    allocate ( mp(npart))
    mp=1.0
    open(1,file="posicion.xyz",status="replace",action="write")
end subroutine inicio


subroutine colocar
use variables
implicit none

integer:: i,j,ix,iy,iz,re=1,dxacom,cp, raizpart
double precision:: rndx, rndy, rndz, validar=0  
double precision:: dx,dy,dz, minima,rij


if (acomodar == 0) then							!El usuario quiere las particulas acomodadas
	do i=1,npart
        100 call random_number(rndx)
            call random_number(rndy)
            call random_number(rndz)
            x(i)=rndx*lx
            y(i)=rndy*ly 
            z(i)=rndz*lz 
            do j=1,i-1
             dx=x(i)-x(j)
             dy=y(i)-y(j)
             dz=z(i)-z(j) 
             dx = minima(dx,lx)
             dy = minima(dy,ly)
             dz = minima(dz,lz)
             rij=sqrt(dx**2+dy**2+dz**2)
             if(rij<=volumenparticula) goto 100 
            enddo
    enddo
    call velocidad
else													!El usuario quiere las particulas aleatorias
    open(99,file='configuracion.dat',status='old',action='read')
     read(99,*)npart
     read(99,*)lx,ly,lz
     do i=1,npart
      read(99,*)x(i),y(i),z(i)
     enddo
     read(99,*)
     do i=1,npart
      read(99,*)velx(i),vely(i),velz(i)
     enddo
   close(99)
endif

end subroutine colocar


subroutine escribe
use variables
implicit none
integer:: i

write(1,*)npart
write(1,*)
do i=1,npart
    write(1,*)"c",x(i),y(i),z(i)
enddo
end subroutine escribe



subroutine velocidad
use variables
implicit none

integer:: i
double precision::rndx,rndy,rndz,mx,my,mz !

 do i=1,npart
  call random_number(rndx) 
  call random_number(rndy)
  call random_number(rndz)
  velx(i)=2*rndx-1.0
  vely(i)=2*rndy-1.0
  velz(i)=2*rndz-1.0
 enddo
 mx=sum(mp*velx)
 my=sum(mp*vely)
 mz=sum(mp*velz)
  
 velx=velx-mx/dble(npart)
 vely=vely-my/dble(npart)
 velz=velz-mz/dble(npart)

 energia_cinetica = 0.50*(sum(mp*(velx**2+vely**2+velz**2)))
 tempi= 2.0*energia_cinetica/(dble(3*npart))

 velx = velx*sqrt(temperatura/tempi)
 vely = vely*sqrt(temperatura/tempi)
 velz = velz*sqrt(temperatura/tempi)

 energia_cinetica = 0.50*(sum(mp*(velx**2+vely**2+velz**2)))
 tempi= 2.0*energia_cinetica/(dble(3*npart))

end subroutine velocidad


subroutine fuerza
use variables
implicit none

integer:: i,j
double precision:: dx,dy,dz,dis_ij,dulj,minima

fx  = 0.0
fy  = 0.0
fz  = 0.0
energia_potencial= 0.0

do i=1,npart-1
    do j=i+1,npart
        dx = x(i)-x(j)
        dy = y(i)-y(j)
        dz = z(i)-z(j)
        dx = minima(dx,lx)
        dy = minima(dy,ly)
        dz = minima(dz,lz)
        dis_ij= sqrt(dx**2+dy**2+dz**2)
        if(dis_ij<corte)then
            energia_potencial = energia_potencial + 4.0*epsi*( (volumenparticula/dis_ij)**12 - (volumenparticula/dis_ij)**6 )
            dulj = 48.0*epsi*((volumenparticula/dis_ij)**12 - 0.50*(volumenparticula/dis_ij)**6)/dis_ij
            fx(i)= fx(i) + dulj*dx/dis_ij
            fy(i)= fy(i) + dulj*dy/dis_ij
            fz(i)= fz(i) + dulj*dz/dis_ij
            fx(j)= fx(j) - dulj*dx/dis_ij
            fy(j)= fy(j) - dulj*dy/dis_ij
            fz(j)= fz(j) - dulj*dz/dis_ij
        endif
    enddo
enddo
end subroutine fuerza


double precision function  minima (dd,ll)
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



subroutine integracion
use variables
implicit none

integer:: i,j

do j=1,npasos
    do i=1,npart
        velx(i) = velx(i) + 0.50*fx(i)/mp(i)*dtiempo
        vely(i) = vely(i) + 0.50*fy(i)/mp(i)*dtiempo
        velz(i) = velz(i) + 0.50*fz(i)/mp(i)*dtiempo
        x(i) = x(i) + velx(i)*dtiempo
        y(i) = y(i) + vely(i)*dtiempo
        z(i) = z(i) + velz(i)*dtiempo
        if(x(i)>lx ) x(i)=x(i)-lx
        if(y(i)>ly ) y(i)=y(i)-ly
        if(z(i)>lz ) z(i)=z(i)-lz  
        if(x(i)<0.0) x(i)=x(i)+lx
        if(y(i)<0.0) y(i)=y(i)+ly
        if(z(i)<0.0) z(i)=z(i)+lz
    enddo
    if( mod(j,200)==0 ) call densidad(1)
    if( mod(j,100)==0 ) call escribe
    call fuerza
    do i=1,npart 
        velx(i) = velx(i) + 0.50*fx(i)*dtiempo/mp(i)
        vely(i) = vely(i) + 0.50*fy(i)*dtiempo/mp(i)
        velz(i) = velz(i) + 0.50*fz(i)*dtiempo/mp(i)
    enddo
    energia_cinetica = 0.50*(sum(mp*(velx**2+vely**2+velz**2)))
    tempi= 2.0*energia_cinetica/(dble(3*npart))
     
    velx = velx*sqrt(temperatura/tempi)
    vely = vely*sqrt(temperatura/tempi)
    velz = velz*sqrt(temperatura/tempi)
    !write(*,*)j,(energia_cinetica/npart),(energia_potencial/npart),tempi
enddo

end subroutine integracion




subroutine densidad(flag)
use variables
implicit none
    
integer :: flag,bin,i
    
if(flag==0)then
    
    zbins = int(lz/deltaz)
    allocate(densi(3,0:zbins))
    densi=0.0
    veces=0.0
    
elseif(flag==1)then
    
    veces=veces+1.0
    do i=1,npart
        bin=int(x(i)/deltaz)
        densi(1,bin)=densi(1,bin)+1.0
    
        bin=int(y(i)/deltaz)
        densi(2,bin)=densi(2,bin)+1.0
    
        bin=int(z(i)/deltaz)
        densi(3,bin)=densi(3,bin)+1.0
    enddo
    
else
    
    open(2,file='densidadX.dat',status='replace',action='write')
    open(3,file='densidadY.dat',status='replace',action='write')
    open(4,file='densidadZ.dat',status='replace',action='write')
        do i=0,zbins-1
            densi(1,i) = densi(1,i)/(deltaz*lz*ly*veces)
            densi(2,i) = densi(2,i)/(deltaz*lx*lz*veces)
            densi(3,i) = densi(3,i)/(deltaz*lx*ly*veces)
            write(2,*)dble(i)*deltaz,densi(1,i)
            write(3,*)dble(i)*deltaz,densi(2,i)
            write(4,*)dble(i)*deltaz,densi(3,i)
        enddo
    close(2)
    close(3)
    close(4)
    
endif
end subroutine densidad



subroutine salva
use variables
implicit none

integer :: i

 open(99,file='configuracion.dat',status='replace',action='write')
  write(99,*)npart
  write(99,*)lx,ly,lz
  do i=1,npart
   write(99,*)x(i),y(i),z(i)
  enddo
  write(99,*)
  do i=1,npart
   write(99,*)velx(i),vely(i),velz(i)
  enddo
 close(99)

end subroutine salva