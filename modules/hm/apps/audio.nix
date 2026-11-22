{
  flake.modules.homeManager.apps =
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
