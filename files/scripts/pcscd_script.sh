#!/bin/sh
PCSCD_ON=0
DAEMON=/usr/sbin/pcscd
NAME=pcscd
DESC="PCSC Daemon"
PIDFILE=/var/run/pcscd/pcscd.pid
ARGS=""

test -f $DAEMON || exit 0

case "$1" in
    start)
	if [ $PCSCD_ON -ne 0 ]; then
	    echo -n "Starting $DESC: $NAME"
	    start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $DAEMON -- $ARGS
	    echo "."
	    echo "done"
	fi
        ;;
    start2)
	  echo -n "Starting $DESC: $NAME"
	  start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $DAEMON -- $ARGS
	  echo "."
        ;;
    stop)
        echo -n "Stopping $DESC: $NAME"
        start-stop-daemon --stop --quiet --pidfile $PIDFILE --exec $DAEMON
        echo "."
        ;;
    restart)
        $0 stop
        sleep 1
        $0 start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac

exit 0
