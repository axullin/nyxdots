{ config, ... }:
{
  flake.modules.nixos.proxnix =
    { hostName, ... }:
    {
      imports = with config.flake.modules.nixos; [
        ssh
        boot
        networking
      ];

      nyx = {

        boot = {
          cachyosKernel.enable = false;
          secure-boot.enable = false;
          impermanence.enable = false;
          grub.enable = true;
        };

        networking.mc-server = {
          enable = false;
          dataDir = "/srv/minecraft";
          jvmOpts = "-Xmx4G -Xms4G";
        };

        ssh.authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJSv9RClAbJ9RXzA9UDixha7YoHqV1V32pYbix2Racfn axul.full@gmail.com"
        ];

      };

      networking = {
        inherit hostName;
        networkmanager.enable = true;
      };

      system.stateVersion = "26.05";
    };
}
