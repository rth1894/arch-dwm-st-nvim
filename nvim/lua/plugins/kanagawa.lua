return {
    {
        "rebelot/kanagawa.nvim",

        priority = 1000,
        lazy = false,

        opts = {
            theme = "wave",
            transparent = true,
            terminal_colors = true,

            overrides = function(colors)
                return {
                    Normal = {
                        bg = "none",
                    },

                    NormalFloat = {
                        bg = "none",
                    },

                    FloatBorder = {
                        bg = "none",
                    },

                    SignColumn = {
                        bg = "none",
                    },

                    LineNr = {
                        bg = "none",
                    },

                    CursorLineNr = {
                        bg = "none",
                        bold = true,
                    },

                    CursorLine = {
                        bg = "#1f1f28",
                    },

                    TelescopeNormal = {
                        bg = "none",
                    },

                    TelescopeBorder = {
                        bg = "none",
                    },
                }
            end,

            integrations = {
                treesitter = true,
                lualine = true,
                telescope = true,
                which_key = true,
            },
        },

        config = function(_, opts)
            require("kanagawa").setup(opts)
            vim.cmd.colorscheme("kanagawa-wave")
        end,
    },
}
