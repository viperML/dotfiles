{
  pkgs,
  ...
}:
{
  imports = [
    ./containers
    ./gnome
    ./ghostty
  ];

  file.home.".gitconfig".source = pkgs.git-viper.gitconfig;
  systemd.tmpfiles.dynamicRules = [
    "D {{home}}/.spack 0755 {{user}} {{group}} 0 -"
  ];

  file.xdg_config."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';
}
