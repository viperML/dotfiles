#!/bin/sh

CMD=$(lsblk -f | sed '1d' | sed -n '/sda2/ p')


echo "$CMD"
