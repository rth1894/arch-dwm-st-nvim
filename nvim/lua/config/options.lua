local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = "\\"

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

opt.wrap = true
opt.scrolloff = 8

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true

opt.splitbelow = true
opt.splitright = true

opt.mouse = "a"

opt.clipboard = "unnamedplus"

opt.undofile = true

opt.updatetime = 200
opt.timeoutlen = 300

opt.completeopt = { "menu", "menuone", "noselect" }

opt.laststatus = 3

opt.fillchars = {
    eob = " ",
}

opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.hlsearch = false
opt.incsearch = true
opt.linebreak = true

vim.opt.scrolloff = 8
