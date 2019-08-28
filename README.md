An Efficient Mixed-Mode Representation (MM-CSF) of Sparse Tensors (SC'19).  
For updated code please visit https://github.com/isratnisa/MM-CSF

## Requirements:

1. OpenBLAS-0.2.20
2. Boost-1.67.0
3. NVCC-9.2
4. GCC-7.3.0
5. CMake (>v3.2)

## Set environment variable:

1. set path for openBLAS
$export OPENBLAS_HOME=/PATH/TO/OPENBLAS

2. set path for Boost
$export BOOST_HOME=/PATH/TO/BOOST

## Tensor format

The input format is expected to start with the number of dimension of the tensor followed by the length of each dimension in the next line. The following lines will have the coordinates and values of each nonzero elements.

An example of a 3x3x3 tensor - toy.tns:  
3  
3 3 3  
1 1 1 1.00  
1 2 2 2.00  
1 3 1 10.00  
2 1 3 7.00    
2 3 1 6.00    
2 3 2 5.00  
3 1 3 3.00  
3 2 2 11.00   

## Build 

$ make  

## Run examples

$ src/mttkrp [options]

Avaiable options:  
-R rank/feature: set the rank (default 32)  
-m mode: set the mode of MTTKRP (default 0)  
-t implementation type: 1: COO CPU, 2: HCSR CPU, 3: COO GPU 4: HCSR GPU  8: B-CSF 10: HB-CSF 12: MM-CSF (default 1)  
-w warp per slice: set number of WARPs per slice  (default 4)  
-f nnz per fiber: set number of nonzeros per fiber (default 128)  
-i output file name: e.g., toy.tns  
-o output file name: if not set no output file will be written  
        
Example:

$ src/mttkrp -i toy.tns -m 0 -R 32 -t 12 -f 128 -w 1 -s 8 -b 256

To see all the options: 

$ ./mttkrp --help

## Install benchmarks

Please run the following script to install the benchmarks:

$ ./install.sh

Steps to manually install the benchmarks are at manual_install.sh

## Download tensor datasets

Step are described in How_To_Download.txt

## Run benchmark

Please run the following script to run the benchmarks:

$ ./run_benchmark.sh


