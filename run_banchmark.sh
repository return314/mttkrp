#!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${OPENBLAS_HOME}/lib

artifact_home=~/SC19_new_artifact/mttkrp
path=$artifact_home/datasets
out=$artifact_home/output.txt

# declare -a dataset=("nell-2")
declare -a dataset=("3d_3_8")
# declare -a dataset=("delicious-3d" "nell-1" "nell-2" "flickr-3d" "freebase_music" "freebase_sampled" "1998DARPA")
rank=32

for tsr_name in "${dataset[@]}"; do

	sk=7
	sb=7
	nnz=8

	if [ ${tsr_name} = "delicious-3d" ]; then
		nnz=140126181
		sk=16
	fi
	if [ ${tsr_name} = "nell-1" ]; then
		nnz=143599552
		sk=18
	fi
	if [ ${tsr_name} = "nell-2" ]; then
		nnz=76879419
		sk=9
	fi
	if [ ${tsr_name} = "flickr-3d" ]; then
		nnz=112890310
		sk=13
	fi
	if [ ${tsr_name} = "freebase_music" ]; then
		nnz=99546551
		sk=16
	fi
	if [ ${tsr_name} = "freebase_sampled" ]; then
		nnz=139920771
		sk=16
	fi
	if [ ${tsr_name} = "1998DARPA" ]; then
		nnz=28436033
		sk=15
	fi

	if [ ${sk} -ge "8" ]; then
		sb=7
	else
		sb=${sk}
	fi

	echo $dataset >> $out

	# echo "running MM-CSF"
	bin=$artifact_home/MM-CSF/mttkrp	
	TotTime=`$bin -i $path/"$tsr_name"_wDims.tns -m 0 -R $rank -t 12 -f 128 -w 1 -s 8 -b 256 `
	log1=`echo $TotTime | awk -F':' '{print $2}'`
	GFLOPS=`echo "9 * $rank * $nnz / ($log1 * 1000000)" | bc -l`
	echo "MM-CSF,GFLOPS - $GFLOPS" >> $out	

	bin=$artifact_home/B-CSF/src/mttkrp
	mode1T=`$bin -i $path/"$tsr_name"_wDims.tns -m 0 -R $rank -t 8 -f 128 | perl -p -e 's/\n//'`
	mode2T=`$bin -i $path/"$tsr_name"_wDims.tns -m 1 -R $rank -t 8 -f 128 | perl -p -e 's/\n//'`
	mode3T=`$bin -i $path/"$tsr_name"_wDims.tns -m 2 -R $rank -t 8 -f 128 | perl -p -e 's/\n//'`
	
	mode1Time=`echo ${mode1T: : -1} | awk -F':' '{print $3}'`
	mode2Time=`echo ${mode1T: : -1} | awk -F':' '{print $3}'`
	mode3Time=`echo ${mode1T: : -1} | awk -F':' '{print $3}'`

	log1=`echo "$mode1Time + $mode2Time + $mode3Time" | bc -l`
	GFLOPS=`echo "9 * $rank * $nnz / ($log1 * 1000000)" | bc -l`
	echo "B-CSF,GFLOPS - $GFLOPS" >> $out

# SPLATT ALL-CSF
	echo "Processing SPLATT (ALL-CSF)"
	bin=$artifact_home/splatt/build/Linux-x86_64/bin/splatt
	$bin cpd --csf=all $path/"$tsr_name".tns -r $rank --verbose --iters=1 --tile --nowrite -t 28 &> splatt_tmp
	sptime=`grep 'MTTKRP' splatt_tmp | awk -F' ' '{print $2}'` 
	log1s="${sptime: : -1}"
	log1=`echo "$log1s * 1000" | bc -l`
	GFLOPS=`echo "9 * $rank * $nnz / ($log1 * 1000000)" | bc -l`
	echo "SPLATT-ALL-CSF,GFLOPS - $GFLOPS" >> $out	

# SPLATT-ONECSF
	echo "Processing SPLATT (ONE-CSF)"
	bin=$artifact_home/splatt/build/Linux-x86_64/bin/splatt
	$bin cpd --csf=one $path/"$tsr_name".tns -r $rank --verbose --iters=1 --tile --nowrite -t 28 &> splatt_tmp
	sptime=`grep 'MTTKRP' splatt_tmp | awk -F' ' '{print $2}'` 
	log1s="${sptime: : -1}"
	log1=`echo "$log1s * 1000" | bc -l`
	GFLOPS=`echo "9 * $rank * $nnz / ($log1 * 1000000)" | bc -l | scale=2`
	echo "SPLATT-ONE-CSF,GFLOPS - $GFLOPS" >> $out	

	# bin=$artifact_home/ParTI/build/examples/mttkrp_gpu
	# for (( m = 0; m < 3; m++ )); do
	# 	$bin $path/"$tsr_name"_wDims.tns $m 15 0 $rank &> PARTItime
	# 	log1=`cat PARTItime | grep 'CUDA SpTns MTTKRP' | perl -p -e 's/\n//'`
	# 	echo "ParTI-GPU,$dataset,$log1" >> $outfile
	# done

# HiCOO
	bin=$artifact_home/ParTI/build/examples/mttkrp_hicoo
    $bin -i $path/"$tsr_name"_wDims.tns -m -1 -b ${sb} -k ${sk}  -d -1 -r $rank  -t 28 &> hicoo_tmp

	mode1Time=`cat hicoo_tmp | grep 'MTTKRP MODE\ 0' | awk -F':' '{print $2}' |  awk -F' ' '{print $1}'`
	mode2Time=`cat hicoo_tmp | grep 'MTTKRP MODE\ 1' | awk -F':' '{print $2}' |  awk -F' ' '{print $1}'`
	mode3Time=`cat hicoo_tmp | grep 'MTTKRP MODE\ 2' | awk -F':' '{print $2}' |  awk -F' ' '{print $1}'`

	totTime=`echo "$mode1Time + $mode2Time + $mode3Time" | bc -l`
	log1=`echo "$totTime * 1000" | bc -l`
	GFLOPS=`echo "9 * $rank * $nnz / ($log1 * 1000000)" | bc -l`
	echo "HiCOO,GFLOPS - $GFLOPS" >> $out	

done



