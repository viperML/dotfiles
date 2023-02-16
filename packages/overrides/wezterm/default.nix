{
  wezterm,
  symlinkJoin,
  makeBinaryWrapper,
}: let
  myWezterm = wezterm.overrideAttrs (old: {
    doCheck = builtins.trace "https://github.com/NixOS/nixpkgs/issues/216394" false;
  });
in
  symlinkJoin {
    inherit (myWezterm) name pname version;
    paths = [myWezterm];
    nativeBuildInputs = [makeBinaryWrapper];
    __nocachix = true;
    postBuild = ''
      wrapProgram $out/bin/wezterm \
        --set-default WEZTERM_CONFIG_FILE ${./wezterm.lua}
    '';
  }
