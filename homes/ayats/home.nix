{flakePath, ...}: let
  username = "ayats";
  homeDirectory = "/home/${username}";
  env = {
    FLAKE = flakePath;
    EDITOR = "nvim";
    # SHELL = "${homeDirectory}/.nix-profile/bin/fish";
    VAULT_ADDR = "http://kalypso.ayatsfer.gmail.com.beta.tailscale.net:8200";
    NOMAD_ADDR = "http://chandra.ayatsfer.gmail.com.beta.tailscale.net:4646";
  };
in {
  home = {
    inherit username homeDirectory;
    sessionVariables = env;
    stateVersion = "21.11";
  };
}
