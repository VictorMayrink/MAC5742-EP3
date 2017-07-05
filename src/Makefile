MPI=/lib64/openmpi/bin/mpicc

.PHONY: all
all: mandelbrot_seq mandelbrot_mpi mandelbrot_mpi_omp

mandelbrot_seq: mandelbrot_seq.c
	gcc -o mandelbrot_seq -std=c11 mandelbrot_seq.c

mandelbrot_mpi: mandelbrot_mpi.c
	$(MPI) -o mandelbrot_mpi -std=c11 mandelbrot_mpi.c -lm

mandelbrot_mpi_omp: mandelbrot_mpi_omp.c
	$(MPI) -o mandelbrot_mpi_omp -std=c11 mandelbrot_mpi_omp.c -fopenmp -lm
