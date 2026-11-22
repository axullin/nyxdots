{
  flake.modules.nixos.printing3d =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.nyx.printing3d;
    in
    {
      options.nyx.printing3d = {
        enable = lib.mkEnableOption "3D printing LAN helpers (Bambu SSDP discovery firewall)";
      };

      config = lib.mkIf cfg.enable {
        networking.firewall.allowedUDPPorts = [
          1990
          2021
        ];
      };
    };
}
