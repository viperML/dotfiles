import subprocess
from pathlib import Path
import json
import os

# Read the DRY environemt variable
try:
    dry = os.environ['DRY']
except KeyError:
    dry = False

# Read flake.lock as json
with open(Path("./flake.lock")) as f:
    flake = json.load(f)

# Get the nixpkgs revision
nixpkgs_rev = flake["nodes"]["nixpkgs"]["locked"]["rev"]

# Create the results folder
Path("./results").mkdir(parents=True, exist_ok=True)

def bundle(bundler: str):
    cmd = f"nix bundle --bundler github:NixOS/bundlers#bundlers.x86_64-linux.{bundler} --override-input nixpkgs nixpkgs/{nixpkgs_rev} --out-link results/{bundler} .#g-neovim"
    print(f"$ {cmd}")
    if not dry:
        subprocess.run(cmd.split(" "), check=True)

bundle(bundler="toRPM")

drvPath = subprocess.check_output("nix eval --raw .#g-neovim.drvPath".split(" ")).decode()
print(f"{drvPath = }")
with open(Path("results/drvPath"), "w") as f:
    f.write(drvPath)
