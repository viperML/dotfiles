#! @python3@/bin/python -B
import subprocess
import os
import argparse

import toml
from pathlib import Path

if DRY := os.environ.get("DRY", False):
    path = Path(__file__).parent / "required.toml"
else:
    parser = argparse.ArgumentParser()
    parser.add_argument("path", help="Path to the config file")
    path = parser.parse_args().path

with open(path, "r") as f:
    input = toml.load(f)


def run_command(cmd: str) -> None:
    print(f"$ {cmd}")
    if not DRY:
        subprocess.run(cmd, shell=True)


class Remote:
    def __init__(self, name: str, url: str):
        self.name = name
        if url[-1] != "/":
            url += "/"
        self.url = url

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Remote):
            return False
        return self.name == other.name and self.url == other.url

    def add(self) -> None:
        run_command(
            f"flatpak remote-add --user --if-not-exists --no-gpg-verify {self.name} {self.url}"
        )

    def remove(self) -> None:
        run_command(f"flatpak remote-delete --user {self.name}")


remotes_required = list()
for r in input["remotes"]:
    remotes_required.append(Remote(r["name"], r["url"]))


def get_remotes() -> list[Remote]:
    result = list()
    output = subprocess.check_output(
        "flatpak remotes --user --columns=name,url", shell=True
    ).decode()
    for line in output.split("\n"):
        if line:
            result.append(Remote(line.split()[0], line.split()[1]))
    return result


remotes_current = get_remotes()

for remote_unrequired in remotes_current:
    if remote_unrequired not in remotes_required:
        print(f"Removing remote {remote_unrequired.name}")
        remote_unrequired.remove()

for remote_missing in remotes_required:
    if remote_missing not in remotes_current:
        print(f"Adding remote {remote_missing.name}")
        remote_missing.add()


class App:
    def __init__(self, ref: str, origin: str, remotes: list[Remote]):
        self.ref = ref
        # Check if origin is in a remote
        if any(r.name == origin for r in remotes):
            self.origin = origin
        else:
            raise Exception(f"Origin {origin} not in remotes")
        self.name = self.ref.split("/")[0]

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, App):
            return False
        return self.ref == other.ref and self.origin == other.origin

    def install(self) -> None:
        run_command(f"flatpak install --noninteractive --user {self.origin} {self.ref}")

    def uninstall(self) -> None:
        run_command(f"flatpak uninstall --noninteractive --user {self.ref}")


apps_required = list()
for a in input["apps"]:
    apps_required.append(App(a["ref"], a["origin"], remotes_required))


def get_apps(remotes: list[Remote]) -> list[App]:
    result = list()
    output = subprocess.check_output(
        "flatpak list --user --app --columns=ref,origin", shell=True
    ).decode()
    for line in output.split("\n"):
        if line:
            result.append(App(line.split()[0], line.split()[1], remotes))
    return result


apps_current = get_apps(remotes_current)


for app_unrequired in apps_current:
    if app_unrequired not in apps_required:
        print(f"Uninstalling app {app_unrequired.ref}")
        app_unrequired.uninstall()

for app_missing in apps_required:
    if app_missing not in apps_current:
        print(f"Installing app {app_missing.ref}")
        app_missing.install()

run_command("flatpak uninstall --noninteractive --user --unused")


for app in apps_required:
    run_command(f"flatpak override --user --reset {app.name}")

    for o in input["overrides"]:
        run_command(f"flatpak override --user {o} {app.name}")
