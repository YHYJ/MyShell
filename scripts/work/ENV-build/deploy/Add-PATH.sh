#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2018-09-20 11:08:21
!
echo ">>>>>>>>>Execute script: $0"


if ! echo "$PATH" | grep /usr/local/python3/bin > /dev/null; then
  if ! grep "export PATH=\"$PATH:/usr/local/python3/bin\"" "$HOME/.bashrc"; then
    echo "[Info]: 正在更新PATH变量..."
    echo 'export PATH="$PATH:/usr/local/python3/bin"' >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
    echo
    echo "[Info]: PATH变量已更新，重启终端生效."
    echo
  fi
else
  echo "[Info]: PATH变量正常."
fi
