{
  flake.modules.nixos.hardware =
    { config, lib, ... }:
    let
      cfg = config.nyx.hardware.zram;
    in
    {
      options.nyx.hardware.zram = {
        enable = lib.mkEnableOption "compressed swap in RAM instead of a swap partition";
      };

      config = lib.mkIf cfg.enable {
        zramSwap.enable = true;
      };
    };
}
