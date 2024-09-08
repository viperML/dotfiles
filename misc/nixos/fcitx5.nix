{pkgs, ...}: let
  cfg.package = pkgs.fcitx5-with-addons.override {
    addons = with pkgs; [fcitx5-gtk fcitx5-mozc];
  };

  gtk2_cache =
    pkgs.runCommand "gtk2-immodule.cache" {
      preferLocalBuild = true;
      allowSubstitutes = false;
      buildInputs = [pkgs.gtk2 cfg.package];
    } ''
      mkdir -p $out/etc/gtk-2.0/
      GTK_PATH=${cfg.package}/lib/gtk-2.0/ gtk-query-immodules-2.0 > $out/etc/gtk-2.0/immodules.cache
    '';

  gtk3_cache =
    pkgs.runCommand "gtk3-immodule.cache" {
      preferLocalBuild = true;
      allowSubstitutes = false;
      buildInputs = [pkgs.gtk3 cfg.package];
    } ''
      mkdir -p $out/etc/gtk-3.0/
      GTK_PATH=${cfg.package}/lib/gtk-3.0/ gtk-query-immodules-3.0 > $out/etc/gtk-3.0/immodules.cache
    '';
in {
  environment.systemPackages = [cfg.package gtk2_cache gtk3_cache];

  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}
