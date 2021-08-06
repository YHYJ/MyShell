#!/usr/bin/env bash

: <<!
Name: pings.sh
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2018-10-17 15:01:58

测试给定IP或Host能否ping通，参数数量没有限制

[BUG]:
1. HOST输入模式正则匹配不完善
2. 输入汉字会当做正确输入（虽然显示不在线）
!

count=2      # ping的次数
interval=0.2 # 数据包发送间隔，最小为200ms，即0.2
waittime=1   # 等待超时

off=0 # 计数器：离线数
on=0  # 计数器：在线数

trap onCtrlC INT
onCtrlC() {
  echo
  echo
  echo "[Bye]: Captured EXIT signal."
  echo
  exit 1
}

if [[ $# == 0 ]]; then # 没有参数
  while true; do
    read -r -p "[Input]: IP or URL ('Q'/'q' to exit): "

    case $REPLY in
    "q" | "Q" | "")
      echo
      echo "[Info]: Total test $((on + off))"
      echo -e "[Info]: On line: $on -- Off line: $off"
      echo
      exit 0
      #  ;;
      #[a-p]* | [r-z]* | [A-P]* | [R-Z]*)
      #  echo "[Error]: Input Error."
      #  continue
      ;;
    esac

    if ping -c $count -i $interval -W $waittime "$REPLY" >&/dev/null; then
      echo "[Info]: $REPLY On line."
      ((on++))
    else
      echo -e "[Info]: \\e[31m$REPLY Off line\\e[0m."
      ((off++))
    fi

  done
else # 有参数
  for ip in "$@"; do
    if ping -c $count -i $interval -W $waittime "$ip" >&/dev/null; then
      echo "[Info]: $ip On line."
      ((on++))
    else
      echo -e "[Info]: \\e[31m$REPLY Off line\\e[0m."
      ((off++))
    fi
  done
  echo
  echo "[Info]: Total test $((on + off))"
  echo -e "[Info]: On line: $on -- Off line: $off"
  echo
fi
