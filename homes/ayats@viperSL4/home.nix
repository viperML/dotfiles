{
  packages,
  pkgs,
  lib,
  self,
  config,
  ...
}: let
  env = {
    FLAKE = "/mnt/c/Users/ayats/Documents/dotfiles";
    # BROWSER = "${prefix}/wslu";
    EDITOR = "nvim";
    SHELL = "fish";
  };
in {
  home.sessionVariables = env;

  home.packages = [
    packages.home-manager.default
    pkgs.keychain
    pkgs.step-cli
    packages.self.neofetch
    packages.self.vshell
    packages.self.neovim
  ];

  xdg.configFile."nix/nix.conf".text = lib.mkAfter ''
    auto-optimise-store = true
    builders = ssh://ayats@gen6.ayatsfer.gmail.com.beta.tailscale.net
  '';

  xdg.configFile."nix/rc".text = ''
    eval "$(${lib.getExe pkgs.direnv} hook bash)"
    ${lib.getExe pkgs.keychain} -q --nogui
    . $HOME/.keychain/$(hostname)-sh
    ${lib.concatStringsSep "\n" (__attrValues (__mapAttrs (n: v: "export ${n}=${v}") config.home.sessionVariables))}
  '';
}
