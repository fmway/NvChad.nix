{ lib, nixvimLib, config, ... }:
{
  _file = ./autocmds.nix;
  config = lib.mkIf config.nvchad.enable {
    autoGroups.NvFilePost.clear = true;
    autoCmd = [
    {
      group = "NvFilePost";
      event = [ "UIEnter" "BufReadPost" "BufNewFile" ];
      callback.__raw = nixvimLib.helpers.mkLuaFn [ "args" ] /* lua */ ''
        local file = vim.api.nvim_buf_get_name(args.buf)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

        if not vim.g.ui_entered and args.event == "UIEnter" then
          vim.g.ui_entered = true
        end

        if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
          vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
          vim.api.nvim_del_augroup_by_name "NvFilePost"

          vim.schedule(function()
            vim.api.nvim_exec_autocmds("FileType", {})

            if vim.g.editorconfig then
              require("editorconfig").config(args.buf)
            end
          end)
        end
      '';
    }
    ];
  };
}
