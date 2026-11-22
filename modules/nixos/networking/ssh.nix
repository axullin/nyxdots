{
  flake.modules.nixos.networking =
    {
      config,
      lib,
      userName,
      ...
    }:
    let
      cfg = config.nyx.networking.ssh;
    in
    {
      options.nyx.networking.ssh = {
        ports = lib.mkOption {
          type = lib.types.listOf lib.types.port;
          default = [ 22 ];
          description = "Ports the OpenSSH server listens on.";
        };

        authorizedKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Public keys that may log in as the primary user.";
        };

        settings = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = { };
          description = "Extra services.openssh.settings. Entries here override the module defaults.";
        };
      };

      config = {
        programs.ssh.startAgent = true;

        users.users.${userName}.openssh.authorizedKeys.keys = cfg.authorizedKeys;

        services.openssh = {
          enable = true;
          allowSFTP = true;
          startWhenNeeded = true;
          inherit (cfg) ports;

          hostKeys = [
            {
              path = "${config.nyx.impermanence.prefix}/etc/ssh/ssh_host_ed25519_key";
              type = "ed25519";
            }
          ];

          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            AuthenticationMethods = "publickey";
            PubkeyAuthentication = "yes";
            X11Forwarding = false;
            UsePAM = true;
            UseDns = false;
          }
          // cfg.settings;
        };
      };
    };
}
