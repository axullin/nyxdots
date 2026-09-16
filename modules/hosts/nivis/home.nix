{ config, ... }:
{
  flake.modules.homeManager.nivis = {
    imports = with config.flake.modules.homeManager; [
      desktop
      packages
      modeling
      printing3d
    ];

    nyx.desktop.hyprland.enable = true;
    nyx.desktop.noctalia.enable = true;
    nyx.modeling.enable = true;
    nyx.printing3d.enable = true;

    home.stateVersion = "26.05";
  };
}
