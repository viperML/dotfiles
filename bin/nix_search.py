#!/usr/bin/env python3
import json
import subprocess

query = ""

pkgs = json.loads(subprocess.check_output(["nix", "search", "--json", "pkgs", query]).decode())

formatted = []
for p in pkgs:
    formatted.append(f"{pkgs[p]['pname']}")

for f in formatted:
    print(f)
