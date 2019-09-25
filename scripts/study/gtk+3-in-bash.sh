#!/bin/bash

: <<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2019-01-05 16:28:12


!

text=$(zenity --entry --title='Hello world!' --text='Please input:')
echo "Your input is: $text"
