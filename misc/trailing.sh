#! /usr/bin/env bash
set -eux

dir="$(git rev-parse --git-dir)"
root="$(git root)"

echo ".vscode" >> "$dir/info/exclude"
mkdir -pv "$root/.vscode"
if [[ ! -f "$root/.vscode/settings.json" ]]; then
    echo '{}' > "$root/.vscode/settings.json"
fi
jq -s 'add' "$root/.vscode/settings.json" - > "$root/.vscode/settings.tmp.json" <<EOF
{
    "files.trimTrailingWhitespace": false,
    "files.trimFinalNewlines": false,
    "files.insertFinalNewline": false
}
EOF

mv -v "$root/.vscode/settings.tmp.json" "$root/.vscode/settings.json"
