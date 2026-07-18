return {
    {
        "folke/snacks.nvim",

        priority = 1000,
        lazy = false,

        opts = {
            bigfile = {
                enabled = true,
            },

            notifier = {
                enabled = true,
            },

            input = {
                enabled = true,
            },

            picker = {
                enabled = true,
            },

            quickfile = {
                enabled = true,
            },

            statuscolumn = {
                enabled = true,
            },

            words = {
                enabled = true,
            },
        },

        keys = {
            {
                "<leader><space>",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find Files",
            },

            {
                "<leader>/",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Live Grep",
            },

            {
                "<leader>fb",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Buffers",
            },

            {
                "<leader>fh",
                function()
                    Snacks.picker.help()
                end,
                desc = "Help",
            },

            {
                "<leader>fr",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Recent Files",
            },
        },
    },
}
