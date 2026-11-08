{ lib, config, inputs, ... }:
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
        import ../../pkgs { inherit pkgs inputs; }
        // lib.mapAttrs (_: host: host.config.system.build.toplevel) hostsForSystem;
    };
}
