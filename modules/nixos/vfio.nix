{ config
, pkgs
, lib
, ...
}:
# https://old.reddit.com/r/VFIO/comments/p42x2k/single_gpu_etclibvirthooksqemu_hook_is_never/
# https://gitlab.com/Karuri/vfio
let
  # Configuration
  my-iommu-group = [
    "pci_0000_01_00_0"
    "pci_0000_01_00_1"
    "pci_0000_01_00_2"
    "pci_0000_01_00_3"
  ];

  memory = 16384;
  Hugepagesize = 2048;
  # $ grep Hugepagesize /proc/meminfo
  my-network = "virbr0";
  vlmcsd-port = 1688;

  # Scripts
  lsiommu = pkgs.writeShellScriptBin "lsiommu" ''
    shopt -s nullglob
    for g in /sys/kernel/iommu_groups/*; do
      echo "IOMMU Group ''${g##*/}:"
      for d in $g/devices/*; do
          echo -e "\t$(lspci -nns ''${d##*/})"
      done;
    done;
  '';
  # https://gitlab.com/Karuri/vfio/-/blob/master/alloc_hugepages.sh
  alloc_hugepages = ''
    echo "Allocating hugepages..."
    HUGEPAGES=${builtins.toString (memory / (Hugepagesize / 1024))}
    echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
    ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

    TRIES=0
    while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 10 ))
    do
        echo 1 > /proc/sys/vm/compact_memory            ## defrag ram
        echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
        ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
        echo "Succesfully allocated $ALLOC_PAGES / $HUGEPAGES"
        let TRIES+=1
    done

    if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
    then
        echo "Not able to allocate all hugepages. Reverting..."
        echo 0 > /proc/sys/vm/nr_hugepages
        exit 1
    fi
  '';

  qemu-entrypoint = pkgs.writeShellScriptBin "qemu" ''
    # Author: Sebastiaan Meijer (sebastiaan@passthroughpo.st)
    #
    # Copy this file to /etc/libvirt/hooks, make sure it's called "qemu".
    # After this file is installed, restart libvirt.
    # From now on, you can easily add per-guest qemu hooks.
    # Add your hooks in /etc/libvirt/hooks/qemu.d/vm_name/hook_name/state_name.
    # For a list of available hooks, please refer to https://www.libvirt.org/hooks.html

    export PATH="$PATH:${pkgs.findutils}/bin:${pkgs.bash}/bin:${pkgs.util-linux}/bin"

    GUEST_NAME="$1"
    HOOK_NAME="$2"
    STATE_NAME="$3"
    MISC="''${@:4}"

    BASEDIR="$(dirname $0)"

    HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

    set -e # If a script exits with an error, we should as well.

    # check if it's a non-empty executable file
    if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH"] && [ -x "$HOOKPATH" ]; then
        eval \"$HOOKPATH\" "$@"
    elif [ -d "$HOOKPATH" ]; then
        while read file; do
            # check for null string
            if [ ! -z "$file" ]; then
              # Log the hook execution
              mkdir -p /var/log/libvirt/hooks
              script /var/log/libvirt/hooks/$GUEST_NAME-$HOOK_NAME-$STATE_NAME.log bash -c "$file $@"
            fi
        done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
    fi
  '';

  hook-prepare-iommu = pkgs.writeShellScriptBin "start.sh" ''
    export PATH="$PATH:${pkgs.kmod}/bin:${pkgs.systemd}/bin:${pkgs.libvirt}/bin"
    set -uxo pipefail
    echo $(date)
    # Change to performance governor
    echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    # Isolate host to core 0
    systemctl set-property --runtime -- user.slice AllowedCPUs=6,14,7,15
    systemctl set-property --runtime -- system.slice AllowedCPUs=6,14,7,15
    systemctl set-property --runtime -- init.scope AllowedCPUs=6,14,7,15
    # Stop display manager
    systemctl stop display-manager.service
    # Unbind VTconsoles
    echo 0 > /sys/class/vtconsole/vtcon0/bind
    echo 0 > /sys/class/vtconsole/vtcon1/bind
    # Unbind EFI Framebuffer
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
    sleep 1
    echo 3 > /proc/sys/vm/drop_caches
    sleep 1
    # Unload all Nvidia drivers
    modprobe -r nvidia_drm
    modprobe -r nvidia_modeset
    modprobe -r drm_kms_helper
    modprobe -r nvidia
    modprobe -r i2c_nvidia_gpu
    modprobe -r drm
    # Detach GPU devices from host
    ${
    lib.concatMapStringsSep "\n" (dev: "virsh nodedev-detach ${dev}")
    my-iommu-group
  }
    # Load vfio module
    modprobe vfio-pci
    ${alloc_hugepages}
    systemctl start vlmcsd.service
  '';

  hook-prepare-windows = pkgs.writeShellScriptBin "start.sh" ''
    export PATH="$PATH:${pkgs.systemd}/bin"
    systemctl start vlmcsd.service
  '';

  hook-release-iommu = pkgs.writeShellScriptBin "stop.sh" ''
    export PATH="$PATH:${pkgs.kmod}/bin:${pkgs.systemd}/bin:${pkgs.libvirt}/bin"
    set -ux -o pipefail
    # Unload vfio module
    modprobe -r vfio-pci
    # Attach GPU devices from host
    ${
    lib.concatMapStringsSep "\n" (dev: "virsh nodedev-reattach ${dev}")
    my-iommu-group
  }
    # Load nvidia drivers
    modprobe nvidia_drm
    modprobe nvidia_modeset
    modprobe drm_kms_helper
    modprobe nvidia
    modprobe i2c_nvidia_gpu
    modprobe drm
    # Bind EFI Framebuffer
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind
    # Bind VTconsoles
    echo 1 > /sys/class/vtconsole/vtcon0/bind
    echo 1 > /sys/class/vtconsole/vtcon1/bind
    # Start display manager
    systemctl start display-manager.service
    # Return host to all cores
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-15
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-15
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-15
    # Change to powersave governor
    echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    # Dealloc hugepages
    echo 0 > /proc/sys/vm/nr_hugepages
    systemctl stop vlmcsd.service
  '';

  hook-release-windows = pkgs.writeShellScriptBin "stop.sh" ''
    export PATH="$PATH:${pkgs.systemd}/bin"
    systemctl stop vlmcsd.service
  '';
