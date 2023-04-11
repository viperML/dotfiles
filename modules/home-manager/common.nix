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
    pkgs.nix-output-monitor

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
    pkgs.elfutils
    pkgs.du-dust
    (
      if pkgs.system == "x86_64-linux"
      then pkgs.lurk
      else pkgs.strace
    )
    pkgs.hexyl

    packages.self.fish
    # packages.self.nushell
    packages.self.neovim
    packages.self.helix
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
