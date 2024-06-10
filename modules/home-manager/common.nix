{
  pkgs,
  inputs',
  self',
  lib,
  config,
  ...
}: {
  # Generic programs
  home.packages = [
    # Nix management
    config.nix.package
    pkgs.direnv
    pkgs.alejandra
    pkgs.nixpkgs-fmt
    pkgs.nix-output-monitor
    pkgs.nil
    self'.packages.env
  ];

  # home.sessionVariables = {
  #   LESS = "-RiF --mouse --wheel-lines=3";
  # };
  home.sessionVariables = {EDITOR = "nvim";};

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

  imports = [./git];

  home.activation."user-dirs" = lib.hm.dag.entryBefore ["writeBoundary"] ''
    rm -f $VERBOSE_ARG "$HOME/.config/user-dirs.dirs.old"
  '';
}
