import subprocess
from pathlib import Path

dry = True

cmd = "nix build .#g-neovim -L"
print(f"$ {cmd}")
if not dry:
    subprocess.run(cmd.split(" "), check=True)

drvPath = subprocess.check_output("nix eval --raw .#g-neovim.drvPath".split(" ")).decode()
print(f"{drvPath = }")

with open(Path("./drvPath"), "w") as f:
    f.write(drvPath)
