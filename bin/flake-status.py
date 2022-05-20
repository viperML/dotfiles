#!/usr/bin/env python
import json
import requests
from types import SimpleNamespace
import datetime

# TODO ratelimited what tf
# TODO multithread

with open("flake.lock", "r") as f:
    lock = json.load(f)["nodes"]

targets = [
    "nixpkgs",
    "nixpkgs-stable",
    "nixpkgs-master",
    "home-manager",
]

for t in lock and targets:
    repo = lock[t]["original"]["repo"]
    owner = lock[t]["original"]["owner"]
    try:
        branch = lock[t]["original"]["ref"]
    except KeyError:
        branch = "master"

    rev = SimpleNamespace()
    rev.local = lock[t]["locked"]["rev"]

    age = datetime.datetime.now() - datetime.datetime.fromtimestamp(
        lock[t]["locked"]["lastModified"]
    )

    head = requests.get(
        f"https://api.github.com/repos/{owner}/{repo}/branches/{branch}"
    ).json()

    rev.head = head["commit"]["sha"]

    diff = requests.get(
        f"https://api.github.com/repos/{owner}/{repo}/compare/{rev.local}...{rev.head}"
    ).json()

    commits = diff["total_commits"]

    print("")
    print(f">>> {t}")
    print(f"    Upstream: github.com/{owner}/{repo}/{branch}")
    print(f"    Local rev is {age} old")
    print(f"    {commits} commits since last sync")

print("")
