{
  packages,
  pkgs,
  lib,
  self,
  config,
  ...
}: let
  username = "ayats";
  homeDirectory = "/home/${username}";
  env = {
    FLAKE = "${homeDirectory}/Projects/dotfiles";
    EDITOR = "${homeDirectory}/.nix-profile/bin/nvim";
    SHELL = "${homeDirectory}/.nix-profile/bin/fish";
    VAULT_ADDR = "http://kalypso.ayatsfer.gmail.com.beta.tailscale.net:8200";
    NOMAD_ADDR = "http://sumati.ayatsfer.gmail.com.beta.tailscale.net:4646";
    HISTFILE = "${config.xdg.dataHome}/bash/history";
    LESSHISTFILE = "${config.xdg.dataHome}/less/history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/config";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
  };
in {
  home = {
    inherit username homeDirectory;
    sessionVariables = env;
    stateVersion = "21.11";

    packages = [
      packages.home-manager.default
      # pkgs.keychain
      pkgs.step-cli
      packages.self.neofetch
      packages.self.vshell
      packages.self.neovim
      packages.self.nix
      pkgs.file
    ];

    file =
      lib.genAttrs [
        "Documents"
        "Desktop"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
      ] (folder: {
        source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Users/ayats/${folder}";
      });
  };

  nix = {
    package = packages.self.nix;
    extraOptions = lib.fileContents ./nix.conf;
  };

  xdg.enable = true;

  # xdg.configFile."nix/rc".text = ''
  #   eval "$(${lib.getExe pkgs.direnv} hook bash)"
  #   # ${lib.getExe pkgs.keychain} -q --nogui
  #   . $HOME/.keychain/$(hostname)-sh
  #   ${lib.concatStringsSep "\n" (__attrValues (__mapAttrs (n: v: "export ${n}=${v}") config.home.sessionVariables))}
  # '';
}
