{
  flake.modules.homeManager.ai =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nyx.ai.pi;
    in
    {
      options.nyx.ai.pi = {
        enable = lib.mkEnableOption "Pi coding agent with the local Ollama server";
      };

      config = lib.mkIf cfg.enable {
        nyx.impermanence.directories = [ ".pi/agent" ];

        programs.pi-coding-agent = {
          enable = true;

          extraPackages = [
            pkgs.nodejs_24
            pkgs.agent-browser
          ];

          settings = {
            defaultProvider = "ollama";
            defaultModel = "qwen3.8-16gb";
            defaultThinkingLevel = "high";
            packages = [
              "npm:pi-agent-browser-native"
              "npm:pi-mcp-adapter"
              "npm:@narumitw/pi-plan-mode"
            ];
          };

          models.providers.ollama = {
            baseUrl = "http://127.0.0.1:11434/v1";
            api = "openai-completions";
            apiKey = "ollama";
            models = [
              {
                id = "qwen3.8-16gb";
                name = "Qwen3.8 27B Q3";
                reasoning = true;
                contextWindow = 262144;
              }
            ];
          };
        };

        home.file.".pi/agent/mcp.json".text = builtins.toJSON {
          mcpServers.nixos = {
            command = lib.getExe pkgs.mcp-nixos;
            args = [ ];
            description = "Search NixOS, Home Manager, and nixpkgs packages and options";
          };
        };
      };
    };
}
