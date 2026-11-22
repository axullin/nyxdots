{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      nyx.impermanence.home.directories = [
        ".steam"
        ".local/share/Steam"
        ".config/unity3d"
      ];

      programs.steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    };
}
