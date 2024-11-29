{ pkgs, lib, ... }: let
  # still not work
  # treesitter-blade-grammar = pkgs.tree-sitter.buildGrammar rec {
  #   language = "blade";
  #   version = "0.11.0";
  #
  #   src = (pkgs.fetchFromGitHub {
  #     owner = "EmranMR";
  #     repo = "tree-sitter-blade";
  #     rev = "v${version}";
  #     hash = "sha256-PTGdsXlLoE+xlU0uWOU6LQalX4fhJ/qhpyEKmTAazLU=";
  #   }).overrideAttrs
  #   (drv: {
  #     fixupPhase = ''
  #       mkdir -p $out/queries/blade
  #       mv $out/queries/*.scm $out/queries/blade/
  #     '';
  #   });
  #
  #   meta = {
  #     description = "Tree-sitter grammar for Laravel blade files";
  #     homepage = "https://github.com/EmranMR/tree-sitter-blade";
  #     license = lib.licenses.mit;
  #   };
  # };
in {
  # plugins.treesitter.folding = true;
  plugins.treesitter.settings.indent.enable = false;
  plugins.treesitter.settings.highlight.enable = true;
  # plugins.treesitter.nixGrammars = true;
  plugins.treesitter.nixvimInjections = true;
  plugins.treesitter.settings.auto_install = false;
  plugins.treesitter.grammarPackages =
    (builtins.map (x: pkgs.vimPlugins.nvim-treesitter.builtGrammars.${x})
      [
        "asm"
        "bash"
        "c"
        "cmake"
        "comment"
        "css"
        "dhall"
        "diff"
        "dockerfile"
        "dot"
        "fish"
        "git_config"
        "git_rebase"
        "gitattributes"
        "gitcommit"
        "gitignore"
        "go"
        "gomod"
        "gosum"
        "gotmpl"
        "gpg"
        "graphql"
        "haskell"
        "haskell_persistent"
        "hcl"
        "helm"
        "html"
        "http"
        "javascript"
        "jq"
        "jsdoc"
        "json"
        "latex"
        "lua"
        "luadoc"
        "luap"
        "luau"
        "make"
        "markdown"
        "markdown_inline"
        "mermaid"
        "nix"
        "norg"
        "ocaml"
        "ocaml_interface"
        "ocamllex"
        "passwd"
        "po"
        "proto"
        "pymanifest"
        "python"
        "query"
        "regex"
        "rust"
        "rescript"
        "sql"
        "ssh_config"
        "templ"
        "terraform"
        "textproto"
        "tmux"
        "todotxt"
        "toml"
        "tsx"
        "typescript"
        "vhs"
        "vim"
        "vimdoc"
        "xml"
        "yaml"
      ]) ++ [
    # treesitter-blade-grammar
  ];
  # extraFiles = let
  #   dir = "${treesitter-blade-grammar}/queries";
  #   lists = builtins.readDir dir |> builtins.attrNames;
  # in map (x: {
  #   name = "queries/blade/${x}";
  #   value.source = "${dir}/${x}";
  # }) lists |> builtins.listToAttrs;
  # extraConfigLua = /* lua */ ''
  #   --
  #   do
  #     local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  #     -- change the following as needed
  #     parser_config.blade = {
  #       install_info = {
  #         url = "https://github.com/EmranMR/tree-sitter-blade",
  #         files = {"src/parser.c"},
  #         branch = "main",
  #       },
  #       filetype = "blade",
  #     }
  #   end
  # '';
  # extraPlugins = [
  #   treesitter-blade-grammar
  # ];
} 
