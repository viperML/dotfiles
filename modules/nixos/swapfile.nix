{ pkgs, ... }:
let
  swapfile = "/swapfile";
in
{
  swapDevices = [ { device = swapfile; } ];

  systemd.services.create-swapfile = {
    serviceConfig.Type = "oneshot";
    requiredBy = [ "swapfile.swap" ];
    before = [ "swapfile.swap" ];
    path = with pkgs; [
      coreutils
      e2fsprogs
      util-linux
    ];
    script = ''
      set -x
      if [[ ! -f ${swapfile} ]]; then
        dd if=/dev/zero of=${swapfile} bs=1M count=4k status=progress
        chmod 0600 ${swapfile}
        mkswap -U clear ${swapfile}
      fi
    '';
  };
}
