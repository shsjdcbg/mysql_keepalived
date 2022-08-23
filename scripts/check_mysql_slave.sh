#!/bin/bash
LOGDIR=/var/log/keepalived
LOGFILE="/var/log/keepalived/notify_scripts.log"
[ -d $LOGDIR ] || mkdir $LOGDIR

counter=$(netstat -na|grep "LISTEN"|grep "3306"|wc -l)
if [ "${counter}" -eq 0 ]; then
    echo "`date '+%b  %d %T %a'` $HOSTNAME [check_mysql]: no mysql running" >>$LOGFILE
     exit 0
else
    echo "`date '+%b  %d %T %a'` $HOSTNAME [check_mysql]: mysql running" >>$LOGFILE
     exit 0
fi