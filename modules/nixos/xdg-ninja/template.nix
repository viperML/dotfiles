system: let
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_RUNTIME_DIR = "$XDG_RUNTIME_DIR";
in {
  env = {
    ANDROID_HOME = "${XDG_DATA_HOME}/android";
    CABAL_CONFIG = "${XDG_CONFIG_HOME}/cabal/config";
    CABAL_DIR = "${XDG_DATA_HOME}/cabal";
    CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
    ERRFILE = "${XDG_CACHE_HOME}/X11/xsession-errors";
    GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
    GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
    HISTFILE = "${XDG_DATA_HOME}/bash/history";
    IPYTHONDIR = "${XDG_CONFIG_HOME}/ipython";
    JULIA_DEPOT_PATH = "${XDG_DATA_HOME}/julia:$JULIA_DEPOT_PATH";
    JUPYTER_CONFIG_DIR = "${XDG_CONFIG_HOME}/jupyter";
    KDEHOME = "${XDG_CONFIG_HOME}/kde";
    LESSHISTFILE = "${XDG_DATA_HOME}/less/history";
    NPM_CONFIG_CACHE = "${XDG_CACHE_HOME}/npm";
    NPM_CONFIG_TMP = "${XDG_RUNTIME_DIR}/npm";
    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/config";
    PYTHONSTARTUP =
      if system == "nixos"
      then "/etc/pythonrc"
      else "${XDG_CONFIG_HOME}/python/pythonrc";
    STEPPATH = "${XDG_DATA_HOME}/step";
    VSCODE_EXTENSIONS = "${XDG_DATA_HOME}/code/extensions";
    XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
    INPUTRC = "${XDG_CONFIG_HOME}/readline/inputrc";
  };

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
}
