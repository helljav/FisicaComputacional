
program pi
	
	implicit none
	double precision:: xx, yy, circulo = 0,cuadrado = 0, pit
	integer:: i, ndatos

	write(*,*) "Cuantos pares de numeros aleatorios generar"			
	read(*,*) ndatos

	do i=1, ndatos

		call random_number(xx)
		call random_number(yy)
		xx = 2.0*xx - 1.0
		yy = 2.0*yy - 1.0
		
		cuadrado = cuadrado + 1
		if ((xx**2 + yy**2) <= 1) then
			circulo = circulo +1
			write(1,*)xx,yy
		else
			write(2,*) xx,yy 

		end if
		
		 
	end do

	pit = 4*(circulo/cuadrado)

	write(*,*) pit

	

end program pi



