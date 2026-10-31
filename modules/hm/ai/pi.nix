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
        enable = lib.mkEnableOption "Pi coding agent against the local Ollama server";
      };

      config = lib.mkIf cfg.enable {
        programs.pi-coding-agent = {
          enable = true;

          # Pi installs settings.packages with npm at startup. agent-browser
          # is the CLI that extension calls. mcp-nixos is named by absolute
          # path in mcp.json.
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

          # Q3 weights stay on the 16 GB card. The 256k KV cache is in RAM
          # and is about 22 GB on this architecture.
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
