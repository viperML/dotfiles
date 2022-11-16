{
  pkgs,
  self,
  packages,
  lib,
  ...
}: {
  # Generic programs
  home.packages = [
    # Nix management
    packages.self.nix
    pkgs.direnv
    pkgs.alejandra
    pkgs.nvfetcher

    # Editor support
    packages.self.nil

    # Misc utils
    pkgs.file
    pkgs.lsof
    pkgs.dogdns
    pkgs.fd
    pkgs.htop
    pkgs.libarchive
    pkgs.jq
    pkgs.ripgrep
    pkgs.bubblewrap
    pkgs.wormhole-william
    pkgs.zellij

    packages.self.neofetch
    packages.self.fish
    packages.self.neovim
    packages.self.git
  ];

  home.sessionVariables = {
    LESS = "-RiF --mouse --wheel-lines=3";
  };

  home.stateVersion = "21.11";

  nix = {
    package = lib.mkForce packages.self.nix;
    settings = import "${self}/misc/nix-conf.nix";
  };

  xdg.configFile."direnv/direnvrc".text = ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
  '';
}
