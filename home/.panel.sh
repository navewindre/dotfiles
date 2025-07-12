#!/bin/bash

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print int(100 - $1)"%"}')

# Get free space on root drive
free_space=$(df -h / | awk '/\// {print $4}')

if command -v nvidia-smi &> /dev/null; then
    gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1"%"}')
    gpu_info="| GPU: $gpu_usage"
else
    gpu_info=""
fi


echo "CPU: $cpu_usage $gpu_info | ヂスク: $free_space |"

