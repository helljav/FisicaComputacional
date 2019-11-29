module var 
	!LX,LY Y LZ ES EL TAMA�O DE �A CAJA
	!NPART ES EL NUMERO DE PARTICULAS A CREAR
	!X Y Y Z SON ARREGLOS QUE SE ALMACENARA LAS POSICIONES DE LAS PARTICULAS
	!SIGMA ES EL VOLUMEN EN UNIDAD DE LAS PARTICULAS												 
    implicit none
	integer:: npart,maxbin = 99, npasos,zbins
	
	double precision, dimension(:), allocatable::x,y,z
	double precision, dimension(:), allocatable::vx,vy,vz
	double precision, dimension(:), allocatable::fx,fy,fz
	double precision, dimension(:), allocatable::masa
	double precision, dimension(:,:), allocatable::rho
	double precision::veces,deltaz = 0.05
	double precision::upot,ukin,utot,temp = 0.80, tempi
	integer, dimension(:), allocatable :: histox,histoy,histoz
	double precision:: sigma = 1.0, eps = 1.0, dtiempo = 0.031,rcorte = 2.5
	double precision:: ddx,ddy,ddz,lx, ly, lz
	logical::bandera = .true.
	integer:: uc


end


program particulas
	use var
    implicit none
	call lee
	if(bandera .EQV. .true.) then
		call posi
	else
		call posiOrdenada
	end if
	call escribe
	call fuerzas
	call densidad(0)
	call integrar
	call densidad(2)
	call velocidades
	! call histo	
	!call escribe
	
		
end program particulas


!*********************************************************************************************************
subroutine posiOrdenada
	use var
	implicit none
	integer::conta,iz,iy,ix,deltax,ppl
	conta = 0
	ppl = ((dble(npart))**(1.0/3,0)) + 1
	deltax = lx/ppl
	do iz = 0, ppl-1
		do iy = 0, ppl-1
			do ix = 0, ppl-1
				conta = conta + 1
				x(conta) = ix*deltax
				y(conta) = iy*deltax
				z(conta) = iz*deltaX
				if(conta > npart) then
					exit
				end if
				
			end do
			if(conta > npart) then
				exit
			end if
			
		end do
		if(conta > npart) then
			exit
		end if

	end do
	

end


!*******************************************************************************************************************
subroutine integrar
	use var
	implicit none
	integer:: paso,i
	do paso = 1, npasos
		do i = 1, npart
			vx(i) = vx(i) + 0.5*fx(i)/masa(i)*dtiempo
			vy(i) = vy(i) + 0.5*fy(i)/masa(i)*dtiempo
			vz(i) = vz(i) + 0.5*fz(i)/masa(i)*dtiempo
			
			x(i) = x(i) + vx(i)*dtiempo
			y(i) = y(i) + vy(i)*dtiempo
			z(i) = z(i) + vz(i)*dtiempo

			if(x(i)>lx ) x(i)=x(i)-lx
			if(y(i)>ly ) y(i)=y(i)-ly
			if(z(i)>lz ) z(i)=z(i)-lz  
			if(x(i)<0.0) x(i)=x(i)+lx
			if(y(i)<0.0) y(i)=y(i)+ly
			if(z(i)<0.0) z(i)=z(i)+lz
		end do

			
		if((mod(paso,100))==0) then
			call densidad(1)
			call escribe
		end if
		call fuerzas
		do i = 1, npart
			vx(i) = vx(i) + 0.50*fx(i)*dtiempo/masa(i)
			vy(i) = vy(i) + 0.50*fy(i)*dtiempo/masa(i)
			vz(i) = vz(i) + 0.50*fz(i)*dtiempo/masa(i)
		end do
		ukin = 0.50*(sum(masa*(vx**2+vy**2+vz**2)))
   		tempi= 2.0*ukin/(dble(3*npart))
		vx = vx*sqrt(temp/tempi)
		vy = vy*sqrt(temp/tempi)
		vz = vz*sqrt(temp/tempi)
		! write(*,*)paso,(ukin/npart),(upot/npart),tempi
	end do
end



!**************************************************************************************************************
!						DENSIDAD
subroutine densidad(flag)
	use var
	implicit none
	integer:: flag,bin,i
	if(flag == 0) then
		write(*,* ) "para escirbir iniciar"
		zbins = int(lz/deltaz)
		allocate(rho(3,0:zbins))
		rho=0.0
		veces=0.0
	elseif(flag == 1) then
		veces = veces + 1.0
		do i = 1, npart
			bin=int(x(i)/deltaz)
			rho(1,bin)=rho(1,bin)+1.0

			bin=int(y(i)/deltaz)
			rho(2,bin)=rho(2,bin)+1.0

			bin=int(z(i)/deltaz)
			rho(3,bin)=rho(3,bin)+1.0			
		end do
	else
		write(*,*)"ingrese perros"
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
	end if
end

!******************************************************************************************************************
!					SE CCALCULAS LAS FUERZAS CON EL CHORISOTE QUE NOS DIO EL PROFE


