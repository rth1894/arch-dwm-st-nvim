return {
    {
        "saghen/blink.cmp",

        version = "*",

        event = "InsertEnter",

        dependencies = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },

        opts = {
            keymap = {
                preset = "none",
                ["<Tab>"] = {
                    "select_and_accept", "fallback"
                },
                ["<CR>"] = {
                    "select_and_accept", "fallback"
                },
                ["<C-n>"] = {
                    "select_next", "fallback"
                },
                ["<C-P>"] = {
                    "select_prev", "fallback"
                },

            },

            appearance = {
                nerd_font_variant = "mono",
            },

            snippets = {
                preset = "luasnip",
            },

            completion = {
                documentation = {
                    auto_show = true,
                },
            },

            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
            },
        },

        config = function(_, opts)
            require("luasnip.loaders.from_vscode").lazy_load()
            require("blink.cmp").setup(opts)
        end,
    },
}
