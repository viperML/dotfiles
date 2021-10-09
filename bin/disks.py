#!/usr/bin/python
from os import sep
import subprocess
import sys
import json

def awesome_format(data: str) -> str:
    icon = ' '
    icon_color = '#707070'

    return "<span foreground='" + icon_color + "'>" + icon + "</span>" + data


def get_disks() -> list:
    result = []

    try:
        output = subprocess.check_output(['lsblk -f -J'], shell=True, stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        output = e.output
    output = output.decode('utf-8')

    disks = json.loads(output)


    # Detect mounted devices
    for block in disks['blockdevices']:
        for partition in block['children']:
            if partition['fsuse%'] is not None:
                # Get data to print

                fsusage_percent = float(partition['fsuse%'].strip('%'))/100

                units = partition['fsavail'][-1]
                fstotal = float(partition['fsavail'][:-1])
                fsusage = round(fstotal * fsusage_percent, 1)

                if partition['label'] is not None:
                    name = partition['label']
                else:
                    name = partition['name']

                result.append(name + ' ' + str(fsusage) + units + '/' + str(fstotal) + units)

    return result

if __name__ == '__main__':
    entries = get_disks()
    # Format each entry element
    results = [awesome_format(entry) for entry in entries]

    print(*results, sep='  ')
