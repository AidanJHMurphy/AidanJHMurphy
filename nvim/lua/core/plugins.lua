local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            'git',
            'clone',
            '--depth',
            '1',
            'https://github.com/wbthomason/packer.nvim',
            install_path
        })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- package manager
    use 'wbthomason/packer.nvim'

    -- file explorer
    use 'nvim-tree/nvim-tree.lua'
    -- icons
    use 'nvim-tree/nvim-web-devicons'

    -- pretty bottom line
    use {
        'nvim-lualine/lualine.nvim',
    }

    -- searching
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- terminal launcher
    use 'NvChad/nvterm'
    -- syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- auto-complete paired symbols
    -- apparently this one might break visual-multi (multi-cursor)
    use 'jiangmiao/auto-pairs'

    -- visual git integration
    use 'lewis6991/gitsigns.nvim'

    -- nice tab manager
    use 'romgrk/barbar.nvim'

    -- themes
    use 'ellisonleao/gruvbox.nvim'

    -- inline hex colors
    use {
        'RRethy/vim-hexokinase',
        run = 'make hexokinase'
    }

    -- lsp manager
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    }

    -- Markdown preview
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    -- code completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use "rafamadriz/friendly-snippets"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
