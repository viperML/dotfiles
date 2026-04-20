with import <nixpkgs> { };

hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hyprland-virtual-desktops";
  version = "9999";
  src = fetchFromGitHub {
    owner = "levnikmyskin";
    repo = "hyprland-virtual-desktops";
    rev = "2b95f38b6f5c90414ce637f5ba0ed43f1e1db5e1";
    hash = "sha256-ksH57OOm37XdoovMpKwLr4xNIfaqGZEG5riHXLaN//I=";
  };
  nativeBuildInputs = [ cmake ];

  meta = {};
}
