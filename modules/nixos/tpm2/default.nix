# https://wiki.gentoo.org/wiki/Trusted_Platform_Module/SSH#Key_Creation
{
  pkgs,
  config,
  ...
}: let
  pkcs11pkg = pkgs.tpm2-pkcs11.override {fapiSupport = false;};
  cmdname = "git-key-command";
in {
  environment.systemPackages = with pkgs; [
    sbctl
    dmidecode
    (pkgs.runCommandLocal cmdname {} ''
      mkdir -p $out/bin
      cp -v ${./git-key-command.sh} $out/bin/${cmdname}
      patchShebangs --host $out/bin/*
    '')
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

  programs.ssh = {agentPKCS11Whitelist = "${pkcs11pkg}/lib/*";};

  users.groups."tss".members = config.users.groups."wheel".members;

  programs.git.config = {
    commit.gpgsign = true;
    gpg = {
      format = "ssh";
      ssh.defaultKeyCommand = cmdname;
    };
  };
}
