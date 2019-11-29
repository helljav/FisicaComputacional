module var
	implicit none
	integer :: ndatos, maxbin = 99
	double precision, dimension(:), allocatable::x,y,z0,z1
	integer, dimension(:), allocatable :: histo
	double precision :: dx
end






!**************************************************************************************
!					MAIN()
Program gaussiana
	use var
	implicit none														   
	call inicio
	call gaus
	call calcula
	call escribe
	
end program gaussiana



!**************************************************************************************
! ya teniendo los numeros aleatorios de distribucion uniforme, vamos a transformarlos 
!a uno con distribucion gausiana vase a este metodo y a wikipedia

subroutine gaus
	use var
	implicit none
	integer:: i
	double precision:: toPi = 2.0*3.1416
	allocate(z0(ndatos),z1(ndatos))
	do i=1, ndatos
		z0(i) = sqrt(-2*log(x(i)))*cos(toPi*y(i))
		z1(i) = sqrt(-2*log(x(i)))*sin(toPi*y(i))
	end do 	

end

!**************************************************************************************
!			INICIA LOS ARREGLOS ALEATORIOS
subroutine inicio
	
	use var
	implicit none
	double precision:: xx, yy
	integer:: i

	write(*,*) "dame los n puntos"			
	read(*,*) ndatos

	allocate(x(ndatos),y(ndatos))

	do i=1, ndatos
		call random_number(xx)
		call random_number(yy)
		x(i) = xx
		y(i) = yy
		!write(*,*) x(i), " ", y(i)
	end do 	
	

end

!***************************************************************************************


!***************************************************************************************
!                           METODO CALCULA PARA EL HISTOGRAMA        


subroutine calcula
	use var
	implicit none
	integer :: i, bin
	double precision :: lsup, linf

	
	allocate(histo(-maxbin:maxbin))
	histo=0
	lsup = maxval(z1)
	linf = minval(z1)
	dx = (lsup-linf)/maxbin

	do i=1,ndatos
		bin = z1(i)/dx
		histo(bin) = histo(bin) + 1
			
	enddo
end

!****************************************************************************************
!

subroutine escribe
	use var
	implicit none
	integer :: i
	do i= -maxbin,maxbin
		write(1,*) i*dx,histo(i)
	enddo
end



