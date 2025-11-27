#! /usr/bin/env bash
set -eux

dir="$(git rev-parse --git-dir)"
root="$(git root)"

echo ".vscode" >> "$dir/info/exclude"
mkdir -v "$root/.vscode"
tee "$root/.vscode/settings.json" <<EOF
{
    "files.trimTrailingWhitespace": false,
    "files.trimFinalNewlines": false,
    "files.insertFinalNewline": false
}
EOF

