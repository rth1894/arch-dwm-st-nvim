local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
      { import = "plugin.lsp" },

      {
          'nvim-telescope/telescope.nvim', tag = '0.1.8',
          dependencies = { 'nvim-lua/plenary.nvim' }
      },

      {
          "folke/tokyonight.nvim",
          lazy = false,
          priority = 1000,
          opts = {},
      },

      {
          "nvim-treesitter/nvim-treesitter",
          build = ":TSUpdate",
          opts = {
              ensure_installed = {"c", "rust", "python"},
              auto_install = true,
              highlight = {
                  enable = true,
              },
          },
      },

      {
          "mason-org/mason.nvim",
          opts = {}
      },

      {
          "mason-org/mason-lspconfig.nvim",
          opts = {},
          dependencies = {
              { "mason-org/mason.nvim", opts = {} },
              "neovim/nvim-lspconfig",
          },
      },

      {
          'hrsh7th/nvim-cmp',
          requires = {
              'hrsh7th/cmp-nvim-lsp',
              'L3MON4D3/LuaSnip',
              'saadparwaiz1/cmp_luasnip',
          }
      },

  },
  install = { colorscheme = { "retrobox" } },
  -- checker = { enabled = true, notify = false },
})
