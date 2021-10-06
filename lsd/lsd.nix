{ config, pkgs, ... }:

{
    programs.lsd = {
        enable = true;
    };

    enableAliases = true;
}