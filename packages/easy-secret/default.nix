{
  writeShellApplication,
  coreutils,
  libsecret,
}:
writeShellApplication {
  name = "easy-secret";
  runtimeInputs = [
    coreutils
    libsecret
  ];
}
