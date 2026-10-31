{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.anki = {
        enable = true;
        theme = "dark";
        package = pkgs.anki;
        addons = [
          pkgs.stable.ankiAddons.anki-connect
          pkgs.stable.ankiAddons.passfail2
        ];
      };
    };
}
