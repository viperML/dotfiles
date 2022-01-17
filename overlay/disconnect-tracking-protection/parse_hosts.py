#!/usr/bin/env python310
import json
import argparse

selected_categories = [ "All" ]
removed_categories = [ "Social" ]

# Initialize argparse
parser = argparse.ArgumentParser(description='Parse hosts file')

parser.add_argument('--file', '-f', default='source/services.json',
                    help='JSON file to use')
parser.add_argument('--output', '-o', default='source/hosts',
                    help='Output file')

args = parser.parse_args()

# Read the contents of the json file
with open(args.file) as json_file:
    data = json.load(json_file)


hosts = []

for category in data["categories"]:
    category_hosts = []
    if category in selected_categories \
       or ("All" in selected_categories and category not in removed_categories):
        print(f"Parsing category: {category}")
        category_hosts = []
        for service in data["categories"][category]:
            # Unfold the JSON mess
            service_hosts = list(list(service.values())[0].values())[0]
            category_hosts.extend(service_hosts)
        print(f"- Adding {len(category_hosts)} hosts")
        hosts.extend(category_hosts)

    else:
        print(f"Skipping category: {category}")

hosts.sort()
print(f"Total hosts: {len(hosts)}")

with open(args.output, "w") as hosts_file:
    for host in hosts:
        hosts_file.write(f"0.0.0.0 {host}\n")
