return {
    {
        "mason-org/mason.nvim",

        cmd = "Mason",

        opts = {},
    },

    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },

        opts = {
            ensure_installed = {
                "lua_ls",
                "clangd",
                "pyright",
                "rust_analyzer",
                "ts_ls",
                "html",
                "cssls",
                "jsonls",
                "bashls",
            },
        },
    },
}
