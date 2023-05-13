import json
import os
import re
from pathlib import Path

try:
    flake_root = Path(os.environ["FLAKE"])
except KeyError:
    flake_root = Path(os.environ["PWD"])


with open(flake_root / "flake" / "generated.json", "r") as f:
    inputs = json.loads(f.read())


with open(flake_root / "flake" / "template.nix", "r") as f:
    template = f.read()


pattern = r"%([a-zA-Z]+)%"

result = re.sub(pattern, lambda elem: inputs[elem.group(1)]["src"]["rev"], template)
result = re.sub(r"#.*", "", result)
result = re.sub(r"\n", "", result)
result = re.sub(r"\s", "", result)
result = result.replace("inputs:", "inputs: ")
result = result.replace("inherit", "inherit ")

print(result)

with open(flake_root / "flake.nix", "w") as f:
    f.write(result)
