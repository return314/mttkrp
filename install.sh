
# set path for openBLAS
export OPENBLAS_HOME=/PATH/TO/OPENBLAS

# set path for Boost
export BOOST_HOME=/PATH/TO/BOOST

# Install SPLATT LIBRARY
echo "Isntalling SPLATT library"

echo "Downloading SPLATT"
git clone https://github.com/ShadenSmith/splatt.git
cd splatt
./configure --precision=single --with-blas-lib=${LAPACK_LIB_PATH}/lib/libopenblas_haswellp-r0.3.6.dev.so --with-lapack-lib=${LAPACK_LIB_PATH}/lib/libopenblas_haswellp-r0.3.6.dev.so 

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

