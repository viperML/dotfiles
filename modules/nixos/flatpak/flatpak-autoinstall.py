#! @python3@/bin/python -B
import subprocess
import os
import argparse

import toml

DRY = os.environ.get("DRY", False)

# Load from flatpaks.toml
# path = "modules/home-manager/flatpak/required.toml"

# Get the config file path as an argument
parser = argparse.ArgumentParser()
parser.add_argument("path", help="Path to the config file")
args = parser.parse_args()


with open(args.path, "r") as f:
    input = toml.load(f)


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
        cmd = f"flatpak remote-add --user --if-not-exists --no-gpg-verify {self.name} {self.url}"
        print(f"$ {cmd}")
        if not DRY:
            subprocess.run(cmd, shell=True)

    def remove(self) -> None:
        cmd = f"flatpak remote-delete --user {self.name}"
        print(f"$ {cmd}")
        if not DRY:
            subprocess.run(cmd, shell=True)


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
    def __init__(self, id: str, origin: str, remotes: list[Remote]):
        self.id = id
        # Check if origin is in a remote
        if any(r.name == origin for r in remotes):
            self.origin = origin
        else:
            raise Exception(f"Origin {origin} not in remotes")

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, App):
            return False
        return self.id == other.id and self.origin == other.origin

    def install(self) -> None:
        cmd = f"flatpak install --noninteractive --user {self.origin} {self.id}"
        print(f"$ {cmd}")
        if not DRY:
            subprocess.run(cmd, shell=True)

    def uninstall(self) -> None:
        cmd = f"flatpak uninstall --noninteractive --user {self.id}"
        print(f"$ {cmd}")
        if not DRY:
            subprocess.run(cmd, shell=True)


apps_required = list()
for a in input["apps"]:
    apps_required.append(App(a["id"], a["origin"], remotes_required))


def get_apps(remotes: list[Remote]) -> list[App]:
    result = list()
    output = subprocess.check_output(
        "flatpak list --user --app --columns=application,origin", shell=True
    ).decode()
    for line in output.split("\n"):
        if line:
            result.append(App(line.split()[0], line.split()[1], remotes))
    return result


apps_current = get_apps(remotes_current)


for app_unrequired in apps_current:
    if app_unrequired not in apps_required:
        print(f"Uninstalling app {app_unrequired.id}")
        app_unrequired.uninstall()

for app_missing in apps_required:
    if app_missing not in apps_current:
        print(f"Installing app {app_missing.id}")
        app_missing.install()

cmd = "flatpak uninstall --noninteractive --user --unused"
print(f"$ {cmd}")
if not DRY:
    subprocess.check_output(cmd, shell=True)
