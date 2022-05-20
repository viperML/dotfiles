{
  packages,
  pkgs,
  lib,
  self,
  ...
}: let
  env = {
    FLAKE = "/mnt/c/Users/ayats/Documents/dotfiles";
    # BROWSER = "${prefix}/wslu";
    # EDITOR = "${prefix}/nvim";
    # SHELL = "${prefix}/fish";
    SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
  };
in {
  home.sessionVariables = env;

  home.packages = [
    packages.self.neofetch
    packages.self.vshell
    packages.self.neovim
  ];

  xdg.configFile."nix/nix.conf".text = lib.mkAfter ''
    auto-optimise-store = true
    builders = ssh://ayats@gen6.ayatsfer.gmail.com.beta.tailscale.net
  '';
}
