self: super: {
  kernelPackages = super.linuxPackages.zfs.package.latestCompatibleLinuxPackages;
}
