{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      nyx.impermanence.directories = [ ".config/BraveSoftware" ];

      home.packages = with pkgs; [
        brave
        firefox-devedition
      ];
    };
}
