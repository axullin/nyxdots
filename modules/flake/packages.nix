{ lib, config, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      hostsForSystem = lib.filterAttrs (
        _: host: host.config.nixpkgs.hostPlatform.system == system
      ) config.flake.nixosConfigurations;
    in
    {
      packages =
        import ../../pkgs { inherit pkgs; }
        // lib.mapAttrs (_: host: host.config.system.build.toplevel) hostsForSystem;
    };
}
