{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      nyx.impermanence.directories = [
        ".config/anki"
        ".local/share/Anki2"
      ];

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
