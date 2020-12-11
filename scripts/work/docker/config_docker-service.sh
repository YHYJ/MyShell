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
# path variable
readonly image_path="./image"
readonly uncompress_path="./cache"
readonly compress_name=$(ls "$image_path")
readonly backup_path="/usr/mabo/resource/docker"

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
  echo -e "     -l, --load        导入$image_path中的image文件"
  echo -e ""
  echo -e "     -h, --help        显示帮助信息"
}

#------------------------- Feature Function
function serviceInfo() {
  cat "./override.conf"
}

function serviceConfig() {
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
  printf '\n%s\n' "docker.service配置完成"
}

function loadImage() {
  if [[ ! -d $uncompress_path ]]; then
    mkdir $uncompress_path
  fi

  printf '\n%s\n' "正在解压image文件"
  for file in $compress_name; do
    bsdtar -xzvpf "$image_path/$file" -C "$uncompress_path"
  done
  printf '\n%s\n' "image文件解压完成"

  printf '\n%s\n' "正在导入image"
  readonly image_name=$(ls "$uncompress_path")
  for image in $image_name; do
    docker load -i "$uncompress_path/$image"
  done
  printf '\n%s\n' "image导入完成"

  printf '\n'
  docker images

  rm -rf $uncompress_path
}

function backupImage() {
  cp -r "$image_path" "$backup_path"
  printf '\n%s\n' "image文件已备份到$backup_path/image"
}

####################################################################
#++++++++++++++++++++++++++++++ Main ++++++++++++++++++++++++++++++#
####################################################################
case $1 in
-d | --display)
  serviceInfo
  ;;
-c | --config)
  serviceConfig
  ;;
-l | --load)
  loadImage
  backupImage
  ;;
-h | --help)
  helpInfo
  ;;
*)
  helpInfo
  ;;
esac
