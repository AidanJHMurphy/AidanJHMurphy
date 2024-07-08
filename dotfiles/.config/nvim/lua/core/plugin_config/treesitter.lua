require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "lua",
        "vim",
        "sql",
        "javascript",
        "typescript",
        "go",
        "html",
        "css",
        "scss",
        "json",
        "yaml",
        "bash",
        "markdown",
        "git_config",
        "gitignore",
    },
    sync_install = false,
    -- Don't have tree-sitter installed locally
    -- Should fix this when move to nix home manager
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
