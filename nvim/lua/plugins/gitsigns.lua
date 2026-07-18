return {
    {
        "lewis6991/gitsigns.nvim",

        event = "BufReadPre",

        opts = {
            current_line_blame = true,

            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local map = function(lhs, rhs)
                    vim.keymap.set("n", lhs, rhs, {
                        buffer = bufnr,
                    })
                end

                map("]h", gs.next_hunk)
                map("[h", gs.prev_hunk)

                map("<leader>hs", gs.stage_hunk)
                map("<leader>hr", gs.reset_hunk)
                map("<leader>hp", gs.preview_hunk)
                map("<leader>hb", gs.blame_line)
            end,
        },
    },
}
