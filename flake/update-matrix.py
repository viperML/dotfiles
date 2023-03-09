from pathlib import Path
import os

try:
    flake_root = Path(os.environ["FLAKE"])
except KeyError:
    flake_root = Path(os.environ["PWD"])


nv_files = [
    str(g.relative_to(flake_root).parent)
    for nv_file in ["nvfetcher", "sources"]
    for g in flake_root.glob(f"**/{nv_file}.toml")
]

print(nv_files)
