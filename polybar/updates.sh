#!/bin/bash
checkupdates > /dev/null 2>&1
CHK=`checkupdates`
CHKAUR="$(yay -Qu)"

if [ ${#CHKAUR} -gt 0 ]; then
  if [ "$CHK" = "" ]; then
    CHK="${CHKAUR}"
  else
    CHK="${CHK}"$'\n'"${CHKAUR}"
  fi
fi

CHK=$(echo "${CHK}" | sort |uniq)
# echo "${CHK}"
N="$(echo "${CHK}" | wc -l)"
# echo "${N}"

while getopts l option
do
  case $option in
    (l)
      echo "${CHK}"
      exit;;
    esac
done

echo "${N}"
exit