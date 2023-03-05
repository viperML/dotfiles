#!/usr/bin/env python3
from pathlib import Path
import json


root_dir = Path(__file__).parent
template = root_dir / "template.nix"
output = root_dir / ".." / "flake.nix"

with open(root_dir / "generated.json") as f:
    versions = json.load(f)

pass

with open(template, "r") as t, open(output, "w") as o:
    text = template.read_text()
    output.write_text(text)


pass
