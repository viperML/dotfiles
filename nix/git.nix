{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Fernando Ayats";
    userEmail = "ayatsfer@gmail.com";

    extraConfig = {
      init.defaultBranch = "master";
      pull.ff = "only";
      pull.rebase = "merges";
      push.default = "simple";
    };
  };
}
