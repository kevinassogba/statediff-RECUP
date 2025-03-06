#!/bin/bash
set -e

echo "Activating Spack environment..."
source $(spack location -i statediff)/share/spack/setup-env.sh

echo "Compiling test program..."
g++ -o test_statediff test.cpp -I$(spack location -i statediff)/include \
    -L$(spack location -i statediff)/lib -lstatediff

echo "Adding statediff to the library path..."
export LD_LIBRARY_PATH=$(spack location -i statediff)/lib:$LD_LIBRARY_PATH

echo "Running tests..."
./test_statediff

echo "All tests passed!"
