{
  extra-experimental-features = [
    "nix-command"
    "flakes"
  ];

  allow-import-from-derivation = false;

  builders-use-substitutes = true;

  connect-timeout = 5;
}
