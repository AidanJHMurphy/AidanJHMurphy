-- set leader to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- thicc edit cursor
vim.opt.guicursor = ""

-- line numbers and relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- 4-space indenting
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- search highlighting
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- scrolling ergonomics
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- turn on US English spell checking
vim.opt.spelllang = 'en_us'
vim.opt.spell = true
