import os

autorandr_profile = os.popen(
    "autorandr | grep '(current)' | awk '{print $1}'").read().strip()


if autorandr_profile == 'casa':
    print("Profile: casa")
    os.system('MONITOR=DP-1 polybar herbstluftwm_0' + ' &')
else:
    print("Profile: not casa")
    os.system('MONITOR=DP-0 polybar herbstluftwm_0' + ' &')

