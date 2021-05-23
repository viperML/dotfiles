import os
import subprocess


try:
    output = subprocess.check_output(['lsblk -f'], shell=True, stderr=subprocess.STDOUT)
except subprocess.CalledProcessError as e:
    output = e.output
output = output.decode('utf-8').splitlines()

UUID = ['69a71c2d-8182-466c-a5a5-d84d615e7d9b']

to_print = []
for line in output:
    split = line.split()
    try:
        if split[3] in UUID:
            to_print = ['  ' + split[0][2:] + ': ' + split[5], *to_print]
    except IndexError:
        pass

print('    '.join(to_print))