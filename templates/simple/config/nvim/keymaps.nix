{ pkgs, ... }:
{
  keymaps = [
    # right click
    {
      key = "<C-t>";
      action.__raw = /* lua */ ''
        function()
          require("menu").open("default")
        end
      '';
      mode = [ "n" ];
    }
    {
      key = "<RightMouse>";
      mode = ["n"];
      action.__raw = /* lua */ ''
        function()
          vim.cmd.exec '"normal! \\<RightMouse>"'

          local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
          require("menu").open(options, { mouse = true })
        end
      '';
    }
    { mode = "n"; key = ";"; action = ":"; options.desc = "CMD enter command mode"; }
    { mode = "i"; key = "<C-n>"; action = "<cmd>NvimTreeToggle <CR><ESC>"; options.desc = "Toggle NvimTree"; }
    { mode = "n"; key = "<A-t>"; action.__raw = /* lua */ ''
        --
        function()
          require("nvchad.themes").open { style = "compat", border = true, }
        end
      '';
      options.desc = "Show themes menu";
    }  
  ];
}
