{ pkgs
, inputs
, system
}:
pkgs.mkShell {
  name = "dotfiles-advanced-shell";
  buildInputs =
    with pkgs;
    [
      git
      gnumake
      jq
      nixos-install-tools
      ripgrep
      update-nix-fetchgit
      inputs.deploy-rs.defaultPackage.${system}
    ];
  shellHook = ''
    export NIX_USER_CONF_FILES="$(pwd)/modules/nix.conf"
    echo -e "\n\e[34m❄ Welcome to viperML/dotfiles ❄"
    echo -e "\e[34m- ''$(nix --version)"
    echo "- Nixpkgs age:"
    curl https://api.github.com/repos/NixOS/nixpkgs/commits/`jq -r '.nodes.nixpkgs.locked.rev' ./flake.lock` -s | jq -r ".commit.author.date"
    echo -e "\n\e[34m❄ Changes to the running NixOS config: ❄"
    echo -e "\e[0m"
    git --no-pager diff $(nixos-version --json | jq -r '.configurationRevision') -p
  '';
}
