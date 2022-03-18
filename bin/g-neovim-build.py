"""
Build the flake output g-neovim and push to cachix
Try downloading the drvPath from the latest release
If they are not the same, issue a new release
"""
import subprocess
from pathlib import Path
import os
import json


try:
    dry = os.environ['DRY']
except KeyError:
    dry = False

cmd = "nix build .#g-neovim -L"
print(f"$ {cmd}")
if not dry:
    subprocess.run(cmd.split(" "), check=True)

drvPath = subprocess.check_output("nix eval --raw .#g-neovim.drvPath".split(" ")).decode()
print(f"{drvPath = }")
with open(Path("./drvPath"), "w") as f:
    f.write(drvPath)

# Read the command output as json
cmd = 'gh run --repo viperML/dotfiles list --workflow g-neovim-release.yaml --json databaseId'
runs = subprocess.check_output(cmd, shell=True).decode()
print(f"{runs = }")
runs = json.loads(runs)

for r in runs:
    try:
        cmd = f"gh run --repo viperML/dotfiles download {r['databaseId']} -n drvPath -D old"
        subprocess.run(cmd.split(" "), check=True)
        break
    except subprocess.CalledProcessError:
        print(f"Failed to download {r['databaseId']}")

with open("old/drvPath") as f:
    oldDrvPath = f.read()

if oldDrvPath != drvPath:
    print("Requesting new release")
    cmd = "gh workflow run --repo viperML/dotfiles g-neovim-release.yaml --ref master"
    result = subprocess.check_output(cmd, shell=True).decode()
    print(result)
