#!/usr/bin/env bash

: <<!
Name: config_docker-service.sh
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2020-09-19 14:56:43

Description: 修改docker.service的配置

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

#------------------------- Parameter Variable
# description variable
readonly desc="用来配置Docker Root Dir"

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
  echo -e "     -d, --display     仅显示新的docker.service内容"
  echo -e "     -c, --config      将新的docker.service写入配置文件"
  echo -e ""
  echo -e "     -h, --help        显示帮助信息"
}

#------------------------- Feature Function
function sevInfo() {
  cat "./override.conf"
}

function sevConfig() {
  printf '\n%s\n' "正在配置docker.service"
  if [[ -d "/etc/systemd/system/docker.service.d" ]]; then
    cat "./override.conf" >"/etc/systemd/system/docker.service.d/override.conf"
  else
    mkdir "/etc/systemd/system/docker.service.d"
    cat "./override.conf" >"/etc/systemd/system/docker.service.d/override.conf"
  fi
  printf '\n%s\n' "正在重启docker.service"
  systemctl daemon-reload
  systemctl restart docker
  printf '\n%s\n' "OK"
}

####################################################################
#++++++++++++++++++++++++++++++ Main ++++++++++++++++++++++++++++++#
####################################################################
case $1 in
-d | --display)
  sevInfo
  ;;
-c | --config)
  sevConfig
  ;;
-h | --help)
  helpInfo
  ;;
*)
  helpInfo
  ;;
esac
