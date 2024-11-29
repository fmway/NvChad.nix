{ config, lib, nixvimLib, ... }: let
  inherit (nixvimLib.helpers) mkLuaFn;
in {
  _file = ./keybindings.nix;
  config.keymaps = lib.mkIf config.nvchad.enable [   
    {
      key = "<C-b>";
      mode = ["i"];
      options.desc = "move beginning of line";
      action = "<ESC>^i";
    }
    {
      key = "<C-e>";
      mode = ["i"];
      options.desc = "move end of line";
      action = "<End>";
    }
    {
      key = "<C-h>";
      mode = ["i"];
      options.desc = "move left";
      action = "<Left>";
    }
    {
      key = "<C-l>";
      mode = ["i"];
      options.desc = "move right";
      action = "<Right>";
    }
    {
      key = "<C-j>";
      mode = ["i"];
      options.desc = "move down";
      action = "<Down>";
    }
    {
      key = "<C-k>";
      mode = ["i"];
      options.desc = "move up";
      action = "<Up>";
    }

    {
      key = "<C-h>";
      mode = ["n"];
      options.desc = "switch window left";
      action = "<C-w>h";
    }
    {
      key = "<C-l>";
      mode = ["n"];
      options.desc = "switch window right";
      action = "<C-w>l";
    }
    {
      key = "<C-j>";
      mode = ["n"];
      options.desc = "switch window down";
      action = "<C-w>j";
    }
    {
      key = "<C-k>";
      mode = ["n"];
      options.desc = "switch window up";
      action = "<C-w>k";
    }

    {
      key = "<Esc>";
      mode = ["n"];
      action = "<cmd>noh<CR>";
      options.desc = "general clear highlights";
    }

    {
      mode = ["n"];
      key = "<C-s>";
      action = "<cmd>w<CR>";
      options.desc = "general save file";
    }
    {
      mode = ["n"];
      key = "<C-c>";
      action = "<cmd>%y+<CR>";
      options.desc = "general copy whole file";
    }

    {
      mode = ["n"];
      key = "<leader>n";
      action = "<cmd>set nu!<CR>";
      options.desc = "toggle line number";
    }
    {
      mode = ["n"];
      key = "<leader>rn";
      action = "<cmd>set rnu!<CR>";
      options.desc = "toggle relative number";
    }
    {
      mode = ["n"];
      key = "<leader>ch";
      action = "<cmd>NvCheatsheet<CR>";
      options.desc = "toggle nvcheatsheet";
    }

    {
      mode = ["n"];
      key = "<leader>fm";
      action.__raw = mkLuaFn /* lua */ ''require("conform").format { lsp_fallback = true }'';
      options.desc = "general format file";
    }

    # global lsp mappings
    {
      mode = ["n"];
      key = "<leader>ds";
      action.__raw = /* lua */ "vim.diagnostic.setloclist";
      options.desc = "LSP diagnostic loclist";
    }

    # tabufline
    {
      mode = ["n"];
      key = "<leader>b";
      action = "cmd>enew<CR>";
      options.desc = "buffer new";
    }
    {
      key = "<tab>";
      mode = ["n"];
      options.desc = "buffer goto next";
      action.__raw = mkLuaFn /* lua */ ''require("nvchad.tabufline").next()'';
    }
    {
      mode = ["n"];
      key = "<S-tab>";
      action.__raw = mkLuaFn /* lua */ ''require("nvchad.tabufline").prev()'';
      options.desc = "buffer goto prev";
    }
    {
      mode = ["n"];
      key = "<leader>x";
      action.__raw = mkLuaFn /* lua */ ''require("nvchad.tabufline").close_buffer()'';
      options.desc = "buffer close";
    }

    # Comment
    {
      mode = ["n"];
      key = "<leader>/";
      action = "gcc";
      options.desc = "toggle comment";
      options.remap = true;
    }
    {
      mode = ["v"];
      key = "<leader>/";
      action = "gc";
      options.desc = "toggle comment";
      options.remap = true;
    }

    # nvimtree
    {
      mode = ["n"];
      key = "<C-n>";
      action = "<cmd>NvimTreeToggle<CR>";
      options.desc = "nvimtree toggle window";
    }
    {
      mode = ["n"];
      key = "<leader>e";
      action = "<cmd>NvimTreeFocus<CR>";
      options.desc = "nvimtree focus window";
    }

    # telescope
    {
      mode = ["n"];
      key = "<leader>fw";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "telescope live grep";
    }
    {
      mode = ["n"];
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options.desc = "telescope find buffers";
    }
    {
      mode = ["n"];
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options.desc = "telescope help page";
    }
    {
      mode = ["n"];
      key = "<leader>ma";
      action = "<cmd>Telescope marks<CR>";
      options.desc = "telescope find marks";
    }
    {
      mode = ["n"];
      key = "<leader>fo";
      action = "<cmd>Telescope oldfiles<CR>";
      options.desc = "telescope find oldfiles";
    }
    {
      mode = ["n"];
      key = "<leader>fz";
      action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
      options.desc = "telescope find in current buffer";
    }
    {
      mode = ["n"];
      key = "<leader>cm";
      action = "<cmd>Telescope git_commits<CR>";
      options.desc = "telescope git commits";
    }
    {
      mode = ["n"];
      key = "<leader>gt";
      action = "<cmd>Telescope git_status<CR>";
      options.desc = "telescope git status";
    }
    {
      mode = ["n"];
      key = "<leader>pt";
      action = "<cmd>Telescope terms<CR>";
      options.desc = "telescope pick hidden term";
    }
    {
      mode = ["n"];
      key = "<leader>th";
      action.__raw = mkLuaFn /* lua */ ''require("nvchad.themes").open()'';
      options.desc = "telescope nvchad themes";
    }
    {
      mode = ["n"];
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "telescope find files";
    }
    {
      mode = ["n"];
      key = "<leader>fa";
      action = "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>";
      options.desc = "telescope find all files";
    }

    # terminal
    {
      mode = ["t"];
      key = "<C-x>";
      action = "<C-\\><C-N>";
      options.desc = "terminal escape terminal mode";
    }

    # new terminals
    {
      mode = ["n"];
      key = "<leader>h";
      action.__raw = mkLuaFn /* lua */ ''require("nvchad.term").new { pos = "sp" }'';
      options.desc = "terminal new horizontal term";
    }
    {
      mode = ["n"];
      key = "<leader>v";
      action.__raw = mkLuaFn /* lua */ ''require("nvchad.term").new { pos = "vsp" }'';
      options.desc = "terminal new vertical term";
    }

    # toggleable
    {
      mode = ["n" "t"];
      key = "<A-v>";
      action.__raw = mkLuaFn /* lua */ ''require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }'';
      options.desc = "terminal toggleable vertical term";
    }
    {
      mode = ["n" "t"];
      key = "<A-h>";
      action.__raw = mkLuaFn /* lua */ ''require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }'';
      options.desc = "terminal toggleable horizontal term";
    }
    {
      mode = ["n" "t"];
      key = "<A-i>";
      action.__raw = mkLuaFn /* lua */ ''require("nvchad.term").toggle { pos = "float", id = "floatTerm" }'';
      options.desc = "terminal toggle floating term";
    }

    # whichkey
    {
      mode = ["n"];
      key = "<leader>wK";
      action = "<cmd>WhichKey <CR>";
      options.desc = "whichkey all keymaps";
    }
    {
      mode = ["n"];
      key = "<leader>wk";
      action.__raw = mkLuaFn /* lua */ ''vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")'';
      options.desc = "whichkey query lookup";
    }
  ];
}
