return {
    {
        "stevearc/conform.nvim",

        event = {
            "BufWritePre",
        },

        cmd = {
            "ConformInfo",
        },

        opts = {
            notify_on_error = true,

            format_on_save = function(bufnr)
                return {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                }
            end,

            formatters_by_ft = {
                lua = { "stylua" },

                javascript = { "prettierd", "prettier" },
                javascriptreact = { "prettierd", "prettier" },
                typescript = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },

                json = { "prettierd", "prettier" },
                yaml = { "prettierd", "prettier" },
                html = { "prettierd", "prettier" },
                css = { "prettierd", "prettier" },

                python = { "ruff_format" },

                rust = { "rustfmt" },

                sh = { "shfmt" },
            },
        },
    },
}
