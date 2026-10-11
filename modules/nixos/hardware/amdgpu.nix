{
  flake.modules.nixos.hardware =
    { config, lib, ... }:
    let
      cfg = config.nyx.hardware.amdgpu;
    in
    {
      options.nyx.hardware.amdgpu = {
        enable = lib.mkEnableOption "the AMDGPU driver";
      };

      config = lib.mkIf cfg.enable {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        hardware.amdgpu.initrd.enable = true;

        environment.sessionVariables = {
          LIBVA_DRIVER_NAME = "radeonsi";
        };
      };
    };
}
