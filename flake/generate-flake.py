import json
import os
import re
from pathlib import Path
import subprocess

try:
    flake_root = Path(os.environ["FLAKE"])
except KeyError:
    flake_root = Path(os.environ["PWD"])


with open(flake_root / "flake" / "generated.json", "r") as f:
    inputs = json.loads(f.read())


with open(flake_root / "flake" / "template.nix", "r") as f:
    template = f.read()


pattern = r"%([a-zA-Z]+)%"

substituted = re.sub(pattern, lambda elem: inputs[elem.group(1)]["src"]["rev"], template)
substituted = re.sub(r"#.*", "", substituted)
substituted = re.sub(r"\n", "", substituted)

with open(flake_root / "flake.nix", "w") as f:
    f.write(substituted)

subprocess.run(["nixpkgs-fmt", flake_root / "flake.nix"])
