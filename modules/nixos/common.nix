{ config, pkgs, inputs, ... }:

{
  system.stateVersion = "21.11";
  system.configurationRevision = (if inputs.self ? rev then inputs.self.rev else null);
  time.timeZone = "Europe/Madrid";

  nixpkgs.config = import ../nixpkgs.conf;
  nix = {
    package = pkgs.nix; # supports flakes in nixpkgs-unstable
    extraOptions = "${builtins.readFile ../nix.conf}";

    # from flake-utils-plus
    # Sets NIX_PATH to follow this flake's nix inputs
    # So legacy nix-channel is not needed
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };

  security.sudo = {
    extraConfig =
      let
        my-lecture = pkgs.writeTextFile {
          name = "my-lecture";
          text = ''

            [?7l[1m[34m      \\  \\ //
            [34m     ==\\__\\/ //
            [34m       //   \\//
            [34m    ==//     //==
            [34m     //\\___//
            [34m    // /\\  \\==
            [34m      // \\  \\

            [0m [[ you have angered the nix gods ]]

          '';
        };
      in
      ''
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH"
        Defaults timestamp_timeout=300
        Defaults lecture=always
        Defaults lecture_file=${my-lecture}
      '';
  };
}
