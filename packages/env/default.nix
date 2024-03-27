{ buildEnv, helix }:
buildEnv {
  name = "env";
  paths = [ helix ];
}
