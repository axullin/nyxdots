{
  flake.modules.homeManager.core =
    {
      config,
      lib,
      osConfig,
      ...
    }:
    let
      cfg = config.nyx.impermanence;
      system = osConfig.nyx.impermanence;
    in
    {
      options.nyx.impermanence = {
        directories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        files = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };

      config = {
        nyx.impermanence.directories = [
          "Downloads"
          "Music"
          "Documents"
          "Videos"
          "Projects"
          "Pictures"
          "Notes"
          "Assets"
          ".ssh"
        ];

        home.persistence = lib.mkIf system.enable {
          ${system.path} = {
            hideMounts = true;
            inherit (cfg) directories files;
          };
        };
      };
    };
}
