-- Still use Mason to manage the language servers for portability
-- Nix maybe better IDK
-- Honestly need to reevaluate all of these, and figure out which ones
-- I actually want to keep, and which should be cleaned up
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

local format_on_save = function(client, bufnr)
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

-- generic/global config
vim.lsp.config('*', {
    on_attach = function(client, bufnr)
        format_on_save(client, bufnr)
    end
})

vim.diagnostic.config({
    virtual_text = {
        current_line = true -- show inline messages on current line
    },
    signs = {
        -- apply diagnostic icons
        text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
        }
    },
    underline = true, -- underline problematic text
})

-- default lsp behavior is largely good
-- extend or overwrite in nvim/after/lsp/[lsp_name].lua
--
-- Note: I think most of these currently do nothing, since there's no
-- corresponding file in the lsp directory -- need to test
--
-- TODO: somehow combine this list with the Mason ensure_installed directive
-- so that it's only needing to be maintained in one spot
local lsp_servers = {
    lua_ls = "lua-language-server",
    sqlls = 'sql-language-server',
    gopls = 'gopls',
    ts_ls = 'typescript-language-server',
    eslint = 'vscode-eslint-language-server',
    jsonls = 'vscode-json-language-server',
    yaml = 'yaml-language-server',
    html = 'vscode-html-language-server',
    cssls = 'vscode-css-language-server',
    bashls = 'bash-language-server',
    marksman = 'marksman',
    rust = 'rust-analyzer',
    tinymist = 'tinymist',
}

-- for portability, check server can execute before enabling
for server_name, lsp_executable in pairs(lsp_servers) do
    if vim.fn.executable(lsp_executable) == 1 then
        vim.lsp.enable(server_name)
    else
        -- print non-enabled servers for visibility
        print("cannot execute language server: " .. lsp_executable)
    end
end

-- consider applying these overrides
--[[
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

--]]
