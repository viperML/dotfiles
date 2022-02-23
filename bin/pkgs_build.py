#!/usr/bin/env python3
import argparse
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser(description='Parse a list of packages')
parser.add_argument('file', help='The file to parse')
args = parser.parse_args()

path = Path(args.file).resolve()

all_pkgs = []

context = ""
for line in path.read_text().splitlines():

    if "libsForQt5" in line:
        context = "libsForQt5."
    elif "gnomeExtensions" in line:
        context = "gnomeExtensions."

    if ' = callPackage' in line:
        pkg = line.split(' = ')[0].strip()

        all_pkgs.append(context + pkg)

subprocess.call(["mkdir", "-p", "results"])
for pkg in all_pkgs:
    print(f"Building {pkg}")
    subprocess.call([
        "nix", "build", f".#pkgs.{pkg}", "--out-link", f"results/{pkg}"
    ])
