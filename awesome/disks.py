import os
import subprocess


try:
    output = subprocess.check_output(['df', '-h'], shell=True, stderr=subprocess.STDOUT)
except subprocess.CalledProcessError as e:
    output = e.output
output = output.decode('utf-8').splitlines()

mountpoints = ['/', '/mnt/x', '/mnt/c']

to_print = []
for line in output:
    split = line.split()
    if split[0] != 'df:':
        if split[5] in mountpoints:
            to_print = ['  ' + split[5] + ': ' + split[4], *to_print]

print('    '.join(to_print))