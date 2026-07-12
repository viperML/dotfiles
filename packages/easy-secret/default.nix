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
  text = builtins.readFile ./easy-secret.sh;
  bashOptions = [];
}
