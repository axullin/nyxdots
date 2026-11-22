{
  lib,
  config,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, system, ... }:
    let
      hostsForSystem = lib.filterAttrs (
        hostName: _: config.nyx.hosts.${hostName}.system == system
      ) config.flake.nixosConfigurations;
    in
    {
      packages =
        import ../../pkgs { inherit pkgs inputs; }
        // lib.mapAttrs (_: host: host.config.system.build.toplevel) hostsForSystem;
    };
}
