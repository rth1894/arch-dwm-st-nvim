return {
    {
        "stevearc/oil.nvim",

        cmd = "Oil",

        columns = {
            "icon",
            "size",
            "mtime",
        },

        keys = {
            {
                "-",
                "<cmd>Oil<cr>",
                desc = "Open parent directory",
            },
            {
                "<leader>pv",
                "<cmd>Oil<cr>",
                desc = "Open parent directory",
            },
        },

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = {
            default_file_explorer = true,

            view_options = {
                show_hidden = true,
            },

            skip_confirm_for_simple_edits = true,
        },
    },
}
