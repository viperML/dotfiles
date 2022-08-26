/*
https://github.com/derat/xsettingsd/wiki/Settings

Copied from https://github.com/nix-community/home-manager/blob/master/modules/services/xsettingsd.nix
*/
args: let
  inherit (args) pkgs lib;
  inherit (lib) concatStrings mapAttrsToList toString;
  inherit (builtins) typeOf;

  xsettingsConfig = {
    "Gtk/CursorThemeName" = "Adwaita";
    "Net/EnableEventSounds" = false;
    "Net/EnableInputFeedbackSounds" = false;
    # "Net/IconThemeName" = "Colloid";

    "Xft/Antialias" = true;
    # "Xft/DPI" = 96;
    "Xft/Hinting" = true;
    "Xft/RGBA" = "rgb";
    "Xft/HintStyle" = "hintfull";

    "Gtk/FontName" = "Roboto,  10";
  };

  renderSettings = settings:
    concatStrings (mapAttrsToList renderSetting settings);

  renderSetting = key: value: ''
    ${key} ${renderValue value}
  '';

  renderValue = value:
    {
      int = builtins.toString value;
      bool =
        if value
        then "1"
        else "0";
      string = ''"${value}"'';
    }
    .${typeOf value};
in {
  light = pkgs.writeText "xsettingsd.conf" (renderSettings (xsettingsConfig
    // {
      "Net/ThemeName" = "adw-gtk3";
    }));
  dark = pkgs.writeText "xsettingsd.conf" (renderSettings (xsettingsConfig
    // {
      "Net/ThemeName" = "adw-gtk3-dark";
    }));
}
