{ config, ... }:
{
  flake.modules.nixos.proxnix =
    { hostName, ... }:
    {
      imports = with config.flake.modules.nixos; [
        ssh
        boot
        networking
        minecraft
      ];

      nyx = {

        boot = {
          cachyosKernel.enable = false;
          secure-boot.enable = false;
          grub.enable = true;
        };

        minecraft = {
          enable = true;
          dataDir = "/srv/minecraft";
          jvmOpts = "-Xmx4G -Xms4G";
          nivel.enable = true;
        };

        networking.playit.enable = true;

        ssh.authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJSv9RClAbJ9RXzA9UDixha7YoHqV1V32pYbix2Racfn axul.full@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAReT7ZbDkP6UVMJLVQSGQuW2srDotgy8fX/kmbtUgMX termux"
        ];

      };

      networking = {
        inherit hostName;
        networkmanager.enable = true;
      };

      system.stateVersion = "26.05";
    };
}
