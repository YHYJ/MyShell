#!/usr/bin/env bash

: << !
Name: install-nginx.sh
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2022-09-08 22:21:25

Description:

Attentions:
-

Depends:
-
!

sudo apt update

sudo apt install curl gnupg ca-certificates lsb-release ubuntu-keyring

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
  | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null

gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" \
  | sudo tee /etc/apt/sources.list.d/nginx.list

echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
  | sudo tee /etc/apt/preferences.d/99nginx

sudo apt update

sudo apt install nginx

sudo systemctl enable --now nginx

systemctl status nginx

nginx -v
