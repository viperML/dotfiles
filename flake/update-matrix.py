from pathlib import Path
import os

try:
    flake_root = Path(os.environ["FLAKE"])
except KeyError:
    flake_root = Path(os.environ["PWD"])


nv_files = [str(f.relative_to(flake_root).parent) for f in flake_root.glob("**/generated.json")]

print(nv_files)
