{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aseprite
        celluloid
        ffmpeg
        kdePackages.kdenlive
        krita
        obsidian
        droidcam
        spotify
      ];
    };
}
