#!/bin/bash

PID=`pgrep -f run_meimei`

if [[ "$PID" == "" ]] ; then
    cd /home/albert/meimei
    ./run_meimei.rb &
fi
