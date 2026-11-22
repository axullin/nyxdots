{
  flake.modules.homeManager.apps =
    { pkgs, ... }:
    {
      nyx.impermanence.directories = [ ".config/BraveSoftware" ];

      home.packages = with pkgs; [
        brave
        firefox-devedition
      ];
    };
}
