{ config, pkgs, inputs, ... }:

{
  # home.packages = with pkgs; [
  #   wakatime-cli
  # ];
  programs.neovim = {
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # Lua tools for the editor running on Lua
      lua-language-server
      stylua

      # Taplo, TOML ls,linter and formatter
      taplo

      # Unzip is depended on for unzipping certain dependencies.
      # I have decided not to be too opinionated about this today.
      unzip

      # AST-Grep
      ast-grep

      # Node is required as runtime for some LSP's, among them css-ls and tailwindcss-ls
      nodejs

      # SQL linter-formatter
      sqlfluff

      # Markdown LSP and toc creator
      markdown-oxide
      markdown-toc

      # Inclusivity linter
      woke

      # More generic web-oriented linter-formatters: Biome, Prettier
      biome
      prettier

      # And duh
      nil
      nixfmt

      # FD
      fd

      # TS
      tree-sitter

      # GCC
      gcc

      # RG
      ripgrep
    ];

    initLua = ''
      -- Prepend the symlinked directory to the Runtime Path
      vim.opt.rtp:prepend("${config.home.homeDirectory}/.config/nvim")
      require("init")
    '';
  };

  xdg.configFile."nvim".source = ../../../configs/nvim;
}
