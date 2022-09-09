import asyncio
import json
import logging
import os
import subprocess
from dataclasses import dataclass
from logging import info, warning
from pathlib import Path

import requests

logging.basicConfig(level=logging.INFO)

NIX_SYSTEM = os.getenv("NIX_SYSTEM")
if not NIX_SYSTEM:
    warning("env variable NIX_SYSTEM not set")
    NIX_SYSTEM = "x86_64-linux"
info(f"{NIX_SYSTEM=}")

FLAKE_PATH = (Path(__file__) / ".." / "..").resolve()
info(f"{FLAKE_PATH=}")


flake = json.loads(
    (
        subprocess.run(
            ["nix", "flake", "show", f"{FLAKE_PATH}", "--json"],
            capture_output=True,
            check=True,
        )
    ).stdout.decode()
)


@dataclass
class FlakeOutput:
    name: str
    hash: str | None = None
    outPath: str | None = None
    build: bool = True

    def __post_init__(self) -> None:
        self.logger = logging.getLogger(self.name)
        self.info = self.logger.info
        self.warn = self.logger.warn

    async def check(self) -> None:
        await asyncio.gather(
            self.check_needed(),
            self.check_online(),
        )

    async def check_needed(self) -> None:
        try:
            cmd = f"nix eval {FLAKE_PATH}#{self.name}.__nocachix"
            self.info(f"Running: {cmd}")
            subprocess.run(cmd.split(), check=True, capture_output=True)

            self.build = False
            self.info("cachix_needed: __nocachix SET")
        except subprocess.CalledProcessError:
            self.info("cachix_needed: __nocachix not NOT SET")

    async def check_online(self) -> None:
        cmd = f"nix eval --raw {FLAKE_PATH}#{self.name}.outPath"
        self.info(f"Running: {cmd}")
        self.outPath = (
            subprocess.run(
                cmd.split(),
                check=True,
                capture_output=True,
            )
        ).stdout.decode()

        self.hash = self.outPath[11:43]
        self.info(f"{self.hash=}")

        url = f"https://viperml.cachix.org/{self.hash}.narinfo"
        self.info(f"Querying: {url}")
        response = requests.get(url)

        if response.status_code == 200:
            self.info("Already available in cachix")
            self.build = False
        elif response.status_code == 404:
            self.info("Not available in cachix")
        else:
            raise requests.RequestException(
                f"Unhandled status code {response.status_code}"
            )

        pass


outputs = [FlakeOutput(o) for o in flake["packages"][NIX_SYSTEM]]
# outputs = [FlakeOutput(o) for o in ["adw-gtk3", "awesome", "zzz_home_ayats"]]


async def run_group():
    await asyncio.gather(*[o.check() for o in outputs])

asyncio.run(run_group())

print(
    f"::set-output name=packages::{[f'packages.{NIX_SYSTEM}.{o.name}' for o in outputs if o.build]}"
)
