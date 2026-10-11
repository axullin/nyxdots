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
        # Bambu Lab SSDP discovery (Bambu Studio network plugin).
        # Manual add-by-IP still works if multicast is filtered on the LAN.
        networking.firewall.allowedUDPPorts = [
          1990
          2021
        ];
      };
    };
}
