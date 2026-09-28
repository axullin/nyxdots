{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aseprite
        celluloid
        ffmpeg
        krita
        obsidian
        droidcam
      ];
    };
}
