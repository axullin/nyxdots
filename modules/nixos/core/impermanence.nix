{
  flake.modules.nixos.core =
    {
      config,
      lib,
      userName,
      inputs,
      ...
    }:
    let
      cfg = config.nyx.impermanence;
    in
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      options.nyx.impermanence = {
        enable = lib.mkEnableOption "a tmpfs root, with state kept under `path`";

        path = lib.mkOption {
          type = lib.types.str;
          default = "/persist";
          description = "Where persistent state lives";
        };

        prefix = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          internal = true;
          default = lib.optionalString cfg.enable cfg.path;
          description = "`path` when impermanence is on, \"\" otherwise. Prefix absolute paths with it.";
        };

        directories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        files = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        home = {
          directories = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };

          files = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };
        };
      };

      config = lib.mkIf cfg.enable {
        programs.fuse.userAllowOther = true;
        fileSystems.${cfg.path}.neededForBoot = true;
        environment.persistence.${cfg.path} = {
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib"
            "/etc/NetworkManager/system-connections"
          ]
          ++ cfg.directories;

          files = [ "/etc/machine-id" ] ++ cfg.files;
        };

        # home.* is for NixOS modules with state in $HOME. Home-manager modules use
        # their own nyx.impermanence, which turns it into home.persistence.
        home-manager.users.${userName}.nyx.impermanence = {
          inherit (cfg.home) directories files;
        };
      };
    };
}
