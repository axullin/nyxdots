{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        audacity
        brightnessctl
        pavucontrol
        playerctl
        reaper
        wireplumber
        vlc
      ];
    };
}
