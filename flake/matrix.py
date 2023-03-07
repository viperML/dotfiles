import asyncio
import json
import os
import subprocess
import re

import aiohttp

try:
    flake_root = os.environ["FLAKE"]
except KeyError:
    flake_root = os.environ["PWD"]

system = subprocess.run(
    ["nix", "eval", "--raw", "--impure", "--expr", "builtins.currentSystem"],
    check=True,
    capture_output=True,
).stdout.decode()

flake_filters = [f"checks.{system}"]


def store_hash(path):
    return re.search(r"/nix/store/(\w+)-", path).group(1)


async def hash_cached(hash, session) -> bool:
    narinfo = f"https://viperml.cachix.org/{hash}.narinfo"

    async with session.get(narinfo) as response:
        if response.status == 200:
            return True
        else:
            return False


all_outputs = list()


async def main():
    for flake_filter in flake_filters:
        outputs: dict[str, str] = json.loads(
            subprocess.run(
                [
                    "nix",
                    "eval",
                    "--raw",
                    f"{flake_root}#{flake_filter}",
                    "--apply",
                    "filter: builtins.toJSON (builtins.mapAttrs (_: value: value.outPath) filter)",
                ],
                check=True,
                capture_output=True,
            ).stdout.decode()
        )

        outputs = {key: store_hash(value) for key, value in outputs.items()}

        async with aiohttp.ClientSession() as session:
            outputs = {k: hash_cached(v, session) for k, v in outputs.items()}
            async with asyncio.TaskGroup() as tg:
                results = {k: tg.create_task(v) for k, v in outputs.items()}

        results_filtered = [f"{flake_filter}.{k}" for k, v in results.items() if not v.result()]
        all_outputs.extend(results_filtered)


asyncio.run(main())

print(all_outputs)
