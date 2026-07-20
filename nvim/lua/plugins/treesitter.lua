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
                "lua",
                "llvm",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "rust",
                "toml",
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
