#!/usr/bin/env python3
import subprocess
from pathlib import Path
from typing import Optional
import os

try:
    dry = os.environ['DRY']
except KeyError:
    dry = False

print(f"{dry = }")

root_dir = Path(__file__).parent.parent

def build(folder: str, namespace: Optional[str]):
    for p in Path(root_dir / "overlays" / folder).iterdir():
        if p.is_dir():
            cmd = f"nix build {root_dir}#"
            if namespace:
                cmd += f"{namespace}."
                subdir = f"{namespace}.{p.name}"
            else:
                subdir = p.name
            cmd += f"{p.name} --out-link {root_dir / 'results' / subdir}"
            print(f"$ {cmd}")
            if not dry:
                subprocess.run(cmd.split(" "), check=True)

for p in Path(root_dir / "overlays").iterdir():
    if "pkgs" in p.name:
        n = p.name.split(".")
        if len(n) == 1:
            build(p.name, None)
        else:
            build(p.name, n[0])
