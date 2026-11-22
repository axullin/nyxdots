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
              description = ''
                Build the host from nixpkgs-stable and home-manager-stable. Other inputs
                still follow unstable nixpkgs, so their modules may need checking.
              '';
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
      homeManager = if host.stable then inputs.home-manager-stable else inputs.home-manager;
    in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs hostName homeManager;
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
