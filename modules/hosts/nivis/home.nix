{ config, ... }:
{
  flake.modules.homeManager.nivis = {
    imports = with config.flake.modules.homeManager; [
      desktop
      apps
      terminal
      modeling
      printing3d
      ai
    ];

    nyx.ai.opencode.enable = true;
    nyx.ai.pi.enable = true;
    nyx.terminal.starship.enable = true;
    nyx.terminal.fastfetch.enable = true;
    nyx.modeling.enable = true;

    home.stateVersion = "26.05";
  };
}
