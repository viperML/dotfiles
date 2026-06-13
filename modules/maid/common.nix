{
  pkgs,
  ...
}:
{
  imports = [
    # ./containers
    # ./ghostty
    ./emacs
  ];

  file.home.".gitconfig".source = pkgs.git-viper.gitconfig;

  file.xdg_config."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  file.xdg_config."shellcheckrc".text = ''
    external-sources=true
  '';
}
