import os
import subprocess

try:
    updates_sys = subprocess.check_output(['checkupdates']).decode('utf-8').splitlines()
except subprocess.CalledProcessError:
    updates_sys = []

try:
    updates_aur = subprocess.check_output(['yay', '-Qu']).decode('utf-8').splitlines()
except subprocess.CalledProcessError:
    updates_aur = []

updates = [*updates_sys, *updates_aur]
print(len(updates))