#!/bin/bash
# set path for openBLAS
# export OPENBLAS_HOME=/PATH/TO/OPENBLAS

# # set path for Boost
# export BOOST_HOME=/PATH/TO/BOOST


# Install MM-CSF
echo "Isntalling MM-CSF"

cd MM-CSF

make

cd ..


# Install SPLATT LIBRARY
echo "Isntalling SPLATT library"

echo "Downloading SPLATT"
git clone https://github.com/ShadenSmith/splatt.git
cd splatt
./configure --precision=single --with-blas-lib=${OPENBLAS_HOME}/lib/libopenblas_haswellp-r0.3.6.dev.so --with-lapack-lib=${OPENBLAS_HOME}/lib/libopenblas_haswellp-r0.3.6.dev.so 

make

echo "Steps to manually install SPLATT are described in the manual_install.txt or in https://github.com/ShadenSmith/splatt."

cd ..

# Install ParTI LIBRARY
echo "Isntalling ParTI library"

echo "Downloading ParTI"

git clone https://github.com/hpcgarage/ParTI.git
cd ParTI
./build.sh

echo "Steps to manually install ParTI are described in the manual_install.txt or in https://github.com/hpcgarage/ParTI"

cd ..

# Install B-CSF LIBRARY
echo "Isntalling B-CSF"

echo "Downloading B-CSF"

git clone https://github.com/isratnisa/B-CSF.git
cd B-CSF/src
make

echo "Steps to manually install B-CSF are described in the manual_install.txt or in https://github.com/isratnisa/B-CSF"

cd ..


