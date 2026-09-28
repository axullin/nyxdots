{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        brave
        firefox-devedition
      ];
    };
}
