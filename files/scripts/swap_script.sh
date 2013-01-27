#!/bin/sh

SWAP_ON=0
SWAP_PATH=/media/hdd
SWAP_SIZE=8192
SWAP_FILE=/swapfile

SWAP_NAME=$SWAP_PATH$SWAP_FILE

case "$1" in
    start)
	if [ $SWAP_ON -ne 0 ]; then
		if [ ! -f $SWAP_NAME ]; then
			echo "ERROR: $SWAP_NAME is missing."
			exit 1
		else
			echo -n "starting SWAP... "
			/sbin/swapon $SWAP_NAME
			echo "done."
		fi
	fi
	;;
    stop)
	echo -n "stopping SWAP... "
	/sbin/swapoff $SWAP_NAME
	echo "done."
	;;
    create)
	echo -n "create SWAP... "
	dd if=/dev/zero of=$SWAP_NAME bs=1024 count=$SWAP_SIZE
	mkswap $SWAP_NAME
	echo "done."
	;;
    delete)
	$0 stop
	echo -n "delete SWAP... "
	rm -rf $SWAP_NAME
	echo "done."
	;;
    *)
	echo "Usage: $0 {start|stop|create|delete}"
	exit 1
	;;
esac

exit 0
