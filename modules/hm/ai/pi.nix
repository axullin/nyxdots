{
  flake.modules.homeManager.ai =
    {
      config,
      lib,
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

          settings = {
            defaultProvider = "ollama";
            defaultModel = "qwen3.8:27b";
            defaultThinkingLevel = "high";
          };

          # Context matches services.ollama's OLLAMA_CONTEXT_LENGTH.
          models.providers.ollama = {
            baseUrl = "http://127.0.0.1:11434/v1";
            api = "openai-completions";
            apiKey = "ollama";
            models = [
              {
                id = "qwen3.8:27b";
                name = "Qwen3.8 27B";
                reasoning = true;
                contextWindow = 32768;
              }
            ];
          };
        };
      };
    };
}
