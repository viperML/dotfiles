#!/bin/env python3

import subprocess
import operator
from colorama import Fore
from datetime import date, datetime

def parse_boot() -> list:
    ebm_output = subprocess.check_output("efibootmgr -u -v", shell=True).decode("utf-8").splitlines()

    pointer = -1

    output = []

    for line in ebm_output:
        if "Boot00" in line:
            pointer += 1
            output.append([])

        if pointer >= 0 and line:

            output[pointer] = [*output[pointer], *line.replace('\t', ' ').split(' ')]

    for i, entry in enumerate(output):
        output[i][0] = output[i][0].replace('Boot', '').replace('*', '')

    return output


def main():

    VENDOR = "Gentoo"

    KERNEL_ARGS = r"""
root=PARTUUID=5ca5c883-b2b0-1f4a-aeca-d1c2c23e06a3
initrd=\intel-uc.img
initrd=\EFI\Gentoo\initramfs.img
quiet
splash
vt.global_cursor_default=0
nvidia-drm.modeset=1
zswap.enabled=1
zswap.compressor=lz4
""".replace("\n", " ").strip()

    name = VENDOR + "_" + date.today().strftime("%Y%m%d") + "_" + datetime.now().strftime("%H%M")

    # Convert newlines into white space
    # Trim leading and trailing whitespace

    # Get a list of installed bootloaders and delete oldest one
    boot_entries =  parse_boot()
    boot_entries = sorted(boot_entries, key=operator.itemgetter(1))

    for i, entry in enumerate(boot_entries):

        if i == 0:
            print(">>> [ " + Fore.RED + "D" + Fore.RESET + " ] " + Fore.RED, end="\n")
        else:
            print(">>> [ " + Fore.WHITE + " " + Fore.RESET + " ] " + Fore.WHITE, end="\n")

        for line in entry:
            print("" + line)

        print(Fore.RESET)



    print(">>> [ " + Fore.GREEN + "N" + Fore.RESET + " ] " + Fore.GREEN, end="\n")
    print(name)
    print(KERNEL_ARGS.replace(" ", "\n") + Fore.RESET + "\n")

    command_old = "efibootmgr --bootnum " + boot_entries[0][0] + " --delete-bootnum"
    print("# " + command_old, end="\n\n")

    command_new = "efibootmgr --create --part 1 --disk /dev/nvme0n1 --label " + name + " --loader '\EFI\Gentoo\\bzImage.efi' --unicode '" + KERNEL_ARGS + "' --verbose"
    print("# " + command_new, end="\n\n")


    answer = input("Is this ok [" + Fore.GREEN + "Y" + Fore.RESET + "/" + Fore.RED + "n" + Fore.RESET + "]? ")

    if answer.lower() != "n":
        print("\n>>> Deleting old kernel...")
        output = subprocess.check_output(command_old, shell=True).decode("utf-8").splitlines()
        for line in output:
            print("\t" + line)

        print("\n>>> Registering new kernel...")
        output = subprocess.check_output(command_new, shell=True).decode("utf-8").splitlines()
        for line in output:
            print("\t" + line)




if __name__ == "__main__":
    main()
