program datos
implicit none
integer:: x,y,fin
!Abrimos y esccribimos en un archivo
open(unit = 1, file = "res.dat", status = "replace", action = "write" )
!leemos un archivo
open(unit= 2, file= "input", status = "old", action="read")
	read(2,*) fin !Lo que tiene el archivo lo asignamos a fin
close(2)
	do x =1, fin
		y = x*x
		write(1,*) x,y,log(dble(y))!Hacemos un casteo a la variable y a doble por el logaritmo
	end do
close(1)
end program datos
