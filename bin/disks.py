#!/usr/bin/python
import subprocess
import sys

try:
    output = subprocess.check_output(['lsblk -f'], shell=True, stderr=subprocess.STDOUT)
except subprocess.CalledProcessError as e:
    output = e.output
output = output.decode('utf-8').splitlines()

CODES = {
    '7a0abe38-85d5-4221-bfed-f696f1802798': 'data',
    'C0AF-1964': 'EFI'
}

to_print = []
for line in output:
    split = line.split()
    try:
        if split[3] in CODES:
            to_print = ['  ' + CODES[split[3]] + ': ' + split[5], *to_print]
    except IndexError:
        pass

print('    '.join(to_print))
