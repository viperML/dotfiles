#!/usr/bin/env python3
import json
import os
import subprocess
from pathlib import Path

try:
    dry = os.environ["DRY"]
except KeyError:
    dry = False

print(f"{dry = }")

root_dir = Path(__file__).parent.parent


def build(output: str):
    subprocess.check_output(f"mkdir -p {root_dir}/results", shell=True)
    cmd = f"nix build {root_dir}#{output} --out-link {root_dir}/results/{output}"
    print(f"$ {cmd}")
    if not dry:
        subprocess.check_output(cmd, shell=True)


# Load flake info from json command
flake_info = json.loads(subprocess.check_output("nix flake show --json", shell=True))

for package in flake_info["packages"]["x86_64-linux"]:
    build(package)

extra_targets = [
    "devShells.x86_64-linux.default",
]

for target in extra_targets:
    build(target)
