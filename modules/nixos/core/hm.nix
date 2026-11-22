{ config, ... }:
{
  flake.modules.nixos.core =
    {
      inputs,
      homeManager,
      hostName,
      userName,
      userEmail,
      ...
    }:
    {
      imports = [ homeManager.nixosModules.home-manager ];

      home-manager = {
        backupFileExtension = "bak";
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit
            inputs
            hostName
            userName
            userEmail
            ;
        };

        users.${userName} = {
          imports = [
            config.flake.modules.homeManager.core
            config.flake.modules.homeManager.${hostName}
          ];
        };
      };
    };
}
