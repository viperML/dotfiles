#!/usr/bin/env -S nix shell .#python3Minimal .#nvfetcher --command python3
import logging
import os
import sys
from pathlib import Path
import subprocess

logging.basicConfig(level=logging.INFO)


try:
    rootdir = Path(sys.argv[1])
except IndexError:
    logging.warning("No flake passed as input")
    rootdir = Path(os.getenv("FLAKE"))

logging.info(f"{rootdir=}")
assert rootdir.exists()

NVFETCHER_FILES = [
    "nvfetcher.toml",
    "sources.toml",
]

for dir in (g.parent for g in rootdir.glob("**/generated.json")):
    logging.info(f"Checking {dir=}")
    for filename in NVFETCHER_FILES:
        if (dir / filename).exists():
            logging.info(f"Updating {dir/filename}")
            subprocess.run(
                [
                    "nvfetcher",
                    "--build-dir",
                    dir,
                    "--config",
                    (dir / filename),
                ],
                check=True,
            )
