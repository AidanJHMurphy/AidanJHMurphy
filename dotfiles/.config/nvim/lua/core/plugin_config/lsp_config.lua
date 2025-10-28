require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "sqlls",
        "eslint",
        "ts_ls",
        "gopls",
        "jsonls",
        "yamlls",
        "html",
        "cssls",
        "bashls",
        "marksman",
    }
})

--try out:
-- alex: inclusive phrasing
-- cbfmt: code blocks within a markdown doc
-- glow: Markdown pizzaz?
-- ltexls: latex and markdown?
-- markdownlint: more markdown?
-- mdformat: moremarkdown?!
-- prettier: Replacement for markdown, css, html, json, jsx, javascript, typescript, yaml, more!
-- nil_ls: nixos
-- nixd: nixos


-- standard keybinding
local custom_lsp_keymaps = function()
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

local auto_format_on_save = function(client, bufnr)
    local lsp_fmt_augrp = vim.api.nvim_create_augroup("LspFormatting", {})
    if client:supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({
            group = lsp_fmt_augrp,
            buffer = bufnr
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = lsp_fmt_augrp,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

-- default behavior for all languages that don't need customization
local default_on_attach = function(client, bufnr)
    custom_lsp_keymaps()
    auto_format_on_save(client, bufnr)
end

local default_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- cute diagnostic icons
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- language setup
local lsp = require("lspconfig")
local util = require "lspconfig/util"

lsp.lua_ls.setup {
    on_attach = default_on_attach,
    capabilities = default_capabilities,

    -- recognize vim global
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    }
}

-- diagnostics not really working at all
-- config lives in .config/sql-language-server/.sqllsrc.json
lsp.sqlls.setup {
    on_attach = default_on_attach,
    capabilities = default_capabilities,
}

lsp.gopls.setup {
    on_attach = default_on_attach,
    capabilities = default_capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true,
            },
        },
    },
}

lsp.eslint.setup({
    on_attach = function(_, bufnr)
        custom_lsp_keymaps()

        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll"
        })
    end,
    capabilities = default_capabilities,
    root_dir = util.root_pattern("package.json", ".git"),
})

lsp.ts_ls.setup {
    on_attach = default_on_attach,
    capabilities = default_capabilities,
}

lsp.jsonls.setup {
    on_attach = default_on_attach,
    capabilities = default_capabilities,
}

-- diagnostics not working
lsp.bashls.setup {
    on_attach = default_on_attach,
    capabilities = default_capabilities,
}

--lsp.marksman.setup {
--    on_attach = default_on_attach,
--    capabilities = default_capabilities,
--}

lsp.yamlls.setup {
    on_attach = default_on_attach,
    capabilities = default_capabilities,
}

lsp.cssls.setup {
    on_attach = default_on_attach,
    capabilities = default_capabilities,
}
