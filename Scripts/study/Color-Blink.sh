#!/bin/bash

: <<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2018-11-22 17:37:09

!

green() {
  echo -e "\\e[32m $1 \\e[0m"
}

green "Test"

echo -e "\\e[31;05m Test...\\e[0m"
