{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    impureDotfilesPath = lib.mkOption {
      type = lib.types.str;
      default = "{{home}}/Documents/dotfiles";
    };
  };

  imports = [
    # ./waybar
    # ./dunst
    # ./clipman
    # ./wallpaper
    # ./ags
  ];

  config = {
    file.home.".gitconfig".source = pkgs.git-viper.gitconfig;
  };
}
