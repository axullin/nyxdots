{ config, ... }:
{
  flake.modules.homeManager.nivis = {
    imports = with config.flake.modules.homeManager; [
      desktop
      packages
    ];

    nyx.desktop.hyprland.enable = true;
    nyx.desktop.noctalia.enable = true;

    home.stateVersion = "26.05";
  };
}
