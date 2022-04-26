{
  wrapNeovimUnstable,
  neovim-unwrapped,
  neovimUtils,
  vimPlugins,
  vimUtils,
  formats,
  writeTextDir,
  fetchFromGitHub,
  lib,
  symlinkJoin,
  makeWrapper,
}: let
  nvchad-src = fetchFromGitHub {
    repo = "NvChad";
    owner = "NvChad";
    rev = "f9f03e7eaf095607f90ec4df96f786acc8427edc";
    sha256 = "sha256-RA+cGCRqleXZK4T55gsk0so1UEO+ImALNEcEPafe490=";
  };

  # Make neovim write stuff to .local/share, instead of .config/nvim
  neovim-unwrapped-fixed = symlinkJoin {
    name = with neovim-unwrapped; "${pname}-fixed-${version}";
    paths = [neovim-unwrapped];
    buildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/nvim \
        --set XDG_CONFIG_HOME \$HOME/.local/share/nvchad
    '';
  };
in
  wrapNeovimUnstable neovim-unwrapped-fixed (neovimUtils.makeNeovimConfig {
    extraLuaPackages = luaPackages:
      with luaPackages; [
        # keep
      ];
    # withNodeJs = true;
    # withPython3 = true;
    extraPython3Packages = pythonPackages:
      with pythonPackages; [
        # keep
      ];
    customRC = ''
      set rtp+=${nvchad-src}
      :luafile ${nvchad-src}/init.lua
    '';
  })
