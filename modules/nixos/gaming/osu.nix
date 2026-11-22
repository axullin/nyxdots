{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      nyx.impermanence.home.directories = [
        ".local/share/osu"
        ".config/OpenTabletDriver"
        ".config/wootility"
      ];

      hardware.wooting.enable = true;

      hardware.opentabletdriver.enable = true;
      hardware.uinput.enable = true;

      environment.systemPackages = with pkgs; [
        osu-lazer-bin
      ];
    };
}
