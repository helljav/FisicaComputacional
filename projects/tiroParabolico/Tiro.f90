module var
	implicit none
	double precision :: v0, angulo
end


program parabolico
	use var
	implicit none
	double precision:: v0x, v0y, x, y, time = 0.0, g = 9.8


	write(*,*) "Dame el angulo "
	read(*,*) angulo

	write(*,*) "Dame la velocidad inicial"
	read(*,*) v0

	v0x = v0*cos((angulo*3.1416)/180)
	v0y = v0*sin((angulo*3.1416)/180)

	
	do
		x = v0x*time
		y = v0y*time - 0.5*g*time**2
		time = time + 0.01
		write(1,*) x,y
		if(y<0) then
			exit
		end if
		
	
	
	end do 


	




end program parabolico