import sys
from pathlib import Path
import os
import subprocess

try:
    flake_root = Path(os.environ["FLAKE"])
except KeyError:
    flake_root = Path(os.environ["PWD"])

subdir = flake_root / sys.argv[1]

if (nv_config := subdir / "nvfetcher.toml").exists():
    nv_config = nv_config
else:
    nv_config = subdir / "sources.toml"

print(nv_config)


subprocess.run(
    ["nvfetcher", "--build-dir", subdir, "--config", nv_config], check=True
)
