#!/bin/bash

for i in {1..10000}
do
  echo ''
  echo ''
  cat rendering.o2596634
  qstat -u ylxiao
  echo 'Current time is :'$(date "+%Y-%m-%d %H:%M:%S")
  sleep 10
done