subroutine fuerzas
	use var
	implicit none
	integer:: i,j
	double precision:: rij,ddistx,ddisty,ddistz
	double precision:: minima
	double precision:: dulj
	fx =0.0
	fy =0.0
	fz =0.0
	upot = 0.0

	do i = 1, npart-1
		do j = i+1, npart
			ddistx = x(i) - x(j)
			ddisty = y(i) - y(j)
			ddistz = z(i) - z(j)

			ddistx = minima(ddistx,lx)
			ddisty = minima(ddisty,ly)
			ddistz = minima(ddistz,lz)
			
			rij= sqrt(ddistx**2+ddisty**2+ddistz**2)
			if(rij<rcorte) then
				upot = upot + 4.0*eps*( (sigma/rij)**12 - (sigma/rij)**6 )
				dulj = 48.0*eps*((sigma/rij)**12 - 0.50*(sigma/rij)**6)/rij
				fx(i)= fx(i) + dulj*ddistx/rij
				fy(i)= fy(i) + dulj*ddisty/rij
				fz(i)= fz(i) + dulj*ddistz/rij
				fx(j)= fx(j) - dulj*ddistx/rij
				fy(j)= fy(j) - dulj*ddisty/rij
				fz(j)= fz(j) - dulj*ddistz/rij
				
			end if
			call lennardJones(rij)			
		end do		
	end do
end

subroutine lennardJones(rij)
	use var 
	implicit none
	integer:: nptos, e
	double precision:: rini = 5.0, dr= 0.01, rij, u

	!GRAFICA PARA ENERGIA POTENCIAL
	nptos = int(rini/dr)
	rij = rini
	do e=1, nptos
		u = 48.0*eps*(sigma/rij)**12*((sigma/rij)**6-0.50)/rij
		if(u > 1.0) then 
			exit
		endif
	write(98,*) rij, u
	rij = rij - dr
	enddo
end subroutine lennardJones


!************************************************************************************************************
!				FUNCION MINIMA
double precision function minima(dd,ll)
	implicit none
	double precision:: dd,ll,l2
	l2 = ll * 0.50
	if(dd>l2) then
		dd = dd - ll
	else if(dd<-l2) then
		dd = dd + ll
	end if
	minima = dd
end


!*****************************************************************************************************************
!					SE CREA LAS PARTICULAS Y SE VERIFICA QUE NO SE CHOQUEN 

subroutine posi
	use var
	implicit none
	integer:: i,j
	double precision:: rndx, rndy, rndz
	double precision:: dx,dy,dz, rij,minima
	do i=1, npart
	100	call random_number(rndx)
		call random_number(rndy)
		call random_number(rndz)
		x(i) = rndx * lx
        y(i) = rndy * ly
        z(i) = rndz * lz
		!EN ESTE DO, VERIFICAMOS SI LAS PARTICULAS CHOCAN, SI ES ASI, SE VUELVE A GENERAR UNAS NUEVAS PARTICULAS Y SE VULEVE A CHECAR HASTA QUE YA NO CHOQUEN
		do j=1,i-1
			dx=x(i)-x(j)
			dy=y(i)-y(j)
			dz=z(i)-z(j) 
			dx = minima(dx,lx)
			dy = minima(dy,ly)
			dz = minima(dz,lz)
			rij=sqrt(dx**2+dy**2+dz**2)
			if(rij<=sigma)then
			 	goto 100 
			end if
		enddo
	end do
	call velocidades	   

end

!***********************************************************************************************************
!									SE CREAN LAS VELOCIDADES ALEATORIAS PARA CADA COORDENADA DE LAS PARTICULAS
subroutine velocidades
	use var
	implicit none
	integer:: i
	double precision:: rndx,rndy,rndz,mx,my,mz
	do i=1, npart
		call random_number(rndx)
		call random_number(rndy)
		call random_number(rndz)
		vx(i) = 2*rndx - 1.0
        vy(i) = 2*rndy - 1.0 
		vz(i) = 2*rndz - 1.0
	end do
	mx = sum(masa*vx)
	my = sum(masa*vy)
	mz = sum(masa*vz)

	vx = vx - mx/dble(npart)
	vy = vy - my/dble(npart)
	vz = vz - mz/dble(npart)

	ukin = 0.50*(sum(masa*(vx**2+vy**2+vz**2)))
	tempi= 2.0*ukin/(dble(3*npart))

	vx = vx*sqrt(temp/tempi)
	vy = vy*sqrt(temp/tempi)
	vz = vz*sqrt(temp/tempi)

	ukin = 0.50*(sum(masa*(vx**2+vy**2+vz**2)))
 	tempi= 2.0*ukin/(dble(3*npart))
	 


end




!******************************************************************************************************************
!											SOLO TE LEE Y APARTA MEMORIA PARA LAS  VARIABLES
subroutine lee
	use var
	implicit none

    write(*,*) 'Dame la cantidad de particulas que deseas'
	read(*,*) npart

	write(*,*) 'Dame lx'
	read(*,*) lx

	write(*,*) 'Dame ly'
	read(*,*) ly

	write(*,*) 'Dame lz'
	read(*,*) lz

	write(*,*) '0---> ordenada  1---->aleatoria'
	read(*,*) uc
	if(uc == 0) then
		bandera = .false.
	end if


	write(*,*) 'Dame los npasos'
	read(*,*) npasos
	! Le damos memoria a los arreglos para las pasociones
	allocate(x(npart),y(npart),z(npart))
	! Le damos memoria a los arreglos para las velocidades
	allocate(vx(npart),vy(npart),vz(npart))
	! Le damos memoria a los arreglos para los histogramas
	allocate(histox(-maxbin:maxbin),histoy(-maxbin:maxbin),histoz(-maxbin:maxbin))
	! Le damos memoria a los arreglos para las fuerzas
	allocate(fx(npart),fy(npart),fz(npart))
	!
	allocate(masa(npart))
	masa = 1.0
	

end





!*******************************************************************************************************************
!							PINTAMOS Y GENERAMOS UN ARHIVO

subroutine escribe
	use var
	implicit none
	integer:: i
	write(1,*) npart
	write(1,*)
	do i = 1, npart
		
		write(1,*)"c",x(i),y(i),z(i)
	end do


end 



