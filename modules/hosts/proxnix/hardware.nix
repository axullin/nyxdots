{
  flake.modules.nixos.proxnix =
    { modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      boot.initrd.availableKernelModules = [
        "uhci_hcd"
        "ehci_pci"
        "ahci"
        "sd_mod"
        "sr_mod"
      ];

      boot.kernelModules = [ "kvm-amd" ];

      services.qemuGuest.enable = true;
    };
}
