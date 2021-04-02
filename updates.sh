#!/bin/bash
checkupdates > /dev/null 2>&1
echo $(yay -Qua | wc -l)
