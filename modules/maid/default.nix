{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./containers
    ./gnome
  ];

  options = {
    impureDotfilesPath = lib.mkOption {
      type = lib.types.str;
      default = "{{home}}/Documents/dotfiles";
    };
  };

  config = {
    file.home.".gitconfig".source = pkgs.git-viper.gitconfig;
    systemd.tmpfiles.dynamicRules = [
      "D {{home}}/.spack 0755 {{user}} {{group}} 0 -"
    ];
  };
}
