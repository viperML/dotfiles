{
  wezterm,
  symlinkJoin,
  makeBinaryWrapper,
}:
symlinkJoin {
  inherit (wezterm) name pname version;
  paths = [wezterm];
  nativeBuildInputs = [makeBinaryWrapper];
  __nocachix = true;
  postBuild = ''
    wrapProgram $out/bin/wezterm \
      --set-default WEZTERM_CONFIG_FILE ${./wezterm.lua}
  '';
}