in
{
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
  boot.kernelModules = [ "kvm-intel" "vfio-pci" ];
  environment.systemPackages = [ lsiommu ];

  systemd.services.vlmcsd.script = "${pkgs.vlmcsd}/bin/vlmcsd -L 192.168.122.1:${builtins.toString vlmcsd-port} -e -D";
  networking.firewall.interfaces.${my-network}.allowedUDPPorts = [ vlmcsd-port ];

  systemd.tmpfiles.rules = [
    "L+ /var/lib/libvirt/hooks/qemu - - - - ${qemu-entrypoint}/bin/qemu"
    "L+ /var/lib/libvirt/hooks/qemu.d/windows-nvidia/prepare/begin/start.sh - - - - ${
      hook-prepare-iommu
    }/bin/start.sh"
    "L+ /var/lib/libvirt/hooks/qemu.d/windows-nvidia/release/end/stop.sh - - - - ${
      hook-release-iommu
    }/bin/stop.sh"
    "L+ /var/lib/libvirt/hooks/qemu.d/windows-qxl/prepare/begin/start.sh - - - - ${
      hook-prepare-windows
    }/bin/start.sh"
    "L+ /var/lib/libvirt/hooks/qemu.d/windows-qxl/release/end/stop.sh - - - - ${
      hook-release-windows
    }/bin/stop.sh"
  ];

  services.openssh = {
    enable = true;
    listenAddresses = [
      {
        addr = "192.168.122.1";
        port = 22;
      }
    ];
  };
}
