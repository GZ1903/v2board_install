# V2board一键部署

**脚本适用于操作系统：CentOS7.X/RedHat7.X部署，内存1G内存，磁盘容量大于5G,部署环境最好使用单独的服务器，避免环境冲突。**

#### 环境介绍：

```shell
Nginx   1.20.2
Mysql   5.6.51
PHP     7.3.33
redis   6.2.2
```
> 测试1H1G机器部署，170s左右即可。请使用centos7系列纯净主机部署。


#### 软件版本：

```
V2board 1.5.5
```

#### 一键部署脚本：

```shell
yum -y install git wget && git clone https://gitee.com/gz1903/v2board_install.git /usr/local/src/v2board_install && cd /usr/local/src/v2board_install && chmod +x v2board_install.sh && ./v2board_install.sh
```

#### 安装过程：

自定义数据库密码：

```shell
####################################################################
#                     欢迎使用V2board一键部署脚本                     #
#                脚本适配环境CentOS7+/RetHot7+、内存1G+               #
#                更多信息请访问 https://gz1903.github.io             #
####################################################################

请输入Mysql数据库root密码:(自定义)
```

> 执行官方脚本安装过程需要执行yes
>
> ![y](https://cdn.jsdelivr.net/gh/gz1903/tu/a39ca9cd020e695f36612ed2dccdb0cb.png)

```shell
Running 2.0.13 (2021-04-27 13:11:08) with PHP 7.3.33 on Linux / 3.10.0-1160.el7.x86_64
Do not run Composer as root/super user! See https://getcomposer.org/root for details
Continue as root/super user [yes]? y
```

`需要拉取gitgub资源，国内网络较慢，或者下载失败，请确保网络通畅`



#### 输入安装信息：

数据库地址：localhost

数据库：v2board

数据库用户名：root

其他自定义。

```shell
__     ______  ____                      _  
\ \   / /___ \| __ )  ___   __ _ _ __ __| | 
 \ \ / /  __) |  _ \ / _ \ / _` | '__/ _` | 
  \ V /  / __/| |_) | (_) | (_| | | | (_| | 
   \_/  |_____|____/ \___/ \__,_|_|  \__,_| 

 请输入数据库地址（默认:localhost） [localhost]:
 > localhost

 请输入数据库名:
 > v2board

 请输入数据库用户名:
 > root

 请输入数据库密码:
 > 开始自定义的密码       

正在导入数据库请稍等...
数据库导入完成

 请输入管理员邮箱?:
 > v2board@qq.com

 请输入管理员密码?:
 > 自定义

一切就绪
访问 http(s)://你的站点/admin 进入管理面板

```



#### 完成安装

```shell
--------------------------- 安装已完成 ---------------------------
##################################################################
#                            V2board                             #
##################################################################
 数据库用户名   :root
 数据库密码     :
 网站目录       :/usr/share/nginx/html/v2board 
 Nginx配置文件  :/etc/nginx/conf.d/v2board.conf 
 PHP配置目录    :/etc/php.ini 
 内网访问       :http://
 外网访问       :http://
 安装日志文件   :/var/log/V2board_install_2021-12-10_17:15:09.log
------------------------------------------------------------------
 如果安装有问题请反馈安装日志文件。
 使用有问题请在这里寻求帮助:https://gz1903.github.io
 电子邮箱:v2board@qq.com
------------------------------------------------------------------
```


#### 主界面
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/0761a10fc7ec8db631493bf2ce455aad.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/c1c18e8cb08ee3ad7b4ce73c5f06d0ee.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/7f9d07a7d96dec7e07cf9de88c9e0c9a.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/6c90fee3362f6874ea96f64fe469a2ab.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/6c88a680e8bfd55e2c1d48f90839a8b7.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/07d87e6ddbaa2a974f061ae282a2d970.png)

#### 前台登录界面：

![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/30c58ac51674dc8df9a9f038302a1655.png)

#### 后台登录界面：

![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/144e26a3abb8a0b452fc235aed2be168.png)

#### 前台界面：

![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/5a7f75412aa261c360c3bf340e9a7246.png)
