import os
import subprocess

try:
    updates_aur = subprocess.check_output(['paru', '-Qu']).decode('utf-8').splitlines()
    for pkg in updates_aur:
        if not ('ignored' in pkg):
            print(pkg)
except subprocess.CalledProcessError:
    updates_aur = []

