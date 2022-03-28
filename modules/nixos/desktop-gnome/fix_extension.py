from pathlib import Path
import json
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('file', type=Path)
parser.add_argument('version', type=str)

args = parser.parse_args()

with open(args.file, mode="r") as f:
    metadata = json.load(f)
    metadata["shell-version"] = [args.version]

with open(args.file, mode="w") as f:
    json.dump(metadata, f)
