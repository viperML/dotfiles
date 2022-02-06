{ config, pkgs, ... }:
# https://old.reddit.com/r/VFIO/comments/p42x2k/single_gpu_etclibvirthooksqemu_hook_is_never/
# https://gitlab.com/Karuri/vfio
let
  my-iommu-group = [
    "pci_0000_01_00_0"
    "pci_0000_01_00_1"
    "pci_0000_01_00_2"
    "pci_0000_01_00_3"
  ];
  vfio-enabled-machines = [
    "windows-nvidia"
  ];
  lsiommu = pkgs.writeShellScriptBin "lsiommu" ''
    shopt -s nullglob
    for g in /sys/kernel/iommu_groups/*; do
      echo "IOMMU Group ''${g##*/}:"
      for d in $g/devices/*; do
          echo -e "\t$(lspci -nns ''${d##*/})"
      done;
    done;
  '';
  memory = "16384"; # in MiB
  hugepages = "8192";
  # https://gitlab.com/Karuri/vfio/-/blob/master/alloc_hugepages.sh
  alloc_hugepages = pkgs.writeShellScriptBin "alloc_hugepages" ''
    set -uxo pipefail

    ## Calculate number of hugepages to allocate from memory (in MB)
    # HUGEPAGES="$((${memory}/$(($(grep Hugepagesize /proc/meminfo | awk '{print $2}')/1024))))"

    echo "Allocating hugepages..."
    HUGEPAGES=${hugepages}
    echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
    ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

    TRIES=0
    while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
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
  my-network = "virbr0";
  vlmcsd-port = 1688;
in
{
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
  boot.kernelModules = [ "kvm-intel" "vfio-pci" ];
  environment.systemPackages = [ lsiommu ];
  # virtualisation.libvirtd.qemu.swtpm.enable = true;

  systemd.services.libvirtd = {
    path =
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            ripgrep
            sd
          ];
        };
      in
      [ env ];
  };

  systemd.services.vlmcsd = {
    script = "${pkgs.vlmcsd}/bin/vlmcsd -L 192.168.122.1:${builtins.toString vlmcsd-port} -e -D";
  };

  networking.firewall.interfaces.${my-network}.allowedUDPPorts = [ vlmcsd-port ];

  system.activationScripts.libvirt-hooks.text = ''
    ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
  '';

  environment.etc = {
    "libvirt/hooks/qemu" = {
      text =
        ''
          #!/run/current-system/sw/bin/bash
          #
          # Author: Sebastiaan Meijer (sebastiaan@passthroughpo.st)
          #
          # Copy this file to /etc/libvirt/hooks, make sure it's called "qemu".
          # After this file is installed, restart libvirt.
          # From now on, you can easily add per-guest qemu hooks.
          # Add your hooks in /etc/libvirt/hooks/qemu.d/vm_name/hook_name/state_name.
          # For a list of available hooks, please refer to https://www.libvirt.org/hooks.html
          #

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
                    ${pkgs.util-linux}/bin/script /var/log/libvirt/hooks/$GUEST_NAME-$HOOK_NAME-$STATE_NAME.log ${pkgs.bash}/bin/bash -c "$file $@"
                  fi
              done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
          fi
        '';
      mode = "0755";
    };
  }
  //
  builtins.listToAttrs (map
    (x: {
      name = "libvirt/hooks/qemu.d/${x}/prepare/begin/start.sh";
      value = {
        text = ''
          #!/run/current-system/sw/bin/bash
          set -uxo pipefail

          # Change to performance governor
          echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

          # Isolate host to core 0
          systemctl set-property --runtime -- user.slice AllowedCPUs=0
          systemctl set-property --runtime -- system.slice AllowedCPUs=0
          systemctl set-property --runtime -- init.scope AllowedCPUs=0

          # Stop display manager
          systemctl stop display-manager.service

          # Unbind VTconsoles
          echo 0 > /sys/class/vtconsole/vtcon0/bind
          echo 0 > /sys/class/vtconsole/vtcon1/bind

          # Unbind EFI Framebuffer
          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

          # Avoid race condition
          # sleep 5

          # Unload all Nvidia drivers
          modprobe -r nvidia_drm
          modprobe -r nvidia_modeset
          modprobe -r drm_kms_helper
          modprobe -r nvidia
          modprobe -r i2c_nvidia_gpu
          modprobe -r drm


          # Detach GPU devices from host
          ${builtins.concatStringsSep "\n" (builtins.map (x: "virsh nodedev-detach " + x) my-iommu-group)}

          # Load vfio module
          modprobe vfio-pci

          ${alloc_hugepages}/bin/alloc_hugepages

          ${pkgs.systemd}/bin/systemctl start vlmcsd.service
        '';
        mode = "0755";
      };
    })
    vfio-enabled-machines)
  //
  builtins.listToAttrs (map
    (x: {
      name = "libvirt/hooks/qemu.d/${x}/release/end/stop.sh";
      value = {
        text = ''
          #!/run/current-system/sw/bin/bash
          set -ux -o pipefail

          # Unload vfio module
          modprobe -r vfio-pci

          # Attach GPU devices from host
          ${builtins.concatStringsSep "\n" (builtins.map (x: "virsh nodedev-reattach " + x) my-iommu-group)}

          # Read nvidia x config
          # nvidia-xconfig --query-gpu-info > /dev/null 2>&1

          # Load NVIDIA kernel modules
          # Load nvidia drivers
          modprobe nvidia_drm
          modprobe nvidia_modeset
          modprobe drm_kms_helper
          modprobe nvidia
          modprobe i2c_nvidia_gpu
          modprobe drm

          # Avoid race condition
          # sleep 5

          # Bind EFI Framebuffer
          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

          # Bind VTconsoles
          echo 1 > /sys/class/vtconsole/vtcon0/bind
          echo 1 > /sys/class/vtconsole/vtcon1/bind

          # Start display manager
          systemctl start display-manager.service

          # Return host to all cores
          systemctl set-property --runtime -- user.slice AllowedCPUs=0-3
          systemctl set-property --runtime -- system.slice AllowedCPUs=0-3
          systemctl set-property --runtime -- init.scope AllowedCPUs=0-3

          # Change to powersave governor
          echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

          # Dealloc hugepages
          echo 0 > /proc/sys/vm/nr_hugepages

          ${pkgs.systemd}/bin/systemctl stop vlmcsd.service
        '';
        mode = "0755";
      };
    })
    vfio-enabled-machines);
}
