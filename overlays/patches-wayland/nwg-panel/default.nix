{
  lib,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook,
  gobject-introspection,
  gtk-layer-shell,
  pango,
  gdk-pixbuf,
  atk,
  # Extra packages called by various internal nwg-panel modules
  sway, # swaylock, swaymsg
  systemd, # systemctl
  wlr-randr, # wlr-randr
  nwg-menu, # nwg-menu
  light, # light
  pamixer, # pamixer
  pulseaudio, # pactl
}:
python3Packages.buildPythonApplication rec {
  pname = "nwg-panel";
  version = "unstable-2022-02-22";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-panel";
    rev = "eb1877e82998a598950934d15c00bdcb5c25bb07";
    sha256 = "1ikypghj3za9d02v769zrc4g4lr5i47pzdgrq7n2985mdr2x9xw9";
  };

  # No tests
  doCheck = false;

  # Because of wrapGAppsHook
  strictDeps = false;
  dontWrapGApps = true;

  buildInputs = [atk gdk-pixbuf gtk-layer-shell pango];
  nativeBuildInputs = [wrapGAppsHook gobject-introspection];
  propagatedBuildInputs = with python3Packages; [i3ipc netifaces psutil pybluez pygobject3 dasbus];

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}
    cp $src/nwg-panel-config.desktop $out/share/applications/
    cp $src/nwg-shell.svg $src/nwg-panel.svg $out/share/pixmaps/
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix XDG_DATA_DIRS : "$out/share"
      --prefix PATH : "${lib.makeBinPath [light nwg-menu pamixer pulseaudio sway systemd wlr-randr]}"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/nwg-piotr/nwg-panel";
    description = "GTK3-based panel for Sway window manager";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [berbiche];
  };
}
