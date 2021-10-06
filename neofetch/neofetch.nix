{ config, pkgs, ... }:

{

    home.packages = with pkgs; [
        cpufetch
        neofetch
    ];

    home.file.".config/neofetch/config.conf".source = ./config.conf;
}