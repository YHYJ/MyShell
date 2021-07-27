#!/usr/bin/env bash

: << !
Name: partition_manager.sh
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2020-09-08 14:32:31

Description: 对磁盘进行分区

Attentions:
- 显示逻辑：
  1. 显示全部可用磁盘名
  2. 显示指定磁盘详细信息
- 操作逻辑：
  1. 显示全部可用磁盘名
  2. 显示指定磁盘当前详细信息
  3. 显示要变更的配置信息
    3.1 提供默认配置
    3.2 用户可指定各分区大小，起点和末尾值自动计算
  4. 询问是否确定要将更改写入磁盘

Depends:
-
!

####################################################################
#+++++++++++++++++++++++++ Define Variable ++++++++++++++++++++++++#
####################################################################
#------------------------- Program Variable
# program name
name=$(basename "$0")
readonly name

#------------------------- Exit Code Variable
readonly normal=0        # 一切正常
readonly err_file=1      # 文件/路径类错误
readonly err_param=2     # 参数错误
readonly err_unknown=255 # 未知错误

#------------------------- Parameter Variable
# description variable
readonly desc="对指定磁盘进行分区"
# 分区工具
readonly part_tool='sfdisk'
# 分区类型
readonly part_type='ext4'
# 磁盘信息
devices=$(lsblk -Jplno NAME,TYPE,SIZE,MOUNTPOINT,STATE)
readonly devices
dev_dict=$(echo "$devices" | jq -r '.blockdevices[] | select(.type == "disk") | select(.mountpoint == null) | .name')
readonly dev_dict

####################################################################
#+++++++++++++++++++++++++ Define Function ++++++++++++++++++++++++#
####################################################################
#------------------------- Info Function
function helpInfo() {
  echo -e ""
  echo -e "\e[32m$name\e[0m\e[1m$desc\e[0m"
  echo -e "--------------------------------------------------"
  echo -e "Usage:"
  echo -e ""
  echo -e "     $name [OPTION]"
  echo -e ""
  echo -e "Options:"
  echo -e "     -i, --info              仅显示磁盘信息而不写入（默认）"
  echo -e "     -f, --format <DiskName> 使用默认参数配置NanoPi-R1指定的eMMC"
  echo -e ""
  echo -e "     -h, --help              显示帮助信息"
  echo -e ""
  echo -e "ARG:"
  echo -e "     <DiskName>              磁盘设备名（例如/dev/sda），不写则要求输入"
}

#------------------------- Feature Function
function diskInfo() {
  # 筛选磁盘设备
  printf '%-20s%s\n' "Disk Name" "Disk Size"
  for device in $dev_dict; do
    printf '%-20s%s\n' "$device" "$(echo "$devices" | jq --arg dev "$device" -r '.blockdevices[] | select(.name == $dev) | .size')"
  done
}

function emmcFormat() {
  printf '\n'

  # 判断是否指定了'--disk'参数且长度符合（最少是'/dev/'，所以阈值是5），否则要求输入
  if [[ ${#1} -gt 5 ]]; then
    if [[ $dev_dict =~ $1 ]]; then
      target_dev=$1
    else
      printf '%s\n' "没有磁盘$1，请重新输入"
      read -e -r -p "请输入要配置的磁盘名(Disk Name)："
      if [[ $dev_dict =~ $REPLY ]]; then
        target_dev=$REPLY
      else
        printf '%s\n' "没有磁盘$REPLY"
        exit $err_file
      fi
    fi
  else
    printf '%s\n' "没有磁盘$1，请重新输入"
    read -e -r -p "请输入要配置的磁盘名(Disk Name)："
    if [[ $dev_dict =~ $REPLY ]]; then
      target_dev=$REPLY
    else
      printf '%s\n' "没有磁盘$REPLY"
      exit $err_file
    fi
  fi

  # 开始分区
  printf '\n%s\n' "正在分区"
  $part_tool "$target_dev" < ./eMMC_Partition-Table
  printf '\n%s\n' "正在格式化"
  mkfs.$part_type "$target_dev"p1
  printf '\n%s\n' "正在配置fstab"
  echo "$target_dev"'p1    /data ext4 defaults 0 0' >> /etc/fstab
  printf '\n%s\n' "OK，请重启系统！"
}

####################################################################
#++++++++++++++++++++++++++++++ Main ++++++++++++++++++++++++++++++#
####################################################################
echo -e "Running \\e[01;32m$name\\e[0m ...\n"

TEMP=$(getopt --options "f::hi" --longoptions "format::,help,info" -n "$name" -- "$@")
eval set -- "$TEMP"

if [[ ${#@} -lt 2 ]]; then
  helpInfo
  exit $err_param
else
  while true; do
    case $1 in
      -i | --info)
        diskInfo
        exit $normal
        ;;
      -f | --format)
        case $2 in
          *)
            diskInfo
            emmcFormat "$2"
            exit $normal
            ;;
        esac
        ;;
      -h | --help)
        helpInfo
        exit $normal
        ;;
      --)
        shift 1
        break
        ;;
      *)
        helpInfo
        exit $err_unknown
        ;;
    esac
  done
fi
