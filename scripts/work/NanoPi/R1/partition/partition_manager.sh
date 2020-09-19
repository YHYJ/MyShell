#!/usr/bin/env bash

: <<!
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
readonly name=$(basename "$0")

#------------------------- Exit Code Variable
readonly normal=0           # 一切正常
readonly err_file=1         # 文件/路径类错误
readonly err_param=2        # 参数错误
readonly err_fetch=48       # checkupdate错误
readonly err_permission=110 # 权限错误
readonly err_range=122      # 取值范围错误
readonly err_ctrl_c=130     # 接收到INT(Ctrl+C)指令
readonly err_unknown=255    # 未知错误
readonly err_no_program=127 # 未找到命令

#------------------------- Parameter Variable
# description variable
readonly desc="对指定磁盘进行分区"
# 分区工具
readonly part_tool='sfdisk'
# 磁盘地址
readonly disk_path='/dev'
# 分区类型
readonly part_type='ext4'
# 磁盘信息
readonly devices=$(lsblk -Jplno NAME,TYPE,SIZE,MOUNTPOINT,STATE)
readonly dev_dict=$(echo "$devices" | jq -r '.blockdevices[] | select(.type == "disk") | select(.mountpoint == null) | .name')

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
  echo -e "     -i, --info        仅显示磁盘信息而不写入（默认）"
  echo -e "     -f, --format      使用默认参数配置NanoPi-R1的eMMC"
  echo -e ""
  echo -e "     -h, --help        显示帮助信息"
  echo -e "     -v, --version     显示版本信息"
}

#------------------------- Feature Function
function diskInfo() {
  # 筛选磁盘设备
  printf '%-16s%s\n' "Disk Name" "Disk Size"
  for device in $dev_dict; do
    printf '%-16s%s\n' "$device" "$(echo "$devices" | jq --arg dev "$device" -r '.blockdevices[] | select(.name == $dev) | .size')"
  done
}

function emmcFormat() {
  printf '\n'
  read -e -r -p "请输入要配置的磁盘名(Disk Name)："
  if [[ $dev_dict =~ $REPLY ]]; then
    printf '\n%s\n' "正在分区"
    sfdisk "$REPLY" <./eMMC_Partition-Table # TODO
    printf '\n%s\n' "正在格式化"
    mkfs.ext4 /dev/mmcblk1p1 # TODO
    printf '\n%s\n' "正在配置fstab"
    echo '/dev/mmcblk1p1    /data ext4 defaults 0 0' >>/etc/fstab
    printf '\n%s\n' "OK"
  else
    printf '%s\n' "没有该磁盘"
  fi
}

function info() {
  diskInfo
}

####################################################################
#++++++++++++++++++++++++++++++ Main ++++++++++++++++++++++++++++++#
####################################################################
echo -e "Running \\e[01;32m$name\\e[0m ...\n"

case $1 in
-i | --info)
  info
  ;;
-f | --format)
  info
  emmcFormat
  ;;
-h | --help)
  helpInfo
  ;;
*)
  helpInfo
  ;;
esac
