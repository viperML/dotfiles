import os
import subprocess


def screens():
    output = [l for l in subprocess.check_output(
        ["xrandr"]).decode("utf-8").splitlines()]
    dictionary = {}
    for string in output:
        if " connected" in string:
            if "primary" in string:
                dictionary = {**dictionary, string.split()[0]: "0"}
            else:
                dictionary = {**dictionary, string.split()[0]: "1"}
    return dictionary


current_screens = screens()
os.system('pkill polybar')
os.system('pkill multiload-ng-sy')

for screen in current_screens:
    os.system('MONITOR=' + screen + ' polybar herbstluftwm_' +
              current_screens[screen] + ' &')
os.system('multiload-ng-systray')
