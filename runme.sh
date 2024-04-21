#!/bin/bash

FILE="shared_file.txt"
STATS="stats.txt"

if [ ! -f "$STATS" ]; then
    touch "$STATS"
fi

start_time=$(date +%s)

task_runtime=$((5 * 60))

for i in {1..10}; do
  (
    LOCK_COUNT=0
    end_time=$((start_time + task_runtime))
    while true; do
      current_time=$(date +%s)
      if ((current_time >= end_time)); then
        break
      fi
      
      ./lock "$FILE" && ((LOCK_COUNT++))
      sleep 1
    done
    echo "$LOCK_COUNT" >> "$STATS"
  ) &
  
  if [ $(jobs -p | wc
