local theme = "gruvbox"

vim.opt.termguicolors = true
local ok, _ = pcall(vim.cmd, "colorscheme " .. theme)
if not ok then
    vim.cmd 'colorscheme default'
end
