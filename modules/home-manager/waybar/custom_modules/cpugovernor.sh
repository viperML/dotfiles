#!/bin/bash
if [ `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`="performance" ]; then
	echo '{"text": "perf", "alt": "perf", "class": "performance", "tooltip": "<b>Governor</b> Performance"}'
	#echo ''
elif [ `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`="schedutil" ]; then
	echo '{"text": "sched", "class": "schedutil", "tooltip": "<b>Governor</b> Schedutil"}'
fi