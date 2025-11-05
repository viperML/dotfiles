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
      EdgeBarrier = {
        CornerBarrier = false;
        EdgeBarrier = 0;
      };
      Plugins = {
        zoomEnabled = false;
        contrastEnabled = false;
        # fadedesktopEnabled = true;
        # slideEnabled = false;
      };
      ModifierOnlyShortcuts = {
        Meta = "";
      };
    };
    kglobalshortcutsrc = {
      kwin = lib.mkMerge [
        (lib.genAttrs' numbers (
          n: lib.nameValuePair "Switch to Desktop ${n}" "Meta+${n},Ctrl+F${n},Cambiar al escritorio ${n}"
        ))
        {
          "Window Close" = "Meta+Q\tAlt+F4,Alt+F4,Cerrar la ventana";

          "Window to Desktop 1" = "Meta+!,,Ventana al escritorio 1";
          "Window to Desktop 2" = "Meta+@,,Ventana al escritorio 2";
          "Window to Desktop 3" = "Meta+#,,Ventana al escritorio 3";
          "Window to Desktop 4" = "Meta+$,,Ventana al escritorio 4";
          "Window to Desktop 5" = "Meta+%,,Ventana al escritorio 5";
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
      Daemon = {
        Autolock = false;
        LockOnResume = false;
        Timeout = 0;
      };
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
      General = {
        ActivateWhenTypingOnDesktop = false;
        FreeFloating = true;
      };
      Plugins = {
        baloosearchEnabled = false;
        browserhistoryEnabled = false;
        browsertabsEnabled = false;
        calculatorEnabled = false;
        helprunnerEnabled = false;
        krunner_appstreamEnabled = false;
        krunner_bookmarksrunnerEnabled = false;
        krunner_charrunnerEnabled = false;
        krunner_colorsEnabled = false;
        krunner_dictionaryEnabled = false;
        krunner_katesessionsEnabled = false;
        krunner_killEnabled = false;
        krunner_konsoleprofilesEnabled = false;
        krunner_kwinEnabled = false;
        krunner_placesrunnerEnabled = false;
        krunner_plasma-desktopEnabled = false;
        krunner_powerdevilEnabled = false;
        krunner_recentdocumentsEnabled = false;
        krunner_servicesEnabled = true;
        krunner_sessionsEnabled = false;
        krunner_shellEnabled = false;
        krunner_spellcheckEnabled = false;
        krunner_systemsettingsEnabled = true;
        krunner_webshortcutsEnabled = false;
        locationsEnabled = false;
        "org.kde.activities2Enabled" = false;
        "org.kde.datetimeEnabled" = false;
        unitconverterEnabled = false;
        windowsEnabled = false;
      };
    };
    spectaclerc = {
      General.clipboardGroup = "PostScreenshotCopyImage";
    };
    powerdevilrc = {
      AC.Performance.PowerProfile = "performance";
      Battery.Performance.PowerProfile = "power-saver";
    };

    ksmserverrc = {
      General.loginMode = "emptySession";
    };
  };
}
