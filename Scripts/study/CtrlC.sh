#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2018-11-27 12:17:48


!
echo ">>>>>>>>>Execute script: $0"


trap 'onCtrlC' INT
function onCtrlC () {
    echo 'Ctrl+C is captured'
    exit 1
}

while true; do
    echo 'I am working!'
     sleep 1
done
