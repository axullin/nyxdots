{ config, ... }:
{
  flake.modules.homeManager.nivis = {
    imports = with config.flake.modules.homeManager; [
      desktop
      packages
      terminal
      modeling
      printing3d
      ai
    ];

    nyx.ai.opencode.enable = true;

    nyx.desktop.hyprland.enable = true;
    nyx.desktop.noctalia.enable = true;
    nyx.terminal.starship.enable = true;
    nyx.terminal.fastfetch.enable = true;
    nyx.modeling.enable = true;
    nyx.printing3d.enable = true;

    home.stateVersion = "26.05";
  };
}
