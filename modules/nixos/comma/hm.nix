{pkgs, ...}: let
  # TODO update script
  version = "2022-04-10";

  nix-index-db = pkgs.fetchurl {
    url = "https://github.com/Mic92/nix-index-database/releases/download/${version}/index-${pkgs.system}";
    sha256 = "sha256-lXdMSpd0Q2e0OLeeSXtICxf428CqVVEj0876LSSK0CI=";
  };
in {
  home.packages = with pkgs; [
    nix-index
    comma
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
