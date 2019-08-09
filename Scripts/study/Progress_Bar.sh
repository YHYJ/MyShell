#!/bin/bash

: <<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2018-11-19 14:07:11


!

i=0
str=""
array=("-" "\\" "|" "/")

while [[ "$i" -le 100 ]]; do
  ((index = i % 4))
  printf "[%-100s] [%d%%] [\\e[33;46;1m%c\\e[0m]\\r" "$str" "$i" "${array[$index]}"
  sleep 0.1
  ((i++))
  str+='#'
done
