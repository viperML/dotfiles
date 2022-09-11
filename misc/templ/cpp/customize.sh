#!/usr/bin/env bash

DIR="$(cd $(dirname $BASH_SOURCE); pwd)"


find $DIR -exec sed -i "s#PNAME#$1" {} \;
