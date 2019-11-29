program datos
	implicit none
	integer:: i,fin
	!Declaramos los arreglos
	integer, dimension(:),allocatable::x,y



	!Abrimos y leemos en un archivo
	open(unit= 2, file= "input", status = "old", action="read")
		read(2,*) fin !Lo que tiene el archivo lo asignamos a fin
	close(2)!Cerramos el archivo

	!Ponemos la dimension a cada arreglo
	allocate(x(fin),y(fin))

	do i =1, fin
		x(i) = i
		y(i) = i*i
	end do


	!Abrimos y esccribimos en un archivo
	open(unit= 2, file= "ressarr.dat", status = "replace", action="write")
		do i=1,fin
			write(2,*) x(i),y(i)
		end do
	!close(2)!Cerramos el archivo


	!Como se puede aplicar una funcion a todo un arreglo
	y = sqrt(dble(y))

	!Abrimos y esccribimos en un archivo
	!open(unit= 2, file= "ressarr.dat", status = "old", action="write")
		do i=1,fin
			write(2,*)x(i), y(i)
		end do
	close(2)!Cerramos el archivo

	!Liberamos memoria
	deallocate(x,y)

end program datos
