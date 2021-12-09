{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.single-gpu-passthrough;

  displayManagerService = 
    if config.services.xserver.displayManager.gdm.enable then "display-manager"
    else null;

  # Invoked every time the helper service starts to enforce the driver hook
  hookInstaller = pkgs.writers.writeBashBin "qemu-hook-installer" ''
    hookPath="${cfg.qemuHookPath}"

    # Create hook directory if needed
    mkdir -p $(dirname $hookPath)

    # Back up any imperative hooks
    [ -f "$hookPath" ] && [ ! -h "$hookPath" ] && mv "$hookPath" "''${hookPath}.stateful"
    
    # Link declarative hook
    [ -h "$hookPath" ] && rm "$hookPath"
    ln -sf "${qemuHook}/bin/qemu" $hookPath

    exit 0
  '';

  encapsulateStr = value: "\"${value}\"";
  listToSpacedStr = list: builtins.concatStringsSep " " (map encapsulateStr list);

  machinesStr = listToSpacedStr cfg.machines;

  attachHookCommands = builtins.concatStringsSep "\n  " (mapAttrsToList (name: value: "binddriver \"${name}\" \"${value}\"") cfg.pciDevices);
  detachHookCommands = builtins.concatStringsSep "\n  " (mapAttrsToList (name: value: "binddriver \"${name}\" \"vfio-pci\"") cfg.pciDevices);

  modules = lib.lists.flatten [
    (map toString cfg.extraModules)
    (mapAttrsToList (name: value: toString value) cfg.pciDevices)
  ];
  modulesStr = listToSpacedStr (lib.lists.unique modules);

  qemuHook = pkgs.writers.writeBashBin "qemu" ''
    displaymanager="${displayManagerService}"

    drivers=(${modulesStr})
    vfiodrivers=("vfio" "vfio_pci" "vfio_iommu_type1")

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

    function predetach() {
      # Kill Display Manager
      systemctl stop $displaymanager
      sleep 1

      # Kill the console
      echo 0 > /sys/class/vtconsole/vtcon0/bind
      echo 0 > /sys/class/vtconsole/vtcon1/bind
      echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

      # Load VFIO driver
      modprobe vfio-pci
    }

    function detach() {
      predetach
      ${detachHookCommands}
    }

    function preattach() {
      # Unload VFIO drivers
      for driver in ''${vfiodrivers[@]}; do
        rmmod $driver
      done;

      # Load normal drivers
      for driver in ''${drivers[@]}; do
        modprobe $driver
      done;
    }

    function attach() {
      # Do everything before attaching
      preattach
      ${attachHookCommands}
      # Do everything needed after attaching drivers
      postattach
    }

    function postattach() {
      # Reload the framebuffer and console
      echo 1 > /sys/class/vtconsole/vtcon0/bind
      echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

      # Reload the Display Manager
      systemctl start $displaymanager
    }

    BASEDIR="$(dirname $0)"
    GUEST_NAME="$1"
    HOOK_NAME="$2"
    STATE_NAME="$3"
    MISC="''${@:4}"

    ENABLED_VMS=(${machinesStr})

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

    for VM in ''${ENABLED_VMS[@]}; do
      if [ "$VM" == "$GUEST_NAME" ]; then
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

      qemuHookPath = mkOption {
        type = types.path;
        default = "/var/lib/libvirt/hooks/qemu";
        description = ''
          The path in which the libvirt qemu hook is located.
          This shouldn't ever need to be changed.
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
    };
  };

  config = mkIf cfg.enable {
    systemd.services.single-gpu-passthrough = {
      description = "Single GPU passthrough helper service";
      wantedBy = [ "multi-user.target" ];
      enable = true;

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${hookInstaller}/bin/qemu-hook-installer";
        RemainAfterExit = "true";
        Restart = "no";
      };
    };
  };
}