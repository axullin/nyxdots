{
  flake.modules.homeManager.terminal =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        gh
        lazygit
      ];

      programs.git = {
        enable = true;
        signing = {
          key = "~/.ssh/id_ed25519.pub";
          signByDefault = true;
        };

        settings = {
          user = {
            name = "axullin";
            email = "axul.full@gmail.com";
          };

          init.defaultBranch = "main";
          commit.gpgSign = true;
          gpg.format = "ssh";
        };
      };
    };
}
