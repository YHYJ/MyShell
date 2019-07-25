#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2018-11-19 14:07:11


!
echo ">>>>>>>>>Execute script: $0"


progress() {
  # 等待提示
  # $1: pid
  # $2: 操作名
  # $3: 预估等待时间
  while ps -p "$1" > /dev/null; do
    if [[ -z "$3" ]]; then    # 判断"$3"是否为空
      for next in "-" "\\" "|" "/"; do
        tput sc
        echo -ne "[Progress]: 正在进行$2... $next"
        sleep 0.1
        tput rc
      done
    else
      for next in "-" "\\" "|" "/"; do
        tput sc
        echo -ne "[Progress]: 正在进行$2，大约需要$3... $next"
        sleep 0.1
        tput rc
      done
    fi
  done
  return 0
}

wait_finish() {
  # 等待后台命令执行完毕获取其退出状态
  # $1: pid
  # $2: 操作名称
  if wait "$1"; then
    echo
    echo
    echo ">>> $2完成."
    echo
  else
    echo
    echo
    echo "[Error]: $2失败."
    echo
  fi
}


sleep 2 &
pid="$!"

echo
progress "$pid" "测试" "2s"
wait_finish "$pid" "测试"


sleep 2 &
pid="$!"

echo
progress "$pid" "测试"
wait_finish "$pid" "测试"
