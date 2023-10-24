local opts = {
    noremap = true,
    silent = true,
}

vim.api.nvim_set_keymap('n', '<leader>x', '<Cmd>BufferClose<CR>', opts)
vim.api.nvim_set_keymap('n', '<TAB>', '<Cmd>BufferNext<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-TAB>', '<Cmd>BufferPrevious<CR>', opts)

vim.g.barbar_auto_setup = false

require'barbar'.setup {
    icons = {
        gitsigns = {
            added = {enabled = true, icon = '+'},
            changed = {enabled = true, icon = '~'},
            deleted = {enabled = true, icon = '-'},
        },
    },

    sidebar_filetypes = {
        NvimTree = true,
    },
}
