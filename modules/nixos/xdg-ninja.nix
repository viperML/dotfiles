{
  config,
  pkgs,
  lib,
  ...
}: let
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_RUNTIME_DIR = "/run/user/$(id -u)";
  env = {
    ANDROID_HOME = "${XDG_DATA_HOME}/android";
    HISTFILE = "${XDG_DATA_HOME}/bash/history";
    CABAL_CONFIG = "${XDG_CONFIG_HOME}/cabal/config";
    CABAL_DIR = "${XDG_DATA_HOME}/cabal";
    CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
    GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
    GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
    IPYTHONDIR = "${XDG_CONFIG_HOME}/ipython";
    JULIA_DEPOT_PATH = "${XDG_DATA_HOME}/julia:$JULIA_DEPOT_PATH";
    JUPYTER_CONFIG_DIR = "${XDG_CONFIG_HOME}/jupyter";
    KDEHOME = "${XDG_CONFIG_HOME}/kde";
    XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
    PYTHONSTARTUP = "/etc/pythonrc";
    # XAUTHORITY = "${XDG_RUNTIME_DIR}/Xauthority";
    # GTK2_RC_FILES = "${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"; # not respected by KDE
    STEPPATH = "${XDG_DATA_HOME}/step";
    ERRFILE = "${XDG_CACHE_HOME}/X11/xsession-errors";
    VSCODE_EXTENSIONS = "${XDG_DATA_HOME}/code/extensions";
  };
in {
  # environment.variables = env;
  environment.sessionVariables = env;
  home-manager.sharedModules = [
    {
      home.sessionVariables = env;
    }
  ];
  environment.etc = {
    npmrc.text = ''
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      tmp=''${XDG_RUNTIME_DIR}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
    '';
    pythonrc.text = ''
      import os
      import atexit
      import readline

      history = os.path.join(os.environ['XDG_CACHE_HOME'], 'python_history')
      try:
          readline.read_history_file(history)
      except OSError:
          pass

      def write_history():
          try:
              readline.write_history_file(history)
          except OSError:
              pass

      atexit.register(write_history)
    '';
  };
}
