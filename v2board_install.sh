#!/bin/sh
#
#Date:2021.12.09
#Author:GZ
#Mail:V2board@qq.com

process()
{
install_date="V2board_install_$(date +%Y-%m-%d_%H:%M:%S).log"
printf "
\033[36m#######################################################################
#                     欢迎使用V2board一键部署脚本                     #
#                脚本适配环境CentOS7+/RetHot7+、内存1G+               #
#                更多信息请访问 https://gz1903.github.io              #
#######################################################################\033[0m
"

while :; do echo
    read -p "请输入Mysql数据库root密码: " Database_Password 
    [ -n "$Database_Password" ] && break
done

# 从接收信息后开始统计脚本执行时间
START_TIME=`date +%s`


echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#                  正在关闭SElinux策略 请稍等~                        #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
setenforce 0
#临时关闭SElinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
#永久关闭SElinux

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#                  正在配置Firewall策略 请稍等~                       #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
firewall-cmd --zone=public --list-ports
#放行TCP80、443端口


echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#                 正在下载安装包，时间较长 请稍等~                    #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
# 下载安装包
git clone https://gitee.com/gz1903/lnmp_rpm.git /usr/local/src/lnmp_rpm
cd /usr/local/src/lnmp_rpm
# 安装nginx，mysql，php，redis
echo -e "\033[36m下载完成，开始安装~\033[0m"
rpm -ivhU /usr/local/src/lnmp_rpm/*.rpm --nodeps --force --nosignature
 
# 启动nmp
systemctl start php-fpm.service mysqld redis

# 加入开机启动
systemctl enable php-fpm.service mysqld nginx redis

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#                   正在配置Mysql数据库 请稍等~                       #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
mysqladmin -u root password "$Database_Password"
echo "---mysqladmin -u root password "$Database_Password""
#修改数据库密码
mysql -uroot -p$Database_Password -e "CREATE DATABASE v2board CHARACTER SET utf8 COLLATE utf8_general_ci;"
echo $?="正在创建v2board数据库"

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#                    正在配置PHP.ini 请稍等~                          #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
sed -i "s/post_max_size = 8M/post_max_size = 32M/" /etc/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 600/" /etc/php.ini
sed -i "s/max_input_time = 60/max_input_time = 600/" /etc/php.ini
sed -i "s#;date.timezone =#date.timezone = Asia/Shanghai#" /etc/php.ini
# 配置php-sg11
mkdir -p /sg
wget -P /sg/  https://cdn.jsdelivr.net/gh/gz1903/sg11/Linux%2064-bit/ixed.7.3.lin
sed -i '$a\extension=/sg/ixed.7.3.lin' /etc/php.ini
#修改PHP配置文件
echo $?="PHP.inin配置完成完成"

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#                    正在配置Nginx 请稍等~                            #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
cp -i /etc/nginx/conf.d/default.conf{,.bak}
cat > /etc/nginx/conf.d/default.conf <<"eof"
server {
    listen       80;
    root /usr/share/nginx/html/v2board/public;
    index index.html index.htm index.php;

    error_page   500 502 503 504  /50x.html;
    #error_page   404 /404.html;
    #fastcgi_intercept_errors on;

    location / {
        try_files $uri $uri/ /index.php$is_args$query_string;
    }
    location = /50x.html {
        root   /usr/share/nginx/html/v2board/public;
    }
    #location = /404.html {
    #    root   /usr/share/nginx/html/v2board/public;
    #}
    location ~ \.php$ {
        root           html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /usr/share/nginx/html/v2board/public/$fastcgi_script_name;
        include        fastcgi_params;
    }
    location /downloads {
    }
    location ~ .*\.(js|css)?$
    {
        expires      1h;
        error_log off;
        access_log /dev/null;
    }
}
eof

cat > /etc/nginx/nginx.conf <<"eon"

user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    #fastcgi_intercept_errors on;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
eon

mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/v2board.conf

# 创建php测试文件
touch /usr/share/nginx/html/phpinfo.php
cat > /usr/share/nginx/html/phpinfo.php <<eos
<?php
	phpinfo();
?>
eos

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#                    正在部署V2board 请稍等~                          #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
rm -rf /usr/share/nginx/html/v2board
cd /usr/share/nginx/html
# 使用gitee加速下载，更多信息请访问https://github.com/v2board/v2board
git clone https://gitee.com/gz1903/v2board.git
cd /usr/share/nginx/html/v2board
echo -e "\033[36m请输入y确认安装： \033[0m"
sh /usr/share/nginx/html/v2board/init.sh
git clone https://gitee.com/gz1903/v2board-theme-LuFly.git /usr/share/nginx/html/v2board/public/LuFly
mv /usr/share/nginx/html/v2board/public/LuFly/* /usr/share/nginx/html/v2board/public/
chmod -R 777 /usr/share/nginx/html/v2board
# 添加定时任务
echo "* * * * * root /usr/bin/php /usr/share/nginx/html/v2board/artisan schedule:run >/dev/null 2>/dev/null &" >> /etc/crontab
# 安装Node.js
curl -sL https://rpm.nodesource.com/setup_10.x | bash -
yum -y install nodejs
npm install -g n
n 17
node -v
# 安装pm2
npm install -g pm2
# 添加守护队列
pm2 start /usr/share/nginx/html/v2board/pm2.yaml --name v2board
# 保存现有列表数据，开机后会自动加载已保存的应用列表进行启动
pm2 save
# 设置开机启动
pm2 startup

#获取主机内网ip
ip="$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')"
#获取主机外网ip
ips="$(curl ip.sb)"

systemctl restart php-fpm mysqld redis && nginx
echo $?="服务启动完成"
# 清除缓存垃圾
rm -rf /usr/local/src/v2board_install
rm -rf /usr/local/src/lnmp_rpm
rm -rf /usr/share/nginx/html/v2board/public/LuFly

# V2Board安装完成时间统计
END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo -e "\033[36m本次安装使用了$EXECUTING_TIME S!\033[0m"

echo -e "\033[32m--------------------------- 安装已完成 ---------------------------\033[0m"
echo -e "\033[32m##################################################################\033[0m"
echo -e "\033[32m#                            V2board                             #\033[0m"
echo -e "\033[32m##################################################################\033[0m"
echo -e "\033[32m 数据库用户名   :root\033[0m"
echo -e "\033[32m 数据库密码     :"$Database_Password
echo -e "\033[32m 网站目录       :/usr/share/nginx/html/v2board \033[0m"
echo -e "\033[32m Nginx配置文件  :/etc/nginx/conf.d/v2board.conf \033[0m"
echo -e "\033[32m PHP配置目录    :/etc/php.ini \033[0m"
echo -e "\033[32m 内网访问       :http://"$ip
echo -e "\033[32m 外网访问       :http://"$ips
echo -e "\033[32m 安装日志文件   :/var/log/"$install_date
echo -e "\033[32m------------------------------------------------------------------\033[0m"
echo -e "\033[32m 如果安装有问题请反馈安装日志文件。\033[0m"
echo -e "\033[32m 使用有问题请在这里寻求帮助:https://gz1903.github.io\033[0m"
echo -e "\033[32m 电子邮箱:v2board@qq.com\033[0m"
echo -e "\033[32m------------------------------------------------------------------\033[0m"

}
LOGFILE=/var/log/"V2board_install_$(date +%Y-%m-%d_%H:%M:%S).log"
touch $LOGFILE
tail -f $LOGFILE &
pid=$!
exec 3>&1
exec 4>&2
exec &>$LOGFILE
process
ret=$?
exec 1>&3 3>&-
exec 2>&4 4>&-
