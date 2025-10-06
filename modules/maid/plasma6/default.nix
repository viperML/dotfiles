{ lib, ... }:
let
  numbers = builtins.genList (x: toString (x + 1)) 9;
in
{
  kconfig.settings = {
    kwinrc = {
      Desktops.Number = 4;
      Desktops.Rows = 1;
      Effect-overview.BorderActivate = 9;
      Effect-fadedesktop.AnimationDuration = 100;
      # Plugins = {
      #   fadedesktopEnabled = true;
      #   slideEnabled = false;
      # };
      ModifierOnlyShortcuts = {
        Meta = "";
      };
    };
    kglobalshortcutsrc = {
      kwin = lib.mkMerge [
        (lib.genAttrs' numbers (
          n: lib.nameValuePair "Switch to Desktop ${n}" "Meta+${n},Ctrl+F${n},Cambiar al escritorio ${n}"
        ))
        # FIXME
        (lib.genAttrs' numbers (
          n: lib.nameValuePair "Window to Desktop ${n}" "Meta+Shift+${n},,Ventana al escritorio ${n}"
        ))
        {
          "Window Close" = "Meta+Q\tAlt+F4,Alt+F4,Cerrar la ventana";
        }
      ];

      plasmashell = lib.mkMerge [
        (lib.genAttrs' numbers (
          n:
          lib.nameValuePair "activate task manager entry ${n}" "none,Meta+${n},Activar la entrada ${n} del gestor de tareas"
        ))
        {
          "activate application launcher" = "Meta,Meta\tAlt+F1,Activar el lanzador de aplicaciones";
          "manage activities" = "none,Meta+Q,Mostrar el selector de actividad";
        }
      ];
    };
    kscreenlockerrc = {
      Daemon.Autolock = false;
      Timeout = 0;
    };
    kdeglobals = {
      General = {
        font = "Inter,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        fixed = "iosevka-normal,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        menuFont = "Inter,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        smallestReadableFont = "Inter,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        toolBarFont = "Inter,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      };
    };
    kcminputrc = {
      Libinput.Defaults = {
        # PointerAccelerationProfile = 1;
        # NaturalScroll = true;
      };
    };
    baloofilerc = {
      "Basic Settings".Indexing-Enabled = false;
    };
    krunnerrc = {
      ActivateWhenTypingOnDesktop = false;
      FreeFloating = true;
    };
  };
}
