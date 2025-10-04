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
    };
    kglobalshortcutsrc = {
      kwin = {
        "Switch to Desktop 1" = "Meta+1,Ctrl+F1,Cambiar al escritorio 1";
        "Switch to Desktop 2" = "Meta+2,Ctrl+F2,Cambiar al escritorio 2";
        "Switch to Desktop 3" = "Meta+3,Ctrl+F3,Cambiar al escritorio 3";
        "Switch to Desktop 4" = "Meta+4,Ctrl+F4,Cambiar al escritorio 4";
      };
      plasmashell = {
        "activate task manager entry 1" = "none,Meta+1,Activar la entrada 1 del gestor de tareas";
        "activate task manager entry 2" = "none,Meta+2,Activar la entrada 2 del gestor de tareas";
        "activate task manager entry 3" = "none,Meta+3,Activar la entrada 3 del gestor de tareas";
        "activate task manager entry 4" = "none,Meta+4,Activar la entrada 4 del gestor de tareas";
      };
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
        PointerAccelerationProfile = 1;
        NaturalScroll = true;
      };
    };
    baloofilerc = {
      "Basic Settings".Indexing-Enabled = false;
    };
  };
}
