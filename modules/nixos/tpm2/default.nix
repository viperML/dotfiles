# https://wiki.gentoo.org/wiki/Trusted_Platform_Module/SSH#Key_Creation
{
  pkgs,
  config,
  lib,
  ...
}:
let
  pkcs11pkg = pkgs.tpm2-pkcs11.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [
      "--with-fapi=no"
    ];
  });
  # pkcs11pkg = pkgs.tpm2-pkcs11-esapi;
  cmdname = "tpm-add";
  cmd =
    pkgs.runCommandLocal cmdname
      {
        meta.mainProgram = cmdname;
      }
      ''
        mkdir -p $out/bin
        cp -v ${./tpm-add.sh} $out/bin/${cmdname}
        patchShebangs --host $out/bin/*
      '';
in
{
  environment.systemPackages = [
    pkgs.sbctl
    pkgs.dmidecode
    cmd
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
      # interface = "tabrmd";
    };
  };

  programs.ssh = {
    agentPKCS11Whitelist = "${pkcs11pkg}/lib/*";
  };

  users.groups."tss".members = config.users.groups."wheel".members;

  programs.git.config = {
    commit.gpgsign = true;
    # Lightweight tags are not signed
    # tag.gpgsign = true;
    gpg = {
      format = "ssh";
      ssh.defaultKeyCommand = cmdname;
    };
  };

  systemd.user.services."ssh-reconfigure" = {
    wantedBy = [ "ssh-agent.service" ];
    after = [ "ssh-agent.service" ];
    path = [
      config.programs.ssh.package
    ];
    script = ''
      if [[ ! -d ~/.local/share/tpm2-pkcs11 ]]; then
        # TODO
        echo ":: Reconfiguring SSH-TPM2"
      else
        echo ":: SSH-TPM2 already configured"
      fi

      export SSH_AUTH_SOCK=/run/user/$(id -u)/ssh-agent
      ${lib.getExe cmd}
    '';
    serviceConfig = {
      Type = "simple";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = "1s";
    };
  };
}
