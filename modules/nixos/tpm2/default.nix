# https://wiki.gentoo.org/wiki/Trusted_Platform_Module/SSH#Key_Creation
{
  pkgs,
  config,
  lib,
  ...
}:
let
  pkcs11pkg = pkgs.tpm2-pkcs11.override { fapiSupport = false; };
in
{
  environment.systemPackages = with pkgs; [
    sbctl
    dmidecode
  ];

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
    pkcs11 = {
      enable = true;
      package = pkcs11pkg;
    };
    tctiEnvironment = {
      enable = true;
      interface = "tabrmd";
    };
  };

  programs.ssh = {
    agentPKCS11Whitelist = "${pkcs11pkg}/lib/*";
  };

  users.groups."tss".members = config.users.groups."wheel".members;

  home-manager.sharedModules =
    let
      cmdname = "git-key-command";
    in
    [
      {
        home.packages = [
          (pkgs.runCommandLocal cmdname { } ''
            mkdir -p $out/bin
            cp -v ${./git-key-command.sh} $out/bin/${cmdname}
            patchShebangs --host $out/bin/*
          '')
        ];
        xdg.configFile."git/config".text = lib.mkAfter ''
          [gpg "ssh"]
              defaultKeyCommand = ${cmdname}
          [gpg]
              format = ssh
          [commit]
              gpgsign = true
        '';
      }
    ];
}
