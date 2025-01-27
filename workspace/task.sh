#!/bin/bash

tasktype=$1

sleep_run=60
sleep_cool=30
sleep_interval=40

repeat=100
for i in $(seq 1 $repeat); do

    time_stamp=$(date +%Y%m%d-%H%M%S)

    if [[ $tasktype == "interleaved" ]]; then
        bash ./run.sh interleaved hostfile1 $time_stamp &
        bash ./run.sh interleaved hostfile2 $time_stamp 
    elif [[ $tasktype == "single" ]]; then
        bash ./run.sh single hostfile1 $time_stamp
        bash ./run.sh single hostfile2 $time_stamp
    elif [[ $tasktype == "" ]]; then
        bash ./run.sh interleaved hostfile1 $time_stamp &
        bash ./run.sh interleaved hostfile2 $time_stamp 

        sleep $sleep_run

        bash ./run.sh single hostfile1 $time_stamp
        bash ./run.sh single hostfile2 $time_stamp

        sleep $sleep_cool

        bash ./run.sh interleaved hostfile3 $time_stamp &
        bash ./run.sh interleaved hostfile4 $time_stamp

        sleep $sleep_run
        bash ./run.sh single hostfile3 $time_stamp
        bash ./run.sh single hostfile4 $time_stamp

        sleep $sleep_cool

        bash ./run.sh interleaved hostfile5 $time_stamp &
        bash ./run.sh interleaved hostfile6 $time_stamp

        sleep $sleep_run

        bash ./run.sh single hostfile5 $time_stamp
        bash ./run.sh single hostfile6 $time_stamp

    else
        echo "Invalid task type"
        exit 1
    fi

    sleep $sleep_interval
done


