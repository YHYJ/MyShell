#!/usr/bin/env bash

: <<!
Name: operate_docker.sh
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2021-03-26 11:16:01

Description: 操作docker

Attentions:
-

Depends:
-
!

####################################################################
#+++++++++++++++++++++++++ Define Variable ++++++++++++++++++++++++#
####################################################################
#------------------------- Program Variable
# program name
readonly name=$(basename "$0")
# program version
readonly major_version=0.1
readonly minor_version=20210326
readonly rel_version=1

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
readonly desc='用于生成涉及docker的命令'

####################################################################
#+++++++++++++++++++++++++ Define Function ++++++++++++++++++++++++#
####################################################################
#------------------------- Info Function
function helpInfo() { # 打印帮助信息
  echo -e ""
  echo -e "\e[32m$name\e[0m\e[1m$desc\e[0m"
  echo -e "--------------------------------------------------"
  echo -e "Usage:"
  echo -e ""
  echo -e "     $name [OPTION]"
  echo -e ""
  echo -e "Options:"
  echo -e ""
  echo -e "     -h, --help        显示帮助信息"
  echo -e "     -v, --version     显示版本信息"
}

function versionInfo() { # 打印版本信息
  echo -e "\e[1m$name\e[0m version (\e[1m$major_version-$minor_version.$rel_version\e[0m)"
}
#------------------------- Feature Function
function trim_redis() { # 清理redis
  # 不进入该容器不需要'-it'参数
  docker exec redis redis-cli -n 1 XTRIM data_stream MAXLEN 5000
}

####################################################################
#++++++++++++++++++++++++++++++ Main ++++++++++++++++++++++++++++++#
####################################################################
TEMP=$(getopt --options ":r:lhv" --longoptions "sync:list,help,version" -n "$name" -- "$@")
eval set -- "$TEMP"

funcs=$(grep '^function' "$0")

if [[ ${#@} -lt 2 ]]; then
  helpInfo
  exit $err_param
else
  while true; do
    case $1 in
    -r | --run)
      if [[ $funcs =~ $2'()' ]]; then
        echo -e ">>> Executing $2 function ..."
        $2
        exit $normal
      else
        echo -e "'$2' function not found\n"
        echo -e 'Available functions are:'
        echo -e "$funcs"
        exit $err_param
      fi
      ;;
    -l | --list)
      echo -e "$funcs"
      exit $normal
      ;;
    -h | --help)
      helpInfo
      exit $normal
      ;;
    -v | --version)
      versionInfo
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
