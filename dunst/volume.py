import os
import subprocess
import re
import sys


def notification():
    command = "pactl list sinks".split(' ')

    r = r"(?:Name: alsa_output\.pci-0000_00_1f\.3\.analog-stereo)(?:[\s\S]){1,}?\/(?: {1,})(\d{1,3})"

    s = subprocess.check_output(command).decode('utf-8')
    result = re.findall(r, s, re.MULTILINE)[0]

    N = int(int(result) / 10)
    bar = ''
    for i in range(N):
        bar = bar + '-'
    for i in range(10 - N):
        bar = bar + ' '
    bar = bar + ''

    dunst_cmd = 'dunstify -a "Volume" -u low -i audio-volume-high -r 991049 "' + bar + '"'

    # print(dunst_cmd)
    os.system(dunst_cmd)


if sys.argv[1] == "up":
    os.system("pactl set-sink-volume @DEFAULT_SINK@ +2%")
elif sys.argv[1] == "down":
    os.system("pactl set-sink-volume @DEFAULT_SINK@ -2%")
