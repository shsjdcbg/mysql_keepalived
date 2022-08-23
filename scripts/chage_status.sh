#!/bin/bash
CHK_VIP=`ip addr| awk -F"[ :]+" '/192.168.107.150/{print $3}'`
if [ "$CHK_VIP" == "" ];then
cp -rf /etc/keepalived/scripts/check_mysql_slave.sh /etc/keepalived/scripts/check_mysql.sh
else
cp -rf /etc/keepalived/scripts/check_mysql_master.sh /etc/keepalived/scripts/check_mysql.sh
fi
