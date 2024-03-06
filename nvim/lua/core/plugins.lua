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

    -- lua library for neovim async
    -- dependency of several packages
    use 'nvim-lua/plenary.nvim'

    -- pretty bottom line
    use {
        'nvim-lualine/lualine.nvim',
    }

    -- nice splash screen
    use {
        'goolord/alpha-nvim',
        config = function ()
            require'alpha'.setup(require'alpha.themes.startify'.config)
        end
    }

    -- searching
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0'
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

    -- DB interface
    use {
        'tpope/vim-dadbod',
        'kristijanhusak/vim-dadbod-ui'
    }

    -- Markdown Composer
    use({
        'euclio/vim-markdown-composer',
        run = "cargo build --release",
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
