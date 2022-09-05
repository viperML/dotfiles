{
  config,
  pkgs,
  lib,
  self,
  packages,
  flakePath,
  ...
}:
# https://old.reddit.com/r/VFIO/comments/p42x2k/single_gpu_etclibvirthooksqemu_hook_is_never/
# https://gitlab.com/Karuri/vfio
let
  ## Configuration
  my-iommu-group = [
    "pci_0000_01_00_0"
    "pci_0000_01_00_1"
    "pci_0000_01_00_2"
    "pci_0000_01_00_3"
  ];

  my-kmods = [
    "nvidia_drm"
    "nvidia_modeset"
    "drm_kms_helper"
    "i2c_nvidia_gpu"
    "nvidia"
    "drm"
  ];

  memory = 16384;
  Hugepagesize = 2048;
  # $ grep Hugepagesize /proc/meminfo
  vlmcsd-port = 1688;

  myPath = flakePath;

  ## Scripts
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
  allocHugepages = ''
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

  qemuEntrypoint = pkgs.writeShellScript "qemu" ''
    # Author: Sebastiaan Meijer (sebastiaan@passthroughpo.st)
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

  windows-nvidia.hookPrepare = pkgs.writeShellScript "start.sh" ''
    export PATH="$PATH:${pkgs.kmod}/bin:${pkgs.systemd}/bin:${pkgs.libvirt}/bin"
    set -uxo pipefail
    echo $(date)
    # Change to performance governor
    echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
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
    # Unload all Nvidia drivers
    ${lib.concatMapStringsSep "\n" (kmod: "modprobe -r ${kmod}") my-kmods}
    # Detach GPU devices from host
    ${lib.concatMapStringsSep "\n" (dev: "virsh nodedev-detach ${dev}") my-iommu-group}
    # Load vfio module
    modprobe vfio-pci
    # Free host memory
    echo 3 > /proc/sys/vm/drop_caches
    sleep 1
    ${allocHugepages}
    # Start KMS license server
    systemctl start vlmcsd.service
  '';

  windows-qxl.hookPrepare = pkgs.writeShellScript "start.sh" ''
    export PATH="$PATH:${pkgs.systemd}/bin"
    systemctl start vlmcsd.service
  '';

  windows-nvidia.hookRelease = pkgs.writeShellScript "stop.sh" ''
    export PATH="$PATH:${pkgs.kmod}/bin:${pkgs.systemd}/bin:${pkgs.libvirt}/bin"
    set -ux -o pipefail
    # Unload vfio module
    modprobe -r vfio-pci
    # Attach GPU devices from host
    ${lib.concatMapStringsSep "\n" (dev: "virsh nodedev-reattach ${dev}") my-iommu-group}
    # Load nvidia drivers (may not be needed)
    ${lib.concatMapStringsSep "\n" (kmod: "modprobe ${kmod}") my-kmods}
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
    echo powersave > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    # Dealloc hugepages
    echo 0 > /proc/sys/vm/nr_hugepages
    # Stop KMS license server
    systemctl stop vlmcsd.service
  '';

  windows-qxl.hookRelease = pkgs.writeShellScript "stop.sh" ''
    export PATH="$PATH:${pkgs.systemd}/bin"
    # Stop KMS license server
    systemctl stop vlmcsd.service
  '';
in {
  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
  boot.kernelModules = ["kvm-intel" "vfio-pci"];
  environment.systemPackages = [lsiommu];

  systemd.services.vlmcsd.script = "${packages.self.vlmcsd}/bin/vlmcsd -L 192.168.122.1:${builtins.toString vlmcsd-port} -e -D";
  networking.firewall.interfaces.virbr0.allowedTCPPorts = [vlmcsd-port];
  networking.firewall.interfaces.virbr0.allowedUDPPorts = [vlmcsd-port];

  systemd.tmpfiles.rules = [
    "L+ /var/lib/libvirt/hooks/qemu - - - - ${qemuEntrypoint}"

    "L+ /var/lib/libvirt/qemu/windows-nvidia.xml - - - - ${myPath}/modules/nixos/vfio/windows-nvidia.xml"
    "L+ /var/lib/libvirt/hooks/qemu.d/windows-nvidia/prepare/begin/start.sh - - - - ${windows-nvidia.hookPrepare}"
    "L+ /var/lib/libvirt/hooks/qemu.d/windows-nvidia/release/end/stop.sh - - - - ${windows-nvidia.hookRelease}"

    "L+ /var/lib/libvirt/qemu/windows-qxl.xml - - - - ${myPath}/modules/nixos/vfio/windows-qxl.xml"
    "L+ /var/lib/libvirt/hooks/qemu.d/windows-qxl/prepare/begin/start.sh - - - - ${windows-qxl.hookPrepare}"
    "L+ /var/lib/libvirt/hooks/qemu.d/windows-qxl/release/end/stop.sh - - - - ${windows-qxl.hookRelease}"
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
