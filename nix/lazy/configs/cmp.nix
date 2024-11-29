{ helpers, ... }:
{
  completion = { completeopt = "menu,menuone"; };

  snippet = {
    expand.__raw = helpers.mkLuaFn [ "args" ] /* lua */ ''require("luasnip").lsp_expand(args.body)'';
  };

  mapping = (helpers.listToUnkeyedAttrs []) // {
    "<C-p>".__raw = /* lua */ "cmp.mapping.select_prev_item()";
    "<C-n>".__raw = /* lua */ "cmp.mapping.select_next_item()";
    "<C-d>".__raw = /* lua */ "cmp.mapping.scroll_docs(-4)";
    "<C-f>".__raw = /* lua */ "cmp.mapping.scroll_docs(4)";
    "<C-Space>".__raw = /* lua */ "cmp.mapping.complete()";
    "<C-e>".__raw = /* lua */ "cmp.mapping.close()";
    "<CR>".__raw = /* lua */ ''
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }
    '';

    "<Tab>".__raw = /* lua */ ''
      cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" })
    '';

    "<S-Tab>".__raw = /* lua */ ''
      cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" })
    '';
  };

  sources = [
    { name = "nvim_lsp"; }
    { name = "luasnip"; }
    { name = "buffer"; }
    { name = "nvim_lua"; }
    { name = "path"; }
  ];
}
