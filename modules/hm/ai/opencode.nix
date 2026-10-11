{
  flake.modules.homeManager.ai =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.nyx.ai.opencode;
    in
    {
      options.nyx.ai.opencode = {
        enable = lib.mkEnableOption "OpenCode against the local Ollama server";
      };

      config = lib.mkIf cfg.enable {
        programs.opencode = {
          enable = true;

          # Gemma 4 12B on this card. num_ctx has to match the server
          # window or Ollama truncates the earlier turns out of the prompt.
          settings = {
            model = "ollama/gemma4:12b";

            provider.ollama = {
              npm = "@ai-sdk/openai-compatible";
              name = "Ollama (local)";
              options.baseURL = "http://127.0.0.1:11434/v1";
              models."gemma4:12b" = {
                name = "Gemma 4 12B";
                tool_call = true;
                limit = {
                  context = 32768;
                  output = 8192;
                };
                options.num_ctx = 32768;
              };
            };
          };
        };
      };
    };
}
