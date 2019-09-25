#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2018-11-20 09:38:58

timeout=5
!


timeout=10

pkgs=("env" "python" "pypkgs" "redis" "etcd" "chitu")

ask() {
  while true; do
    read -t "$timeout" -r -p "$1"
    REPLY=${REPLY:-Y}
    echo
    if [[ "$REPLY" =~ ^[Yy] ]]; then
      return 0
    elif [[ "$REPLY" =~ ^[Nn] ]]; then
      return 1
    else
      echo "[Hint]: 请输入 Y/y 或 N/n."
      echo
    fi
  done
}

uncompress() {
  # 解压缩
  # $1: 压缩包名
  echo "[Info]: 正在解压$1..."
  if unzip "$1" > /dev/null; then
    echo
    echo ">>> $1解压完成."
    echo
  else
    echo
    echo "[Error]: $1解压失败."
    echo
    exit 1
  fi
}

myinstall() {
  # 安装
  # $1: 安装文件夹名
  echo "[Info]: 正在安装${1%%-*}..."   # 从右向左截取最后一个 - 后的字符串
  if [[ -d "$1" ]]; then
    cd ./"$1" || exit 1
    if [[ ! -x ./install-"${1%%-*}".sh ]]; then
      echo
      echo "[Error]: 安装脚本没有执行权限，可能存在Bug，退出."
      echo
      cd ..
      rm -rf "$1"
      exit 1
    else
      ./install-"${1%%-*}".sh || exit 1
      cd ..
      rm -rf "$1"
    fi
  fi
}


# main
echo
echo -e "[Time]: \\e[32m所有交互等待$timeout秒，超时默认为 N !\\e[0m"
echo
# pkgs_number=6：
# 1. 安装依赖；2. 安装python环境
# 3. 安装python包；4. redis
# 5. 安装etcd；6. 安装chitu
for pkg in ${pkgs[*]}; do
  if ask "[Ask]: 是否安装$pkg（Y/n）?"; then
    echo
    uncompress "$pkg"-install.zip
    myinstall "$pkg"-install
  else
    echo "[Next]: $pkg不会被安装."
    echo
  fi
done
