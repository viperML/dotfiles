import subprocess
import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument("flake_json", help="Path to flake.json")
parser.add_argument("output_name", help="Output name")
args = parser.parse_args()

system = "x86_64-linux"

with open(args.flake_json, "r") as f:
    flake = json.load(f)

to_build = list()

for output in flake[args.output_name][system]:
    try:
        subprocess.check_output(
            f"nix eval .#{args.output_name}.{system}.{output}.__nocachix",
            shell=True,
            stderr=subprocess.DEVNULL,
        )
    except subprocess.CalledProcessError:
        to_build.append(output)

print(f"::set-output name=packages::{to_build}")
