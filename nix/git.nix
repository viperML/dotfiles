{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Fernando Ayats";
    userEmail = "ayatsfer@gmail.com";
  };
}
