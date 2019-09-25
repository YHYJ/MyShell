#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2018-09-21 10:39:59


!
echo ">>>>>>>>>Execute script: $0"


path=/usr/bin/
cmd=ntpdate

cron_file=/var/spool/cron/"$USER"

server=168.168.3.44

if crontab -l | grep ntpdate; then
  echo "[Info]: 已有时间同步的crontab任务，退出."
  echo
  exit
fi

echo
echo -e "[Info]: 当前时间:\\n$(date)"
echo

echo
echo "[Info]: 设置时区为 Asia/Shanghai ."
timedatectl set-timezone Asia/Shanghai
echo
echo "[Info]: 当前时区:" && timedatectl |grep "Time zone"
echo

if echo -e "# Effect: 时间同步; Author: YJ\n* * */1 * * $path$cmd $server" > "$cron_file"; then
  if systemctl restart crond; then
    echo "[Info]: <crond>重启完毕."
    echo
    echo "[Info]: 当前用户$USER的crontab:"
    crontab -l
    echo
    echo "[Info]: 正在手动进行一次同步..."
    
    if ntpdate $server; then
      echo
      echo -e "[Info]: 当前时间:\\n$(date)"
      echo
      echo "[Info]: 时间同步完成，已设置定时同步."
      echo
    fi
  fi
fi
