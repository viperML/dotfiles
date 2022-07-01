#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (p: [p.requests])"
import argparse
import json
import logging
import subprocess

import requests


logging.basicConfig(
    filename="generate_matrix.log", encoding="utf-8", level=logging.DEBUG
)

parser = argparse.ArgumentParser()
parser.add_argument("flake_json", help="Path to flake.json")
parser.add_argument("attribute", help="Attribute name")
args = parser.parse_args()

system = "x86_64-linux"

with open(args.flake_json, "r") as f:
    flake = json.load(f)


def needs_build_flag(output: str) -> bool:
    try:
        subprocess.check_output(
            f"nix eval .#{output}.__nocachix",
            shell=True,
            stderr=subprocess.DEVNULL,
        )
        return False
    except subprocess.CalledProcessError:
        return True


def needs_build_remote(output: str) -> bool:
    nar = subprocess.check_output(
        f"nix eval --raw .#{output}.outPath",
        shell=True,
        stderr=subprocess.DEVNULL,
    ).decode()[11:43]

    response = requests.get(f"https://viperml.cachix.org/{nar}.narinfo")

    if response.status_code == 200:
        return False
    elif response.status_code == 404:
        return True
    else:
        raise Exception(f"Cachix error {response.status_code} for {output}")


targets = list()

for item in flake[args.attribute][system]:
    output = f"{args.attribute}.{system}.{item}"
    logging.debug(f"Checking {output=}")

    if needs_build_flag(output) and needs_build_remote(output):
        targets.append(output)


print(f"::set-output name=packages::{targets}")
