set -o xtrace
NAME=$1
SIZE=$2
N_NODES=$3
N_CORES=$4
N_MEASUREMENTS=$5
HOST_STR="instance-1"
for ((r = 2; r <= N_NODES; r++)); do
    INSTANCE_STR=",instance-$r"
    HOST_STR=$HOST_STR$INSTANCE_STR
done

if [ "$NAME" == "full" ]
then  
    x1=-2.500
    x2=1.500
    y1=-2.000
    y2=2.000
elif [ "$NAME" == "seahorse" ]
then
    x1=-0.800
    x2=-0.700
    y1=0.050
    y2=0.150
elif [ "$NAME" == "elephant" ]
then
    x1=0.175
    x2=0.375
    y1=-0.100
    y2=0.100
elif [ "$NAME" == "triple_spiral" ]
then
    x1=-0.188
    x2=-0.012
    y1=0.554
    y2=0.754
fi
LOG_NAME=$NAME".log"

if [ "$N_NODES" == "1" ]
then
    perf stat -r $N_MEASUREMENTS ./mandelbrot_seq $x1 $x2 $y1 $y2 $SIZE >> results/$LOG_NAME 2>&1
    mv output.ppm pictures/$NAME"_seq.ppm"
fi

if [ ! "$N_NODES" == "1" ]
then
    perf stat -r $N_MEASUREMENTS mpirun -host $HOST_STR ./mandelbrot_mpi $x1 $x2 $y1 $y2 $SIZE >> results/$LOG_NAME 2>&1
    mv output.ppm pictures/$NAME"_mpi.ppm"
fi

if [ ! "$N_NODES" == "8" ]
then
    perf stat -r $N_MEASUREMENTS mpirun -host $HOST_STR ./mandelbrot_mpi_omp $x1 $x2 $y1 $y2 $N_CORES $SIZE >> results/$LOG_NAME 2>&1
    mv output.ppm pictures/$NAME"_mpi_omp.ppm"
fi


# DIFF=$(diff pictures/$NAME"_seq.ppm" pictures/$NAME"_mpi.ppm") 
# if [ "$DIFF" == "" ]
# then
#     echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
# else
#     echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
#     exit 1
# fi

# DIFF=$(diff pictures/$NAME"_seq.ppm" pictures/$NAME"_mpi_omp.ppm") 
# if [ "$DIFF" == "" ]
# then
#     echo -e "$(tput setaf 2)TEST PASSED$(tput sgr0)"	    
# else
#     echo -e "$(tput setaf 1)TEST FAIL$(tput sgr0)"
#     exit 1
# fi
