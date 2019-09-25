## README

当前目录的**install.sh**是总安装脚本，**pkgs**变量可以改变需要安装的组件.

> 如果组件之间有依赖顺序如2依赖1，数组**pkgs**的元素需要按照<1-2>的顺序填写.

每个组件(name)都有**install-<name>.sh**来进行单独安装.

**python-install中的python安装包需要自己提供**



## TODO & BUG

---

---

### TODO

- [x] 加入超时（总安装超时10秒，分安装超时5秒，总安装默认 N ，分安装默认 Y）
- [ ] 等待提示动效隐藏光标
- [ ] 提示信息着色
    - ​	: 35m             紫色
    - \[Hint]: 34;;4m        蓝色;下划线
    - \[Progress]: 7m      反显
    - \>>>: 32;1m            绿色;加粗
    - \[Error]: 31;1;5m    红色;加粗;闪烁
    - \[Ask]: 36m            青色
- [ ] 使用`install`命令替换复制安装方式的`cp`命令
- [ ] 尽量取消函数里的echo

#### install.sh



#### env-install

- [ ] 加入等待动效


#### python-install

- [ ] configure、make、make install三步曲，是否取消前两步



#### redis-install



####　etcd-install

- [ ] 重写


#### chitu-install

- [ ] 判断服务是否注册、自启、启动

  

---



### BUG

#### install.sh



#### env-install



#### python-install



#### redis-install



#### etcd-install



#### chitu-install

- [ ] install()和register()耦合度太高
- [ ] 服务注册、启动、自启的结果没有进行判断
