{ pkgs, ... }:

{
  environment.packages = with pkgs; [
    vim
    fish
    neofetch
  ];
}
