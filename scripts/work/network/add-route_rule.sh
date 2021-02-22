#!/usr/bin/env bash

: <<!
Name: add-route_rule.sh
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2021-01-13 12:00:09

Description: 添加路由规则

Attentions:
-

Depends:
-
!

ip route add 20.63.1.0/24 via 20.63.2.1 dev enp0s31f6
ip route add 20.63.2.0/24 via 20.63.2.1 dev enp0s31f6
ip route add 20.63.3.0/24 via 20.63.2.1 dev enp0s31f6
ip route add 20.63.4.0/24 via 20.63.2.1 dev enp0s31f6
ip route add 172.22.122.0/24 via 20.63.2.1 dev enp0s31f6
