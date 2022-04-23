{
  pkgs,
  packages,
  lib,
  ...
}: let
  # TODO update script
  tagName = (builtins.fromJSON (lib.fileContents ./nix-index-database.json)).tagName;

  nix-index-db = pkgs.fetchurl {
    url = "https://github.com/Mic92/nix-index-database/releases/download/${tagName}/index-${pkgs.system}";
    sha256 = "sha256-lXdMSpd0Q2e0OLeeSXtICxf428CqVVEj0876LSSK0CI=";
  };
in {
  home.packages = with pkgs; [
    nix-index
    comma
    packages.nix-autobahn.nix-autobahn
  ];

  home.file.".cache/nix-index/files".source = nix-index-db.outPath;

  programs.fish.functions = {
    __fish_command_not_found_handler = {
      body = ''
        function __read_confirm
          while true
            read -p 'echo "Run $argv[1] with comma? (Y/n):"' -l confirm
            switch $confirm
              case Y y ""
                return 0
              case N n
                return 1
            end
          end
        end
        if __read_confirm
          ${pkgs.comma}/bin/comma $argv[1]
        end
      '';
      onEvent = "fish_command_not_found";
    };
  };
}
