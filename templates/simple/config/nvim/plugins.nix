{ pkgs, nixvimLib, ... }: let
  inherit (nixvimLib) helpers;
  toKeymaps = key: action: { ... } @ options:
    helpers.mkRaw (helpers.toLuaObject (helpers.listToUnkeyedAttrs [ key action ] // options));
in {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = telescope-nvim;
      dependencies = [ telescope-undo-nvim plenary-nvim ];
      config.__raw = /* lua */ ''
        function()
          require("telescope").setup {
            extensions = { undo = {}, },
          }
          require("telescope").load_extension("undo")
          -- vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
        end
      '';
      keys.__raw = helpers.toLuaObject [
        (toKeymaps "<leader>u" "<CMD>Telescope undo<CR>" {})
      ];
    }
    {
      pkg = nvim-notify;
      config.__raw = /* lua */ ''
        --
        function()
          local notify = require("notify")
          -- this for transparency
          notify.setup({ background_colour = "#000000" })
          -- this overwrites the vim notify function
          vim.notify = notify.notify
        end
      '';
    }
    {
      pkg = toggleterm-nvim;
      config.__raw = /* lua */ ''
        --
        function()
          require("toggleterm").setup {}
          local Terminal = require("toggleterm.terminal").Terminal
          local lazygit = Terminal:new {
            cmd = "lazygit",
            hidden = true,
            direction = "float",
            float_opts = {
              border = "double",
            },
            -- function to run on opening the terminal
            on_open = function(term)
              vim.cmd("startinsert!")
              vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
            end,
            -- function to run on closing the terminal
            on_close = function(term)
              vim.cmd("startinsert!")
            end,
          }

          function _lazygit_toggle()
            lazygit:toggle()
          end

        end
      '';
      keys.__raw = helpers.toLuaObject [
        (toKeymaps "<leader>lg" "<cmd>lua _lazygit_toggle()<CR>" { desc = "Toggle Lazygit"; })
      ];
    }
    # laravel
    # {
    #   pkg = pkgs.vimUtils.buildVimPlugin rec {
    #     pname = "laravel-nvim";
    #     version = "3.1.0";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "adalessa";
    #       repo = "laravel.nvim";
    #       rev = "v${version}";
    #       hash = "sha256-2VVVl0pAOBVAkrTB0rPGWHvS8o/3MYD2YnfPzPF5vTQ=";
    #     };
    #   };
    #   dependencies = [
    #     telescope-nvim
    #     vim-dotenv
    #     nui-nvim
    #     none-ls-nvim
    #   ];
    #   cmd = [ "Sail" "Artisan" "Composer" "Npm" "Yarn" "Laravel" ];
    #   event = [ "VeryLazy" ];
    #   config = true;
    #   keys.__raw = helpers.toLuaObject [
    #     (toKeymaps "<leader>la" ":Laravel artisan<cr>" {})
    #     (toKeymaps "<leader>lr" ":Laravel routes<cr>" {})
    #     (toKeymaps "<leader>lm" ":Laravel related<cr>" {})
    #   ];
    # }
    {
      pkg = bufferline-nvim;
      keys.__raw = helpers.toLuaObject [
        (toKeymaps "g1" ''<CMD>lua require("bufferline").go_to_buffer(1, true)<CR>'' { desc = "Go to tab 1"; })
        (toKeymaps "g2" ''<CMD>lua require("bufferline").go_to_buffer(2, true)<CR>'' { desc = "Go to tab 2"; })
        (toKeymaps "g3" ''<CMD>lua require("bufferline").go_to_buffer(3, true)<CR>'' { desc = "Go to tab 3"; })
        (toKeymaps "g4" ''<CMD>lua require("bufferline").go_to_buffer(4, true)<CR>'' { desc = "Go to tab 4"; })
        (toKeymaps "g5" ''<CMD>lua require("bufferline").go_to_buffer(5, true)<CR>'' { desc = "Go to tab 5"; })
        (toKeymaps "g6" ''<CMD>lua require("bufferline").go_to_buffer(6, true)<CR>'' { desc = "Go to tab 6"; })
        (toKeymaps "g7" ''<CMD>lua require("bufferline").go_to_buffer(7, true)<CR>'' { desc = "Go to tab 7"; })
        (toKeymaps "g8" ''<CMD>lua require("bufferline").go_to_buffer(8, true)<CR>'' { desc = "Go to tab 8"; })
        (toKeymaps "g9" ''<CMD>lua require("bufferline").go_to_buffer(9, true)<CR>'' { desc = "Go to tab 9"; })
        (toKeymaps "g0" ''<CMD>lua require("bufferline").go_to_buffer(10, true)<CR>'' { desc = "Go to tab 10"; })
      ];
    }
  ];
}
