{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    let
      # WaterMedia looks for libvlc on LD_LIBRARY_PATH, then loads codecs from VLC_PLUGIN_PATH.
      prismlauncher' =
        (pkgs.prismlauncher.override { additionalLibs = [ pkgs.vlc ]; }).overrideAttrs
          (prev: {
            qtWrapperArgs = prev.qtWrapperArgs ++ [
              "--prefix VLC_PLUGIN_PATH : ${pkgs.vlc}/lib/vlc/plugins"
            ];
          });
    in
    {
      home.packages = with pkgs; [
        prismlauncher'
        (olympus.override {
          celesteWrapper = "steam-run";
        })
      ];
    };
}
