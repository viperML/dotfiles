import logging
import os
import re
from pathlib import Path
from typing import Union


def remove_generation(path: Path) -> None:
    if os.getenv("DRY"):
        logging.info(f"DRY Removing {str(path)}")
    else:
        logging.info(f"Removing {str(path)}")
        path.unlink()


class generation:
    def __init__(self, esp: Union[Path, str], number) -> None:
        entries_path = Path(Path(esp) / "loader/entries")
        self.entries = list(entries_path.glob(f"nixos-generation-{number}*"))
        self.number = number

    def remove_all(self) -> None:
        for p in self.entries:
            remove_generation(p)


def gen_number(filename) -> int:
    regex = r"(\d+)"
    result = re.findall(regex, str(filename))
    return int(result[0])


def generations_in_esp(esp: Union[Path, str]) -> set[int]:
    entries_path = Path(Path(esp) / "loader/entries")
    all_generations = list(entries_path.glob("nixos-generation-*"))
    return set([gen_number(file) for file in all_generations])


def generations_in_profile() -> set[int]:
    entries_path = Path("/nix/var/nix/profiles/")
    all_generations = list(entries_path.glob("system-*-link"))
    return set([gen_number(file) for file in all_generations])


if __name__ == "__main__":
    logging.basicConfig(encoding="utf-8", level=logging.INFO)

    if not (my_esp_path := os.getenv("ESP")):
        raise EnvironmentError("Please pass ESP environment variable")
    my_esp = Path(my_esp_path)
    assert my_esp.exists(), f"{my_esp} doesn't exist"

    my_gens_in_esp = generations_in_esp(my_esp)
    my_gens_in_profile = generations_in_profile()

    my_gen_numbers_to_remove = my_gens_in_esp.difference(my_gens_in_profile)
    my_gens_numbers_to_keep = my_gens_in_esp.intersection(my_gens_in_profile)

    my_gens_to_remove = [
        generation(my_esp, id) for id in my_gen_numbers_to_remove
    ]
    my_gens_to_keep = [
        generation(my_esp, id) for id in my_gens_numbers_to_keep
    ]

    for g in my_gens_to_keep:
        for e in g.entries:
            logging.info(f"Keeping {e}")

    for g in my_gens_to_remove:
        g.remove_all()
