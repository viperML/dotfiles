#!/usr/bin/env python
import pathlib

result = list(map(lambda p: p.__str__(), list(pathlib.Path(".").glob("**/update.sh"))))
print(f"::set-output name=scripts::{result}")
