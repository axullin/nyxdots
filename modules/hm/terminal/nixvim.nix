{
  flake.modules.homeManager.terminal =
    { userName, inputs, ... }:
    {
      imports = [ inputs.nixvim.homeModules.nixvim ];

      programs.nixvim = {
        enable = true;

        globals.mapleader = " ";

        opts = {
          number = true;
          relativenumber = true;
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          wrap = false;
          scrolloff = 8;
          clipboard = "unnamedplus";
          signcolumn = "yes";
          termguicolors = true;
          updatetime = 250;
          conceallevel = 2;
        };

        colorschemes.kanagawa = {
          enable = true;
        };

        plugins = {
          treesitter = {
            enable = true;
            settings.ensure_installed = [
              "nix"
              "lua"
              "bash"
              "markdown"
              "markdown_inline"
              "python"
            ];
          };

          telescope = {
            enable = true;
            settings.defaults.file_ignore_patterns = [
              "node_modules"
              ".git"
            ];
          };

          which-key.enable = true;
          web-devicons.enable = true;

          # LSP
          lsp = {
            enable = true;
            servers = {
              nil_ls.enable = true;
              pyright.enable = true;
              lua_ls.enable = true;
              bashls.enable = true;
            };
          };
          fidget.enable = true;

          # Completion
          cmp = {
            enable = true;
            settings = {
              snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
              mapping = {
                "<C-Space>" = "cmp.mapping.complete()";
                "<C-e>" = "cmp.mapping.abort()";
                "<CR>" = "cmp.mapping.confirm({ select = true })";
                "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
                "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                "<C-u>" = "cmp.mapping.scroll_docs(-4)";
                "<C-d>" = "cmp.mapping.scroll_docs(4)";
              };
              sources = [
                { name = "nvim_lsp"; }
                { name = "luasnip"; }
                { name = "buffer"; }
                { name = "path"; }
              ];
            };
          };
          luasnip.enable = true;
          friendly-snippets.enable = true;

          # File tree
          neo-tree.enable = true;

          # Git
          gitsigns = {
            enable = true;
            settings.signs = {
              add.text = "│";
              change.text = "│";
              delete.text = "_";
              topdelete.text = "‾";
              changedelete.text = "~";
            };
          };

          # Status line
          lualine.enable = true;

          # QoL
          nvim-autopairs.enable = true;
          comment.enable = true;
          indent-blankline.enable = true;
          todo-comments.enable = true;
          nvim-surround.enable = true;

        keymaps = [
          # Escape
          {
            key = "jk";
            action = "<Esc>";
            mode = "i";
          }

          # Telescope
          {
            key = "<leader>ff";
            action = "<cmd>Telescope find_files<cr>";
            mode = "n";
          }
          {
            key = "<leader>fg";
            action = "<cmd>Telescope live_grep<cr>";
            mode = "n";
          }
          {
            key = "<leader>fb";
            action = "<cmd>Telescope buffers<cr>";
            mode = "n";
          }
          {
            key = "<leader>fr";
            action = "<cmd>Telescope oldfiles<cr>";
            mode = "n";
          }
          {
            key = "<leader>fd";
            action = "<cmd>Telescope diagnostics<cr>";
            mode = "n";
          }

          # File tree
          {
            key = "<leader>e";
            action = "<cmd>Neotree toggle<cr>";
            mode = "n";
          }

          # Notes (obsidian.nvim)
          {
            key = "<leader>nn";
            action = "<cmd>Obsidian new<cr>";
            mode = "n";
          }
          {
            key = "<leader>nt";
            action = "<cmd>Obsidian today<cr>";
            mode = "n";
          }
          {
            key = "<leader>no";
            action = "<cmd>Obsidian quick_switch<cr>";
            mode = "n";
          }
          {
            key = "<leader>ns";
            action = "<cmd>Obsidian search<cr>";
            mode = "n";
          }
          {
            key = "<leader>nc";
            action = "<cmd>Obsidian toggle_checkbox<cr>";
            mode = "n";
          }

          # LSP
          {
            key = "gd";
            action = "<cmd>lua vim.lsp.buf.definition()<cr>";
            mode = "n";
          }
          {
            key = "gr";
            action = "<cmd>lua vim.lsp.buf.references()<cr>";
            mode = "n";
          }
          {
            key = "K";
            action = "<cmd>lua vim.lsp.buf.hover()<cr>";
            mode = "n";
          }
          {
            key = "<leader>rn";
            action = "<cmd>lua vim.lsp.buf.rename()<cr>";
            mode = "n";
          }
          {
            key = "<leader>ca";
            action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
            mode = "n";
          }
          {
            key = "[d";
            action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
            mode = "n";
          }
          {
            key = "]d";
            action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
            mode = "n";
          }
          {
            key = "<leader>dl";
            action = "<cmd>lua vim.diagnostic.open_float()<cr>";
            mode = "n";
          }

          # Window navigation
          {
            key = "<C-h>";
            action = "<C-w>h";
            mode = "n";
          }
          {
            key = "<C-j>";
            action = "<C-w>j";
            mode = "n";
          }
          {
            key = "<C-k>";
            action = "<C-w>k";
            mode = "n";
          }
          {
            key = "<C-l>";
            action = "<C-w>l";
            mode = "n";
          }

          # Better indent in visual
          {
            key = "<";
            action = "<gv";
            mode = "v";
          }
          {
            key = ">";
            action = ">gv";
            mode = "v";
          }

          # Move lines up/down in visual
          {
            key = "<A-j>";
            action = ":m '>+1<CR>gv=gv";
            mode = "v";
          }
          {
            key = "<A-k>";
            action = ":m '<-2<CR>gv=gv";
            mode = "v";
          }
        ];
      };
    };
}
