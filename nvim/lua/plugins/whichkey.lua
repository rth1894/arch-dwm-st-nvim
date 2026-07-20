return {
    {
        "folke/which-key.nvim",

        event = "VeryLazy",

        opts = {
            preset = "modern",

            delay = 300,

            icons = {
                mappings = true,
            },
        },

        config = function(_, opts)
            local wk = require("which-key")

            wk.setup(opts)

            wk.add({
                {
                    "<leader>f",
                    group = "find",
                },
                {
                    "<leader>g",
                    group = "git",
                },
                {
                    "<leader>h",
                    group = "hunks",
                },
                {
                    "<leader>r",
                    group = "rename",
                },
            })
        end,
    },
}
