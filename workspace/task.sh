#!/bin/bash

tasktype=$1

time_stamp=$(date +%Y%m%d_%H%M%S)
log_dir="./logs-${time_stamp}"

sleep_run=30
sleep_cool=2
sleep_interval=5

repeat=40

for i in $(seq 1 $repeat); do
    for var in 102400 204800 819200 2048000; do

        time_stamp=$(date +%Y%m%d-%H%M%S)
        make clean -C ../
        make pingpong_msg_size=$var -C ../
        
        # Warm up
        mpirun -np 8 --hostfile hostfile1 ../pingpong1 
        mpirun -np 8 --hostfile hostfile2 ../pingpong2


        mpirun -np 8 --hostfile hostfile2 ../pingpong2 &
        mpirun -np 8 --hostfile hostfile1 ../pingpong1 

        sleep $sleep_run

        if [[ $tasktype == "interleaved" ]]; then
            bash ./run.sh interleaved hostfile1 $time_stamp $log_dir &
            bash ./run.sh interleaved hostfile2 $time_stamp $log_dir
        elif [[ $tasktype == "single" ]]; then
            bash ./run.sh single hostfile1 $time_stamp
            bash ./run.sh single hostfile2 $time_stamp
        elif [[ $tasktype == "" ]]; then
            
            bash ./run.sh single hostfile1 $time_stamp $log_dir
            bash ./run.sh single hostfile2 $time_stamp $log_dir
            sleep $sleep_cool

            bash ./run.sh interleaved hostfile1 $time_stamp $log_dir &
            bash ./run.sh interleaved hostfile2 $time_stamp $log_dir 
            sleep $sleep_run

            bash ./run.sh single hostfile3 $time_stamp $log_dir
            bash ./run.sh single hostfile4 $time_stamp $log_dir
            sleep $sleep_cool

            bash ./run.sh interleaved hostfile3 $time_stamp $log_dir &
            bash ./run.sh interleaved hostfile4 $time_stamp $log_dir
            sleep $sleep_run

            bash ./run.sh single hostfile5 $time_stamp $log_dir
            bash ./run.sh single hostfile6 $time_stamp $log_dir
            sleep $sleep_cool

            bash ./run.sh interleaved hostfile5 $time_stamp $log_dir &
            bash ./run.sh interleaved hostfile6 $time_stamp $log_dir
            sleep $sleep_run

        else
            echo "Invalid task type"
            exit 1
        fi
        sleep $sleep_interval
    done

done


