{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.single-gpu-passthrough;

  encapsulateStr = value: "\"${value}\"";
  listToSpacedStr = list: builtins.concatStringsSep " " (map encapsulateStr list);

  machinesStr = listToSpacedStr cfg.machines;

  attachHookCommands = builtins.concatStringsSep "\n  " (mapAttrsToList (name: value: "binddriver \"${name}\" \"${value}\"") cfg.pciDevices);
  detachHookCommands = builtins.concatStringsSep "\n  " (mapAttrsToList (name: value: "binddriver \"${name}\" \"vfio-pci\"") cfg.pciDevices);
  mountPointStr = listToSpacedStr cfg.mountpoints;

  modules = lib.lists.flatten [
    (map toString cfg.extraModules)
    (mapAttrsToList (name: value: toString value) cfg.pciDevices)
  ];
  modulesStr = listToSpacedStr (lib.lists.unique modules);

  hookInstaller = pkgs.writers.writeBashBin "installer" ''
    hookPath="/var/lib/libvirt/hooks/qemu"
    mkdir -p $(dirname $hookPath)

    [ -f "$hookPath" ] && mv "$hookPath" "''${hookPath}.stateful"
    ln -svf "${qemuHook}/bin/qemu" "$hookPath"

    exit 0
  '';

  qemuHook = pkgs.writers.writeBashBin "qemu" ''
    function binddriver() {
      busid=$1
      driver=$2

      if [ -z "$busid" ] || [ -z "$driver" ]; then
        return
      fi

      devPath="/sys/bus/pci/devices/$busid"
      vendor=$(cat "$devPath/vendor")
      product=$(cat "$devPath/device")
      id="''${vendor#"0x"} ''${product#"0x"}"

      driverPath="/sys/bus/pci/drivers/$driver"

      if [ -e $driverPath ]; then
        echo "Attempting to bind $driver to $devPath"

        # Prime for switching to a new driver
        echo $id > $driverPath/new_id

        # Unbind from the current driver
        echo "Unbinding $devPath from its driver"
        echo $busid > $devPath/driver/unbind

        # Bind to the new driver
        echo "Binding $devPath to $driver"
        echo $busid > $driverPath/bind

        # Finalize driver switch
        echo "Finalizing driver switch for $devPath"
        echo $id > $driverPath/remove_id

        echo "$driver successfully bound to $devPath"
      else
        echo "Driver '$driver' does not exist, nothing was switched."
      fi
    }

    function detach() {
      systemctl stop display-manager
      sleep 1

      # Kill the console
      echo 0 > /sys/class/vtconsole/vtcon0/bind
      echo 0 > /sys/class/vtconsole/vtcon1/bind
      echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

      for mountpoint in ${mountPointStr}; do
        umount $mountpoint
      done

      modprobe vfio-pci

      ${detachHookCommands}
    }

    function attach() {
      # Unload VFIO drivers
      for driver in "vfio" "vfio_pci" "vfio_iommu_type1"; do
        rmmod $driver
      done;

      for driver in ${modulesStr}; do
        modprobe $driver
      done

      ${attachHookCommands}

      for mountpoint in ${mountPointStr}; do
        mount $mountpoint
      done

      # Reload the framebuffer and console
      echo 1 > /sys/class/vtconsole/vtcon0/bind
      echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

      systemctl start display-manager
    }

    GUEST_NAME="$1"
    HOOK_NAME="$2"
    STATE_NAME="$3"
    MISC="''${@:4}"

    function invoke_hook() {
      case $HOOK_NAME in
        "prepare")
          if [ "$STATE_NAME" == "begin" ]; then
            detach
          fi
        ;;
        "release")
          if [ "$STATE_NAME" == "end" ]; then
            attach
          fi
        ;;
      esac
    }

    for vm in ${machinesStr}; do
      if [ "$vm" == "$GUEST_NAME" ]; then
        invoke_hook
      fi
    done
  '';

in {
  options = {
    services.single-gpu-passthrough = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables declarative libvirt hooks
        '';
      };

      machines = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          All machines that the virtual machines will use single GPU passthrough.
        '';
      };

      pciDevices = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = ''
          The drivers to bind while one of the virtual machines is running.
        '';
      };

      extraModules = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Additional modules to be probed when returning to default state.
        '';
      };

      mountpoints = mkOption {
        type = with types; listOf path;
        default = [];
        description = ''
          Mount points to be unmounted from the host while the guest is running.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.libvirtd = {
      preStart = "${hookInstaller}/bin/installer";
      path = with pkgs; [ kmod util-linux ];
    };
  };
}
