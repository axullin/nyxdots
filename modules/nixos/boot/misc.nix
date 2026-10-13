{
  flake.modules.nixos.boot =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    let
      cfg = config.nyx.boot;
    in
    {
      options.nyx.boot.cachyosKernel.enable = lib.mkEnableOption "Use the cachyos kernel";
      options.nyx.boot.silent-boot.enable = lib.mkEnableOption "a quiet boot";

      config = lib.mkMerge [
        {
          boot = {
            kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
            supportedFilesystems = [ "ntfs" ];
            kernelParams = [ "boot.shell_on_fail" ];
          };
        }

        (lib.mkIf cfg.silent-boot.enable {
          boot = {
            initrd.verbose = false;
            consoleLogLevel = 0;
            kernelParams = [
              "quiet"
              "console=tty3"
              "splash"
              "systemd.show_status=false"
              "loglevel=3"
              "rd.systemd.show_status=false"
              "vt.global_cursor_default=0"
              "rd.udev.log_level=3"
              "udev.log_priority=3"
            ];
          };
        })

        (lib.mkIf cfg.cachyosKernel.enable {
          nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
          boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
        })
      ];
    };
}
