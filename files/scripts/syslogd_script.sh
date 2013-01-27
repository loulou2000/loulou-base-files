#! /bin/sh

set -e

SYSLOGD_ON=0
KLOGD_ON=0
BUFFERSIZE=64
MARKINT=20
REDUCE=0
LOGFILE=/var/log/messages
REMOTE=0
REMOTE_HOST=192.168.0.1
REMOTE_PORT=514

SYSLOGD_BIN=/sbin/syslogd
KLOGD_BIN=/sbin/klogd
# Exit if required binaries are missing.
[ -x $SYSLOGD_BIN ] || exit 0
[ -x $KLOGD_BIN ] || exit 0

case "$1" in
  start)
	if [ $SYSLOGD_ON -ne 0 ]; then
		if [ $BUFFERSIZE -ne 0 ]; then
			SYSLOG_ARGS="$SYSLOG_ARGS -C$BUFFERSIZE"
		fi
		if [ $MARKINT -ne 0 ]; then
			SYSLOG_ARGS="$SYSLOG_ARGS -m $MARKINT"
		fi
		if [ $REDUCE -ne 0 ]; then
			SYSLOG_ARGS="$SYSLOG_ARGS -S"
		fi
		if [ -n "$LOGFILE" ]; then
			SYSLOG_ARGS="$SYSLOG_ARGS -O $LOGFILE"
		fi
		if [ $REMOTE -ne 0 ]; then
			if [ -n "$REMOTE_HOST" -a $REMOTE_PORT -ne 0 ]; then
				SYSLOG_ARGS="$SYSLOG_ARGS -R $REMOTE_HOST:$REMOTE_PORT"
			fi
		fi
		echo -n "Starting syslogd "
		start-stop-daemon -S -b -n syslogd -a $SYSLOGD_BIN -- -n $SYSLOG_ARGS
		if [ $KLOGD_ON -ne 0 ]; then
			echo -n "klogd "
			start-stop-daemon -S -b -n klogd -a $KLOGD_BIN -- -n
		fi
		echo "done"
	fi
	;;
  start2)
		if [ $BUFFERSIZE -ne 0 ]; then
			SYSLOG_ARGS="$SYSLOG_ARGS -C$BUFFERSIZE"
		fi
		if [ $MARKINT -ne 0 ]; then
			SYSLOG_ARGS="$SYSLOG_ARGS -m $MARKINT"
		fi
		if [ $REDUCE -ne 0 ]; then
			SYSLOG_ARGS="$SYSLOG_ARGS -S"
		fi
		if [ -n "$LOGFILE" ]; then
			SYSLOG_ARGS="$SYSLOG_ARGS -O $LOGFILE"
		fi
		if [ $REMOTE -ne 0 ]; then
			if [ -n "$REMOTE_HOST" -a $REMOTE_PORT -ne 0 ]; then
				SYSLOG_ARGS="$SYSLOG_ARGS -R $REMOTE_HOST:$REMOTE_PORT"
			fi
		fi
		echo -n "Starting syslogd "
		start-stop-daemon -S -b -n syslogd -a $SYSLOGD_BIN -- -n $SYSLOG_ARGS
		echo -n "klogd "
		start-stop-daemon -S -b -n klogd -a $KLOGD_BIN -- -n
		echo "done"
	;;
  stop)
	echo "Stopping syslogd/klogd: "
	start-stop-daemon --stop --quiet --name syslogd --user 0
	start-stop-daemon --stop --quiet --name klogd --user 0
	echo "done"
	;;
  restart)
  	$0 stop
	$0 start
	;;
  *)
	echo "Usage: syslog { start | stop | restart }" >&2
	exit 1
	;;
esac

exit 0
