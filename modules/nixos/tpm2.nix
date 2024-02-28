{ pkgs
, config
, ...
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
}
