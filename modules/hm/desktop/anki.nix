{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.anki = {
        enable = true;
        theme = "dark";
        package = pkgs.anki;
        addons = with pkgs; [
          ankiAddons.anki-connect
          ankiAddons.passfail2
        ];
      };
    };
}
