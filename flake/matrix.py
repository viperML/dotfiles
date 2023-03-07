import json
import subprocess
import os
import logging
from functools import reduce
from concurrent.futures.thread import ThreadPoolExecutor
import asyncio

try:
    flake_root = os.environ["FLAKE"]
except KeyError as e:
    logging.warning(e)
    exit(1)

flake = json.loads(
    subprocess.run(
        ["nix", "flake", "show", "--json", flake_root], check=True, capture_output=True
    ).stdout.decode()
)

system = subprocess.run(
    ["nix", "eval", "--raw", "--impure", "--expr", "builtins.currentSystem"],
    check=True,
    capture_output=True,
).stdout.decode()


async def flakeref_cached(flakeref: str) -> bool:
    return True


all_outputs = list()


async def main():
    for flake_filter in [["checks", system]]:
        outputs = [*reduce(lambda f, o: f.get(o), flake_filter, flake)]
        outputs = [*map(lambda o: ".".join([*flake_filter, o]), outputs)]

        flakerefs = [*map(lambda o: f"{flake_root}#{o}", outputs)]

        cached_futures = [*map(flakeref_cached, flakerefs)]

        async with asyncio.TaskGroup() as tg:
            cached_futures = [*map(lambda c: tg.create_task(c), cached_futures)]
            pass

        outputs_filtered = [
            o for (o, c) in zip(outputs, cached_futures) if (c.result())
        ]

        all_outputs.extend(outputs_filtered)


asyncio.run(main())

print(f"::set-output name=packages::{all_outputs}")
