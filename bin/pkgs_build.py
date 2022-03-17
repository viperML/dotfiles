#!/usr/bin/env python3
import subprocess
from pathlib import Path
from typing import Optional

dry = True
root_dir = Path(__file__).parent.parent

def build(folder: str, namespace: Optional[str]):
    for p in Path(root_dir / "overlays" / folder).iterdir():
        if p.is_dir():
            cmd = f"nix build {root_dir}#"
            if namespace:
                cmd += f"{namespace}."
            cmd += f"{p.name} --out-link {root_dir / 'results' / p.name}"
            print(f"$ {cmd}")
            if not dry:
                subprocess.run(cmd.split(" "), check=True)

for p in Path(root_dir / "overlays").iterdir():
    if "pkgs" in p.name:
        n = p.name.split("-")
        try:
            build(folder=n[0], namespace=n[1])
        except IndexError:
            build(folder=n[0], namespace=None)
