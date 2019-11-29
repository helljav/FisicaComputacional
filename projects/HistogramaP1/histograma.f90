module variables
	implicit none
	integer :: ndatos, maxbin
	double precision, dimension(:), allocatable :: datos
	integer, dimension(:), allocatable :: histo
	double precision :: dx
end

program histograma2
	use variables
	implicit none

	call inicio
	call calcula
	call escribe
end program histograma2
!---------------------
!Subrutines
!---------------------
subroutine inicio
	use variables
	implicit none

	integer :: i
	double precision :: xx

	write(*,*) 'datos'
	read(*,*) ndatos
	allocate(datos(ndatos))

	do i=1,ndatos
		call random_number(xx)
		datos(i) = xx
		write(1,*) i, datos(i)
	enddo
end

subroutine calcula
	use variables
	implicit none
	integer :: i, bin
	double precision :: lsup, linf

	maxbin = 99
	allocate(histo(0:maxbin))
	histo=0
	lsup = maxval(datos)
	linf = minval(datos)
	dx = (lsup-linf)/maxbin

	do i=1,ndatos
		bin = datos(i)/dx
		histo(bin) = histo(bin) + 1	
	enddo
end

subroutine escribe
	use variables
	implicit none
	integer :: i, bin

	do i=0,maxbin
		bin = datos(i)/dx
		histo(bin) = histo(bin) + 1
	enddo
end
