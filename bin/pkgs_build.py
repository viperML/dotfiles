#!/usr/bin/env python3
import subprocess
from pathlib import Path
from typing import Optional

dry = False
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

build(folder="pkgs", namespace=None)
build(folder="pkgs-libsForQt5", namespace="libsForQt5")
build(folder="pkgs-gnomeExtensions", namespace="gnomeExtensions")
