{
  wezterm,
  symlinkJoin,
  makeBinaryWrapper,
}:
symlinkJoin {
  inherit (wezterm) name pname version meta;
  paths = [wezterm];
  nativeBuildInputs = [makeBinaryWrapper];

  postBuild = ''
    wrapProgram $out/bin/wezterm \
      --set-default WEZTERM_CONFIG_FILE ${./wezterm.lua}
  '';
}
