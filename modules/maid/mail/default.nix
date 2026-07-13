{ pkgs, config, ... }:
let
  targets = [ config.maid.systemdTarget ];
in
{
  packages = with pkgs; [
    mu
    isync
    msmtp
    imapfilter
    (pkgs.writeShellScriptBin "fetch-mail" ''
      set -ex
      imapfilter
      mbsync -a
    '')
  ];

  systemd.tmpfiles.dynamicRules = [
    "d {{home}}/mail 0755 {{user}} {{group}} - -"
  ];

  file.home = {
    # FIXME don't .toString
    ".imapfilter/config.lua".source = ./imapfilter.lua;
  };

  file.xdg_config = {
    "isyncrc".text = ''
      IMAPAccount BSC
      Host mail.bsc.es
      Port 993
      User fayats@bsc.es
      PassCmd "easy-secret bsc-password"
      # One can use a command which returns the password
      # Such as a password manager or a bash script
      #PassCmd sh script/path
      TLSType IMAPS

      IMAPStore BSC
      Account BSC

      MaildirStore local
      Subfolders Verbatim
      Path ~/mail/
      Inbox ~/mail/Inbox

      Channel primary
      Far :BSC:
      Near :local:
      Patterns *
      Expunge Both
      Create Both
      CopyArrivalDate yes
      Sync All
      SyncState *
    '';

    "msmtp/config".text = ''
      account BSC
      host mail.bsc.es
      port 465
      tls on
      tls_starttls off
      auth on
      user fayats
      from fayats@bsc.es
      passwordeval "easy-secret bsc-password"

      account default : BSC
    '';
  };

  systemd.services = {
    isync = {
      script = ''
        if [[ -d "$HOME/mail" ]]; then
          mbsync -aV
          mu index
        else
          echo ":: ~/mail doesn't exist, skipping"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-abnormal";
      };
      path = [
        pkgs.isync
        pkgs.mu
      ];
      partOf = targets;
      after = targets;
      wantedBy = targets;
      # TODO: use goimapnotify
      # Every 15 minutes
      # startAt = "*-*-* *:00/15:00";
    };
  };

  # systemd.timers = {
  #   isync = {
  #     timerConfig = {
  #       Persistent = true;
  #     };
  #   };
  # };
}
