#!/bin/bash

tasktype="bandwidth"
hostfile='./workspace/hostfile1'
time_stamp=$(date +%Y%m%d-%H%M%S)
log_dir='./workspace/logs-bandwidth'
mkdir -p $log_dir

if [[ $hostfile == **"hostfile1"** ]];then
    nodelist="pi1,pi3"
elif [[ $hostfile == **"hostfile2"** ]];then
    nodelist="pi2,pi4"
elif [[ $hostfile == **"hostfile3"** ]];then
    nodelist="pi1,pi2"
elif [[ $hostfile == **"hostfile4"** ]];then
    nodelist="pi3,pi4"
elif [[ $hostfile == **"hostfile5"** ]];then
    nodelist="pi1,pi4"
elif [[ $hostfile == **"hostfile6"** ]];then
    nodelist="pi2,pi3"
else
    echo "Invalid hostfile"
    exit 1
fi

if [[ $nodelist == *pi1* ]]; then
    exe="./pingpong1"
else
    exe="./pingpong2"
fi


log_file=log-${time_stamp}.txt
log_path=$log_dir/$log_file

repeat=1

echo "Task Type: $tasktype" | tee -a $log_path
echo "Node Number: 2" | tee -a $log_path
echo "Node List: ${nodelist}" | tee -a $log_path

for var in 1024 4096 16384 32768 65536 81920 102400 204800 409600 819200 1024000 1638400 3276800 4096000 8192000; do
    make clean
    make pingpong_msg_size=$var
    echo "Message Size: $var" | tee -a $log_path
    for i in $(seq 1 $repeat); do
        cur_time=$(date +%Y%m%d-%H%M%S)
        echo "Start time: $cur_time" | tee -a $log_path
        cmd="mpirun -np 2 --hostfile $hostfile $exe"
        echo $cmd 2>&1 | tee -a $log_path
        $cmd 2>&1 | tee -a $log_path
        cur_time=$(date +%Y%m%d-%H%M%S)
        echo "End time: $cur_time" | tee -a $log_path
    done
done