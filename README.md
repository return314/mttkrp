## Requirements:

1. OpenBLAS-0.2.20
2. Boost-1.67.0
3. NVCC-9.2
4. GCC-7.3.0

## Set environment variable:

1. set path for openBLAS
$export OPENBLAS_HOME=/PATH/TO/OPENBLAS

2. set path for Boost
$export BOOST_HOME=/PATH/TO/BOOST

## Tensor format

The dataset starts with number of dimension followed by length of each dimension in the next line. E.g.,
example.tns  
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

## Run

To see all the options: 

$ ./mttkrp --help

Example:

$ ./mttkrp -i example.tns -m 0 -R 32 -t 1  

-t 1: COO on CPU  
-t 12: MM-CSF on GPU  



