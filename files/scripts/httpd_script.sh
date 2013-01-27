#!/bin/sh
NAME=httpd
DESC="Busybox HTTP Daemon"
HTTP_ON=0
HTTPROOT=/usr/www
HTTPPORT=8047
HTTPCONF=/var/etc/httpd.conf
ARGS="-h $HTTPROOT -p $HTTPPORT -c $HTTPCONF"

if [ -f /usr/sbin/httpd ]
then
	DAEMON=/usr/sbin/httpd
else
	DAEMON=/sbin/httpd
fi

test -f $DAEMON || exit 0

set -e

case "$1" in
    start)
	if [ ! -d $HTTPROOT ]; then
		echo "$HTTPROOT is missing."
		exit 1
	fi
	if [ $HTTP_ON -ne 0 ]; then
		echo -n "starting $DESC: $NAME... "
		start-stop-daemon -S -b -n $NAME -a $DAEMON -- $ARGS
		echo "done."
	fi
	;;
    start2)
	if [ ! -d $HTTPROOT ]; then
		echo "$HTTPROOT is missing."
		exit 1
	fi
	echo -n "starting $DESC: $NAME... "
	start-stop-daemon -S -b -n $NAME -a $DAEMON -- $ARGS
	echo "done."
	;;
    stop)
        echo -n "stopping $DESC: $NAME... "
	start-stop-daemon -K -n $NAME
	echo "done."
	;;
    restart)
        echo "restarting $DESC: $NAME... "
 	$0 stop
	$0 start
	echo "done."
	;;
    reload)
    	echo -n "reloading $DESC: $NAME... "
    	killall -HUP $(basename ${DAEMON})
	echo "done."
	;;
    *)
	echo "Usage: $0 {start|stop|restart|reload}"
	exit 1
	;;
esac

exit 0
