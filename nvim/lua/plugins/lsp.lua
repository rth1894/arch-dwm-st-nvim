return {
    {
        "neovim/nvim-lspconfig",

        event = {
            "BufReadPre",
            "BufNewFile",
        },

        dependencies = {
            "saghen/blink.cmp",
        },

        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                },

                clangd = {},
                pyright = {},
                rust_analyzer = {},
                ts_ls = {},
                html = {},
                cssls = {},
                jsonls = {},
                bashls = {},
            }

            for name, config in pairs(servers) do
                config.capabilities = capabilities
                vim.lsp.config(name, config)
                vim.lsp.enable(name)
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local map = function(lhs, rhs)
                        vim.keymap.set("n", lhs, rhs, {
                            buffer = ev.buf,
                        })
                    end

                    map("gd", vim.lsp.buf.definition)
                    map("gr", vim.lsp.buf.references)
                    map("gi", vim.lsp.buf.implementation)
                    map("K", vim.lsp.buf.hover)
                    map("<leader>rn", vim.lsp.buf.rename)
                    map("<leader>ca", vim.lsp.buf.code_action)
                    map("<leader>f", function()
                        vim.lsp.buf.format()
                    end)
                end,
            })
        end,
    },
}
