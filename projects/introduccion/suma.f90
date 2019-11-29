program sumra
 implicit none
 integer:: i
 double precision:: suma
 suma = 0.0

 do i=1,100
  suma = suma + i
 end do
 

 write(*,*)  suma 
 
 !Vamos a imprimir con un format
 !Se cuenta los elementos que se quiere mandar a imprimir, incluyendo el punto decimal f es de float, el 6 es de los enteros y el uno !es los numeros decimales que se van a mostrar 
 

 write(*,100) suma
 100 format(f6.1)

 write (*,"(a,f6.1)") "Suma con formato", suma 
end program sumra 
