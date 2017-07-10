#! /bin/bash
N_NODES=$1
N_CORES=$2
N_MEASUREMENTS=10
SIZE=8192
set -o xtrace
#Create folders
if [ -d ./results ]; then
    rm -rf ./results
fi
mkdir results

if [ -d ./pictures ]; then
    rm -rf ./pictures
fi
mkdir pictures
./run_config.sh full $SIZE $N_NODES $N_CORES $N_MEASUREMENTS
./run_config.sh seahorse $SIZE $N_NODES $N_CORES $N_MEASUREMENTS
./run_config.sh elephant $SIZE $N_NODES $N_CORES $N_MEASUREMENTS
./run_config.sh triple_spiral $SIZE $N_NODES $N_CORES $N_MEASUREMENTS




