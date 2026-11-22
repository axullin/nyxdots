{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      nyx.impermanence.home.directories = [ ".config/obs-studio" ];

      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-vaapi
          wlrobs
          obs-source-record
        ];
      };
    };
}
