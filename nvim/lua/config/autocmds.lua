local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function()
        vim.cmd([[silent! %s/\s\+$//e]])
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = {
        "help",
        "qf",
        "checkhealth",
        "lspinfo",
    },
    callback = function(ev)
        vim.keymap.set("n", "q", "<cmd>q<cr>", {
            buffer = ev.buf,
            silent = true,
        })
    end,
})
