#! /bin/bash

set -o xtrace

N_NODES=$1
N_CORES=$2

HOST_STR=instance-1
for ((r = 2; r <= N_NODES; r++)); do
    INSTANCE_STR=,instance-$r
    HOST_STR=$HOST_STR$INSTANCE_STR
done

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
./run_config full $SIZE $MEASUREMENTS
./run_config seahorse $SIZE $MEASUREMENTS
./run_config elephant $SIZE $MEASUREMENTS
./run_config triple_spiral $SIZE $MEASUREMENTS

#Move logs to results folder
mv full.log seahorse.log elephant.log triple_spiral.log results/
