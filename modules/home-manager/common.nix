{
  config,
  pkgs,
  lib,
  inputs,
  self,
  packages,
  ...
}: {
  # Generic programs
  home.packages = with pkgs; [
    # Nix management
    packages.self.nix
    direnv
    alejandra
    nvfetcher

    # Editor support
    packages.self.nil

    # Misc utils
    file
    lsof
    dogdns
    fd
    htop
    libarchive
    # jless
    jq
    ripgrep
    bubblewrap
    wormhole-william
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
    package = packages.self.nix;
    settings = import "${self}/misc/nix-conf.nix";
  };

  xdg.configFile."direnv/direnvrc".text = ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
  '';
}
