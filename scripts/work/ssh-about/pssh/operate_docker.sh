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
readonly err_unknown=255    # 未知错误

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

function check_doctopus() { # 检测Doctopus数采套件
  # Doctopus数采套件的compose文件
  compose_file_path='/usr/mabo/project/docker'
  compose_files=$(find $compose_file_path -name 'docker-compose*.y*ml')
  # 得到容器启动时间的字符串
  chitu_startedat_str=$(docker inspect chitu --format '{{.State.StartedAt}}')
  redis_startedat_str=$(docker inspect redis --format '{{.State.StartedAt}}')
  # 得到容器启动时间的时间戳
  chitu_startedat_ts=$(date -d "$chitu_startedat_str" +%s)
  redis_startedat_ts=$(date -d "$redis_startedat_str" +%s)
  # 得到时间戳差值的绝对值
  diff=$((chitu_startedat_ts - redis_startedat_ts))
  diff_abs=${diff##*[+-]}
  # 临界值
  critical=600

  # 当指定的两个容器的启动时间的差值的绝对值大于临界值，重启容器
  if [[ $diff_abs -gt $critical ]]; then
    echo -e '>>> Restarting Doctopus ...'
    # 是否存在compose文件
    if [[ $compose_files ]]; then
      # 停止每个compose文件
      for compose_file in $compose_files; do
        docker-compose -f "$compose_file" down
      done
      # 清理volume
      docker volume prune -f
      # 启动每个compose文件
      for compose_file in $compose_files; do
        docker-compose -f "$compose_file" up -d
      done
    else
      echo -e "No compose file"
      exit $err_file
    fi
  else
    echo -e 'Do nothing'
    exit $normal
  fi
}

####################################################################
#++++++++++++++++++++++++++++++ Main ++++++++++++++++++++++++++++++#
####################################################################
TEMP=$(getopt --options ":r:lhv" --longoptions "run:list,help,version" -n "$name" -- "$@")
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
