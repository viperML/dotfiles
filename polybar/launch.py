import os

# primary_monitor = os.popen(
#     "xrandr | grep ' primary' | awk '{print$1}'").read().strip()
# print(primary_monitor)

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

for screen in current_screens:
    os.system('MONITOR=' + screen + ' polybar herbstluftwm_' +
              current_screens[screen] + ' &')
# autorandr_profile = os.popen(
#     "autorandr | grep '(current)' | awk '{print $1}'").read().strip()


# if autorandr_profile == 'casa':
#     print("Profile: casa")
#     os.system('MONITOR=DP-1 polybar herbstluftwm_0' + ' &')
#     os.system('MONITOR=DP-0 polybar herbstluftwm_1' + ' &')
# else:
#     print("Profile: not casa")
#     os.system('MONITOR=DP-0 polybar herbstluftwm_0' + ' &')
