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
    pkgs.direnv
    pkgs.alejandra
    pkgs.nvfetcher
    packages.nh.default

    # Editor support
    packages.nil.default

    # Misc utils
    # pkgs.file
    # pkgs.lsof
    # pkgs.dogdns
    # pkgs.fd
    # pkgs.htop
    # pkgs.libarchive
    # pkgs.jq
    pkgs.ripgrep
    # pkgs.bubblewrap
    pkgs.wormhole-william
    # packages.self.zellij

    packages.self.fish
    packages.self.neovim
    packages.self.git
  ];

  # home.sessionVariables = {
  #   LESS = "-RiF --mouse --wheel-lines=3";
  # };

  home.stateVersion = lib.mkDefault "21.11";

  nix = {
    package = pkgs.nix;
    settings = import ../../misc/nix-conf.nix;
  };

  xdg.configFile."direnv/direnvrc".text = ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
  '';
}
