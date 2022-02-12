{ pkgs }:
pkgs.mkShell {
  name = "dotfiles-basic-shell";
  buildInputs =
    with pkgs; [
      git
      gnumake
      jq
      nixos-install-tools
      ripgrep
      unzip
    ];
  shellHook = ''
    export NIX_USER_CONF_FILES="$(pwd)/modules/nix.conf"
    echo -e "\n\e[34m❄ Welcome to viperML/dotfiles ❄"
    echo -e "\e[34m''$(nix --version)"
    echo -e "\e[0m"
  '';
}
