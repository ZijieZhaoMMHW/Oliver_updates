Directory="/scratch/v45/zz6006/mhw_hw_mhw"

for ((loop=1; loop<=720; loop=loop+1)); do
    #replace loop_s in mfile with $loop
    sed "s/depth_s/$loop/g" mhwdetectf.m > mhwdetectf$loop.m
    sed "s/files/$loop/g" submhwdetectf.sh   > submhwdetectf$loop.sh
    qsub submhwdetectf$loop.sh
done