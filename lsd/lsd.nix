{ config, pkgs, ... }:

{
    programs.lsd = {
        enable = true;
        enableAliases = true;
    };

    home.file.".config/lsd/config.yaml".source = ./config.yaml;
}
