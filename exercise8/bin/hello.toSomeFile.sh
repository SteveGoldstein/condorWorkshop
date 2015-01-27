#!/bin/sh


SLEEP_TIME=$1
HELLO=$2

CLUSTER=$3
PROCESS=$4

echo $HELLO  > someFile.$CLUSTER.$PROCESS
mkdir  someDir.$CLUSTER.$PROCESS
echo $HELLO  > someDir.$CLUSTER.$PROCESS/someOtherFile.$CLUSTER.$PROCESS

ls -l *


sleep $SLEEP_TIME

exit 0
