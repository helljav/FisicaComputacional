program sumatoria
    use mpi
    implicit none
    integer::suma,ndatos,nproc,esclavo
    ndatos = 100
    call mpi_init(error)
        call mpi_comm_size(mpi_comm_world,nproc,error)
        call mpi_comm_rank(mpi_comm_world,esclavo,error)
        write(*,*) "Hola soy", esclavo, "de",nproc
    call mpi_finalize(error)
end program sumatoria