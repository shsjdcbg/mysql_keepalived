#!/bin/bash
LOGDIR=/var/log/keepalived
LOGFILE="/var/log/keepalived/notify_scripts.log"
IPADDR=`ifconfig ens33 | awk -F"[: ]+" '/inet addr/{print $4}'`
VIP="192.168.107.150"
[ -d $LOGDIR ] || mkdir $LOGDIR

master() {
	ps -ef | awk '/mysql/ && !/awk/{print $2}'  | xargs kill -9
	if [ $? -ne 0 ];then
		echo "`date '+%b  %d %T %a'` $HOSTNAME [keepalived_notify_script]: /etc/init.d/mysqld start..."
		/etc/init.d/mysqld start &>/dev/null
	else
		echo "`date '+%b  %d %T %a'` $HOSTNAME [keepalived_notify_script]: Mysqld is Running..."
	fi

	exit 0
}

backup() {
	ps -ef | awk '/mysql/ && !/awk/{print $2}'  | xargs kill -9
	if [ $? -eq 0 ];then
		echo "`date '+%b  %d %T %a'` $HOSTNAME [keepalived_notify_script]: /etc/init.d/mysqld stop..."
		/etc/init.d/mysqld stop &>/dev/null
	else 
		echo "`date '+%b  %d %T %a'` $HOSTNAME [keepalived_notify_script]: Mysql Server is Not Running..."
	fi
}

notify_master() {
    echo "`date '+%b  %d %T %a'` $HOSTNAME [keepalived_notify_script]: Transition to $1 STATE";
    echo "`date '+%b  %d %T %a'` $HOSTNAME [keepalived_notify_script]: Setup the VIP on eth1 for $VIP";
}

notify_backup() {
    echo "`date '+%b  %d %T %a'` $HOSTNAME [keepalived_notify_script]: Transition to $1 STATE";
    echo "`date '+%b  %d %T %a'` $HOSTNAME [keepalived_notify_script]: removing the VIP on eth1 for $VIP";
}

case $1 in
        master)
                notify_master MASTER >>$LOGFILE
                master >>$LOGFILE
                exit 0
        ;;
        backup)
                notify_backup BACKUP >>$LOGFILE
                backup >>$LOGFILE
                exit 0
        ;;
        fault)
                notify_backup FAULT >>$LOGFILE
		backup >>$LOGFILE
                exit 0
        ;;
        stop)
                notify_backup STOP >>$LOGFILE
                backup >>$LOGFILE
                exit 0
        ;;
        *)
                echo "Usage: `basename $0` {master|backup|fault|stop}"
                exit 1
        ;;
esac
