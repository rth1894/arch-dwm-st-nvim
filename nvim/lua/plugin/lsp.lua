return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Updated to use the new vim.lsp.config() API
      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = true,
          },
        },
      })
    end
  },
  {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function()
          vim.fn["mkdp#util#install"]()
      end,
  },

  -- multiline comments in lua:
  -- --[[
  {
      "zbirenbaum/copilot.lua",
      event = "VeryLazy",
      config = function()
          require("copilot").setup({
              suggestion = {
                  enabled = true,
                  auto_trigger = true,
                  keymap = {
                      accept = "<C-l>",
                      accept_word = "<C-j>",
                      accept_line = "<C-k>",
                      next = "<M-]>",
                      prev = "<M-[>",
                      dismiss = "<C-p>",
                  },
              },
              --                 panel = { enabled = false },
              filetypes = { markdown = true, },
          })
      end,
  },
  --]]--

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      })
    end
  }
}
