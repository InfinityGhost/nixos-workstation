{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [
      "nohibernate"
      "amd_iommu=on"
      "iommu=pt"
      "pcie_acs_override=downstream,multifunction"
      "zfs.zfs_arc_max=17179869184" # 16 GiB
#      "rd.driver.pre=vfio_pci"
#      "video=efifb:off,vesafb:off,vesa:off"
#      "amdgpu.ppfeaturemask=0xffffffff"
    ];

    extraModprobeConfig = ''
      options kvm ignore_msrs=Y
      options kvm report_ignored_msrs=N
    '';
  };

  boot.initrd.availableKernelModules = [ "nvidia" "amdgpu" "vfio-pci" ];
  boot.initrd.preDeviceCommands = ''
    DEVS="0000:2f:00.0"

    if [ ! -z "$(ls -A /sys/class/iommu)" ]; then
      for DEV in $DEVS; do
        for IOMMUDEV in $(ls /sys/bus/pci/devices/$DEV/iommu_group/devices) ; do
          echo "vfio-pci" > /sys/bus/pci/devices/$IOMMUDEV/driver_override
        done
      done
    fi

    modprobe -i vfio-pci
  '';
}
