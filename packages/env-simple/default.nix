{
  stdenv,
  nixMaidWith,
  env-viper,
  formats,
  nix,
}:
let
  maid = nixMaidWith {
    imports = [
      ../../modules/maid/common.nix
    ];

    file.home.".bashrc".text = ''
      export D="$HOME/dotfiles"

      if [[ -t 0 ]]; then
        exec fish
      fi
    '';

    file.home.".bash_profile".text = ''
      if [[ -t 0 ]] && [[ -z $ZELLIJ_SESSION_NAME ]]; then
        exec zellij attach -c main
      fi
    '';

    file.xdg_config."nix/nix.conf".source =
      (formats.nixConf {
        package = nix;
        inherit (nix) version;
        checkAllErrors = true;
        checkConfig = true;
      }).generate
        "nix.conf"
        {
          extra-experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];
        };
  };
in
stdenv.mkDerivation {
  name = "env-simple";
  dontUnpack = true;
  buildPhase = "mkdir $out";
  propagatedUserEnvPkgs = [
    maid
    env-viper
  ];
}
