local opts = {
    noremap = true,
    silent = true,
}

require("typst-preview").setup()

vim.api.nvim_set_keymap('n', '<leader>tpp', ':TypstPreview<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tps', ':TypstPreviewStop<CR>', opts)

