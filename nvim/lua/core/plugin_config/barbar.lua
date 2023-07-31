local opts = {
    noremap = true,
    silent = true,
}

vim.api.nvim_set_keymap('n', '<leader>x', '<Cmd>BufferClose<CR>', opts)
vim.api.nvim_set_keymap('n', '<TAB>', '<Cmd>BufferNext<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-TAB>', '<Cmd>BufferPrevious<CR>', opts)
