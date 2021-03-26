#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2018-11-27 09:18:05


!


path=/usr/bin/
scmd=ssh
spcmd=sshpass

user=root
ip="192.168.41."
passwd=None

if [[ -e "$path$spcmd" ]]; then
  if [[ -z "$1" ]]; then
    read -r -p "[Input]: IP tail number: "
    "$spcmd" -p "$passwd" "$path$scmd" "$user"@"$ip""$REPLY"
  else
    "$spcmd" -p "$passwd" "$path$scmd" "$user"@"$ip""$1"
  fi
else
  echo
  echo "[Error]: $spcmd"uninstalled.
  echo
fi
