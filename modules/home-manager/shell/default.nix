{packages, ...}: {
  home.packages = [
    packages.self.vshell
    packages.self.neofetch
  ];
}
