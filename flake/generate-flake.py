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
    result = f.read()

result = re.sub(r"#.*", "", result)
result = re.sub(r"%([a-zA-Z]+)%", lambda elem: inputs[elem.group(1)]["src"]["rev"], result)
result = re.sub(r"\n", "", result)
result = re.sub(r"\s", "", result)
result = result.replace("inputs:", "inputs: ")
result = result.replace("inherit", "inherit ")

print(result)

with open(flake_root / "flake.nix", "w") as f:
    f.write(result)

subprocess.run(["nix", "flake", "lock"], cwd=flake_root)
