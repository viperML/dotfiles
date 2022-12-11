{river, symlinkJoin}: symlinkJoin {
  paths = [river];
  inherit (river) name pname version;
  __nocachix = true;
  postBuild = ''
    mkdir -p $out/share/wayland-sessions
    tee $out/share/wayland-sessions/river.desktop <<EOF
    [Desktop Entry]
    Name=River
    Comment=River
    Exec=river
    Type=Application
    EOF
  '';
  passthru.providedSessions = ["river"];
}
