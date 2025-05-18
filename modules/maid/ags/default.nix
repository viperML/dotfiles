{ pkgs, config, ... }:
{
  systemd.services."ags" = {
    script = ''
      ags run ~/Documents/dotfiles/modules/maid/ags/app.ts --gtk4
    '';
    path = with pkgs; [
      ags
      gobject-introspection
      gtk4
    ];
    # wantedBy = [ "graphical-session.target" ];
  };
}
