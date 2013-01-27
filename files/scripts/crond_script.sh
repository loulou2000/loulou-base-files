#!/bin/sh

CROND_ON=1
NAME=crond
ARGS="-c /etc/cron/crontabs"
DAEMON=/usr/sbin/crond

test -f $DAEMON || exit 0

set -e

case "$1" in
    start)
	if [ $CROND_ON -ne 0 ]; then
		echo -n "starting $NAME... "
		start-stop-daemon -S -b -n $NAME -a $DAEMON -- $ARGS
		echo "done."
	fi
	;;
    start2)
		echo -n "starting $NAME... "
		start-stop-daemon -S -b -n $NAME -a $DAEMON -- $ARGS
		echo "done."
	;;
    stop)
	echo -n "stopping $NAME... "
	start-stop-daemon -K -n $NAME
	echo "done."
	;;
    restart)
	echo -n "restarting $NAME... "
	$0 stop
	$0 start
	echo "done."
	;;
    reload)
	echo -n "reloading $NAME... "
	killall -HUP $(basename ${DAEMON})
	echo "done."
	;;
    *)
	echo "Usage: $0 {start|stop|restart|reload}"
	exit 1
	;;
esac

exit 0
