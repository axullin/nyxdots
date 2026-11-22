{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      nyx.impermanence.directories = [
        ".config/obsidian"
        ".config/kdenlive"
        ".local/share/kdenlive"
        ".local/share/krita"
        ".cache/spotify"
      ];
      nyx.impermanence.files = [ ".config/kdenliverc" ];

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
