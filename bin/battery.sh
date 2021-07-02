#!/bin/sh
CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)

if [ `cat /sys/class/power_supply/ADP1/online` -eq 1 ]
then
    state=
else
    state="⚠"
fi

echo $state $CAPACITY%

exit
