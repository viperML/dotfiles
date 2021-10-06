{ config, pkgs, ... }:

{
    programs.lsd = {
        enable = true;
        enableAliases = true;
        settings = ''
            ${builtins.readFile ./config.yaml}
        '';
    };

}