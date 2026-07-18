return {
    {
        "nvim-treesitter/nvim-treesitter",

        build = ":TSUpdate",

        event = {
            "BufReadPost",
            "BufNewFile",
        },

        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "css",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "rust",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },

            highlight = {
                enable = true,
            },

            indent = {
                enable = true,
            },
        },

        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end,
    },
}
