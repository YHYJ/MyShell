# README

使用`python-pssh`批量并行操作ssh

---

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [环境搭建](#环境搭建)
* [操作](#操作)
    * [批量传输文件](#批量传输文件)
    * [批量执行命令](#批量执行命令)

<!-- vim-markdown-toc -->

---

中间机：被管理的电脑设备
管理机：管理每个中间机的电脑

---

## 环境搭建

1. 在管理机安装`python-pssh`
2. 在管理机使用`ssh-keygen`生成RSA密钥对
3. 使用命令`ssh-copy-id -i ~/.ssh/id_rsa.pub [user@]host[:port]`将公钥传给中间机

## 操作

### 批量传输文件

使用命令`psshscp -h edge_ip_geely.list -l [USER] [Local File] [Remote Path]`将本地文件'[Local File]'拷贝到'edge_ip_geely.list'中列出的每个设备上的'[Remote Path]'路径

其中参数含义为：

-h：指定中间机的hostname或ip
-l：指定登录每个中间机用的用户名

'edge_ip_geely.list'格式为：

```shell
127.0.0.1
192.168.0.1
```

### 批量执行命令

使用命令`pssh -h edge_ip_geely.list -l [USER] -i [CMD]`在文件'edge_ip_geely.list'中列出的每个设备上执行'CMD'

其中参数含义为：

-h：指定中间机的hostname或ip
-l：指定登录每个中间机用的用户名
-i：指定要在每个中间机上执行的命令

'edge_ip_geely.list'格式为：

```shell
127.0.0.1
192.168.0.1
```
