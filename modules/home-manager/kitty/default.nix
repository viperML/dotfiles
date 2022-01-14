{ config, pkgs, ... }:

{
  home.packages = [ pkgs.g-kitty ];
  xdg.configFile."kitty/kitty.conf" = {
    text = ''
      shell ${pkgs.fish}/bin/fish
      ${builtins.readFile ./kitty.conf}
    '';
    onChange = ''
      ${pkgs.procps}/bin/pkill -USR1 -u $USER kitty || true
    '';
  };

}
