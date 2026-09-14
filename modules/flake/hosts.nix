{
  lib,
  config,
  inputs,
  ...
}:
{
  options.nyx.hosts = lib.mkOption {
    description = "Machines this flake builds. Each entry becomes a nixosConfiguration.";
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            system = lib.mkOption {
              type = lib.types.str;
              description = "Type of system on the host machine";
            };

            userName = lib.mkOption {
              type = lib.types.str;
              description = "User's name";
            };

            userEmail = lib.mkOption {
              type = lib.types.str;
              description = "User's email";
            };

            stable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Turn on to use stable nixpkgs defined in the flake";
            };

            bundles = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "core"
                name
              ];
              description = "The modules that the system includes";
            };
          };
        }
      )
    );
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    hostName: host:
    let
      nixpkgs = if host.stable then inputs.nixpkgs-stable else inputs.nixpkgs;
    in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs hostName;
        inherit (host)
          system
          userName
          userEmail
          ;
      };

      modules = [
        { nixpkgs.hostPlatform = host.system; }
      ]
      ++ map (bundle: config.flake.modules.nixos.${bundle}) host.bundles;
    }
  ) config.nyx.hosts;
}
