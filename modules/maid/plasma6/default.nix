{ lib, ... }:
let
  numbers = builtins.genList (x: toString (x + 1)) 9;

  genUUID =
    s:
    let
      inherit (lib) substring;
      r = builtins.hashString "sha256" s;
      # variant nibble must start with bits '10', i.e. be one of 8/9/a/b.
      # map every possible hex digit down to the correct variant digit.
      variantMap = {
        "0" = "8";
        "1" = "9";
        "2" = "a";
        "3" = "b";
        "4" = "8";
        "5" = "9";
        "6" = "a";
        "7" = "b";
        "8" = "8";
        "9" = "9";
        "a" = "a";
        "b" = "b";
        "c" = "8";
        "d" = "9";
        "e" = "a";
        "f" = "b";
      };
      variant = variantMap.${substring 16 1 r};
    in
    "${substring 0 8 r}-${substring 8 4 r}-4${substring 13 3 r}-${variant}${substring 17 3 r}-${substring 20 12 r}";

  mkwinrule =
    attrs:
    let
      h = genUUID attrs.Description;
    in
    {
      ${h} = attrs;
    };

  mkMaximize =
    wmclass:
    (mkwinrule {
      "Description" = "Maximize ${wmclass}";
      "wmclass" = wmclass;
      "maximizehoriz" = "true";
      "maximizehorizrule" = "3";
      "maximizevert" = "true";
      "maximizevertrule" = "3";
      "wmclassmatch" = "1";
    });
in
{
  # packages = [
  #   pkgs.ktailctl
  # ];
  #
  # file.xdg_config."autostart/${f}".source = "${pkgs.ktailctl}/share/applications/${f}";

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
        slideEnabled = true;
      };
      ModifierOnlyShortcuts = {
        Meta = "";
      };
      Windows = {
        DelayFocusInterval = 0;
        FocusPolicy = "FocusFollowsMouse";
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

          "Window On All Desktops" = "Meta+P,,Mantener la ventana en todos los escritorios";

          "Window Quick Tile Bottom" = "none,Meta+Down,Situar la ventana en mosaico en la parte inferior";
          "Window Quick Tile Left" = "none,Meta+Left,Situar la ventana en mosaico a la izquierda";
          "Window Quick Tile Right" = "none,Meta+Right,Situar la ventana en mosaico a la derecha";
          "Window Quick Tile Top" = "none,Meta+Up,Situar la ventana en mosaico en la parte superior";

          "Switch Window Down" = "Meta+Down,Meta+Alt+Down,Cambiar a la ventana anterior";
          "Switch Window Left" = "Meta+Left,Meta+Alt+Left,Cambiar a la ventana a la izquierda";
          "Switch Window Right" = "Meta+Right,Meta+Alt+Right,Cambiar a la ventana a la derecha";
          "Switch Window Up" = "Meta+Up,Meta+Alt+Up,Cambiar a la ventana superior";

          "Window Maximize" = "Meta+F\tMeta+PgUp,Meta+PgUp,Maximizar la ventana";
        }
      ];

      plasmashell = lib.mkMerge [
        (lib.genAttrs' numbers (
          n:
          lib.nameValuePair "activate task manager entry ${n}" "none,Meta+${n},Activar la entrada ${n} del gestor de tareas"
        ))
        {
          "activate application launcher" = "none,Meta\tAlt+F1,Activar el lanzador de aplicaciones";
          "manage activities" = "none,Meta+Q,Mostrar el selector de actividad";
        }
      ];

      services."org.kde.kscreen.desktop" = {
        # Disables Ctrl+P
        "ShowOSD" = "Display";
      };

      services."org.kde.krunner.desktop" = {
        _launch = "Search\tAlt+Space\tAlt+F2\tMeta+Space";
      };

      services."Alacritty.desktop" = {
        _launch = "Meta+Return";
      };

      mediacontrol = {
        mediavolumedown = "none,none,Bajar el volumen multimedia";
        mediavolumeup = "none,none,Subir el volumen multimedia";
      };

      kmix = {
        decrease_volume = "PgDown\tVolume Down,Volume Down,Bajar el volumen";
        increase_volume = "PgUp\tVolume Up,Volume Up,Subir el volumen";
      };
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
        fixed = "Iosevka Viper,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        menuFont = "Inter,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        smallestReadableFont = "Inter,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        toolBarFont = "Inter,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      };
      KDE = {
        AnimationDurationFactor = "0.5";
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
      Battery.Performance.PowerProfile = "balanced";
      LowBattery.Performance.PowerProfile = "power-saver";
    };

    ksmserverrc = {
      General.loginMode = "emptySession";
    };

    klaunchrc = {
      BusyCursorSettings.Bouncing = false;
      FeedbackStyle.BusyCursor = false;
    };

    KTailctlrc = {
      Interface.startMinimized = true;
    };

    kwinrulesrc =
      let
        rules = lib.mergeAttrsList [
          (mkMaximize "Alacritty")

          (mkwinrule {
            "Description" = "Zoom";
            "fsplevel" = "4";
            "fsplevelrule" = "2";
            "wmclass" = "zoom zoom";
            "wmclasscomplete" = "true";
            "wmclassmatch" = "1";
          })
        ];
      in
      rules
      // {
        General = {
          count = builtins.attrNames rules |> builtins.length;
          rules = builtins.attrNames rules |> lib.concatStringsSep ",";
        };
      };
  };
}
