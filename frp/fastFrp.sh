#!/bin/sh
vport=$1
domain=$2

cd /root
rm -rf /root/frp
# 下载文件到本地
echo '正在下载解压服务端文件...'
if [ ! -f "frp.zip" ];then wget https://github.com/Zo3i/OCS/raw/master/frp/frp.zip; fi
# 判断是否存在unzip
if command -v unzip >/dev/null 2>&1; then
  echo 'exists'
else
  echo 'no exists'
  yum install -y unzip
fi
unzip frp.zip
cd frp
# 写入配置文件
echo '正在写入配置...'
cat>frps.ini<<EOF
[common]
bind_port = 7000
bind_addr = 0.0.0.0
vhost_http_port = $vport
dashboard_port = 7500
dashboard_user = admin
dashboard_pwd = admin
log_file = ./frps.log
log_level = info
log_max_days = 3
privilege_mode = true
privilege_token = QeWer
max_pool_count = 50
type = http
subdomain_host = $domain
auth_token = token
EOF

chmod -R 777 ./*
# 停止已运行的frp
echo '停止已运行的frp...'
ps -ef|grep frp|grep -v grep|awk '{print $2}'|xargs kill -9
nohup ./frps -c ./frps.ini >/dev/null 2>/dev/null &
echo 'frp已在后台运行！'