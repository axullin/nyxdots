{
  flake.modules.nixos.hardware =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nyx.hardware.nvidia;
    in
    {
      options.nyx.hardware.nvidia = {
        enable = lib.mkEnableOption "the proprietary Nvidia driver";

        package = lib.mkOption {
          type = lib.types.package;
          default = config.boot.kernelPackages.nvidiaPackages.legacy_580;
          description = "Driver package, from config.boot.kernelPackages.nvidiaPackages";
        };
      };

      config = lib.mkIf cfg.enable {
        boot.initrd.kernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];

        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };
        hardware.graphics.extraPackages = with pkgs; [ nvidia-vaapi-driver ];
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          nvidiaSettings = true;
          open = false;
          inherit (cfg) package;
        };

        environment.sessionVariables = {
          GBM_BACKEND = "nvidia-drm";
          LIBVA_DRIVER_NAME = "nvidia";
          NVD_BACKEND = "direct";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          __GL_GSYNC_ALLOWED = "1";
          __GL_VRR_ALLOWED = "1";
          GSK_RENDERER = "ngl";
        };
      };
    };
}
