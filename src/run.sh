#! /bin/bash

set -o xtrace

MPIRUN=/lib64/openmpi/bin/mpirun

MEASUREMENTS=1
SIZE=2048

#Create folders
if [ -d ./results ]; then
    rm -rf ./results
fi
mkdir results

if [ -d ./pictures ]; then
    rm -rf ./pictures
fi
mkdir pictures

#MANDELBROT: Sequential (with I/O)
for ((r = 1; r<=MEASUREMENTS; r++)); do
    perf stat -d ./mandelbrot_seq -2.500  1.500 -2.000 2.000 $SIZE >> full.log 2>&1
    mv output.ppm pictures/full_seq.ppm

    perf stat -d $MPIRUN ./mandelbrot_mpi -2.500  1.500 -2.000 2.000 $SIZE >> full.log 2>&1
    mv output.ppm pictures/full_mpi.ppm

    perf stat -d $MPIRUN ./mandelbrot_mpi_omp -2.500  1.500 -2.000 2.000 8 $SIZE >> full.log 2>&1
    mv output.ppm pictures/full_mpi_omp.ppm

	DIFF=$(diff pictures/full_seq.ppm pictures/full_mpi.ppm) 
	if [ "$DIFF" == "" ]
	then
		echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
	else
		echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
		exit 1
	fi

	DIFF=$(diff pictures/full_seq.ppm pictures/full_mpi_omp.ppm) 
	if [ "$DIFF" == "" ]
	then
		echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
	else
		echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
		exit 1
	fi

    perf stat -d ./mandelbrot_seq -0.800 -0.700  0.050 0.150 $SIZE >> seahorse.log 2>&1
    mv output.ppm pictures/seahorse_seq.ppm

    perf stat -d $MPIRUN ./mandelbrot_mpi -0.800 -0.700  0.050 0.150 $SIZE >> seahorse.log 2>&1
    mv output.ppm pictures/seahorse_mpi.ppm

    perf stat -d $MPIRUN ./mandelbrot_mpi_omp -0.800 -0.700  0.050 0.150 8 $SIZE >> seahorse.log 2>&1
    mv output.ppm pictures/seahorse_mpi_omp.ppm

    DIFF=$(diff pictures/seahorse_seq.ppm pictures/seahorse_mpi.ppm) 
	if [ "$DIFF" == "" ]
	then
		echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
	else
		echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
		exit 1
	fi

    DIFF=$(diff pictures/seahorse_seq.ppm pictures/seahorse_mpi_omp.ppm) 
	if [ "$DIFF" == "" ]
	then
		echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
	else
		echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
		exit 1
	fi

    perf stat -d ./mandelbrot_seq  0.175  0.375 -0.100 0.100 $SIZE >> elephant.log 2>&1
    mv output.ppm pictures/elephant_seq.ppm

    perf stat -d $MPIRUN ./mandelbrot_mpi  0.175  0.375 -0.100 0.100 $SIZE >> elephant.log 2>&1
    mv output.ppm pictures/elephant_mpi.ppm

    perf stat -d $MPIRUN ./mandelbrot_mpi_omp  0.175  0.375 -0.100 0.100 8 $SIZE >> elephant.log 2>&1
    mv output.ppm pictures/elephant_mpi_omp.ppm

	DIFF=$(diff pictures/elephant_seq.ppm pictures/elephant_mpi.ppm) 
	if [ "$DIFF" == "" ]
	then
		echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
	else
		echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
		exit 1
	fi

	DIFF=$(diff pictures/elephant_seq.ppm pictures/elephant_mpi_omp.ppm) 
	if [ "$DIFF" == "" ]
	then
		echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
	else
		echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
		exit 1
	fi

    perf stat -d ./mandelbrot_seq -0.188 -0.012  0.554 0.754 $SIZE >> triple_spiral.log 2>&1
    mv output.ppm pictures/triple_spiral_seq.ppm

    perf stat -d $MPIRUN ./mandelbrot_mpi -0.188 -0.012  0.554 0.754 $SIZE >> triple_spiral.log 2>&1
    mv output.ppm pictures/triple_spiral_mpi.ppm

    perf stat -d $MPIRUN ./mandelbrot_mpi_omp -0.188 -0.012  0.554 0.754 8 $SIZE >> triple_spiral.log 2>&1
    mv output.ppm pictures/triple_spiral_mpi_omp.ppm

	DIFF=$(diff pictures/triple_spiral_seq.ppm pictures/triple_spiral_mpi.ppm) 
	if [ "$DIFF" == "" ]
	then
		echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
	else
		echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
		exit 1
	fi

	DIFF=$(diff pictures/triple_spiral_seq.ppm pictures/triple_spiral_mpi_omp.ppm) 
	if [ "$DIFF" == "" ]
	then
		echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
	else
		echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
		exit 1
	fi

done

#Move logs to results folder
mv full.log seahorse.log elephant.log triple_spiral.log results/