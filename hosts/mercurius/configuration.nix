{
  config,
  lib,
  pkgs,
  ...
}:
{
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  system.stateVersion = "24.11";

  users.users.nixos = {
    shell = pkgs.fish-viper;
    maid = {
      file.xdg_config."git/local".source = ./local.gitconfig;
    };
  };

  environment.sessionVariables = rec {
    D = "/home/nixos/dotfiles";
    NH_FILE = "${D}/hosts/mercurius";
  };
}
