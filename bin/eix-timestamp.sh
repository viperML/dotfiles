#!/bin/bash

function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  printf "Time since last eix-sync: "
  (( $D > 0 )) && printf '%d days ' $D
  printf '%d hours\n' $H
  # (( $M > 0 )) && printf '%d minutes ' $M
  # (( $D > 0 || $H > 0 || $M > 0 )) && printf 'and '
  # printf '%d seconds\n' $S
}

current_epoch="$(date +%s)"
old_epoch="$(cat /var/cache/eix-timestamp/timestamp)"
diff_epoch=$((current_epoch - old_epoch))


displaytime diff_epoch
