{ pkgs
, packages
, lib
, config
, ...
}: {
  # Generic programs
  home.packages = [
    # Nix management
    config.nix.package
    pkgs.direnv
    pkgs.alejandra
    pkgs.nixpkgs-fmt
    packages.self.nvfetcher
    packages.nh.default
    pkgs.nix-output-monitor
    packages.self.dotci

    # Editor support
    pkgs.nil
    pkgs.typst-lsp

    # Misc utils
    # pkgs.file
    # pkgs.lsof
    # pkgs.dogdns
    # pkgs.fd
    # pkgs.htop
    # pkgs.libarchive
    # pkgs.jq
    pkgs.ripgrep
    pkgs.skim
    # pkgs.bubblewrap
    pkgs.magic-wormhole-rs
    # packages.self.zellij
    pkgs.du-dust
    pkgs.hexyl
    pkgs.btop
    pkgs.unar
    pkgs.gh
    pkgs.dufs
    packages.self.elf-info
    pkgs.nix-init

    packages.self.fish
    packages.self.nushell
    packages.self.neovim
    # packages.self.helix
  ];

  # home.sessionVariables = {
  #   LESS = "-RiF --mouse --wheel-lines=3";
  # };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = lib.mkDefault "21.11";

  nix = {
    package = pkgs.nix;
    settings = import ../../misc/nix-conf.nix;
  };

  xdg.configFile."direnv/direnvrc".text = ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
  '';

  xdg.configFile."pypoetry/config.toml".text = ''
    [virtualenvs]
    in-project = true
    path = "{project-dir}/.venv"
    options.no-pip = true
    options.no-setuptools = true
    prefer-active-python = true
  '';

  manual.json.enable = false;

  imports = [
    ./git
  ];


  home.activation."user-dirs" = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    rm -f $VERBOSE_ARG "$HOME/.config/user-dirs.dirs.old"
  '';
}
