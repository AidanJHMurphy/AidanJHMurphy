local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({buffer = bufnr})
end)

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'lua_ls',
    'ltex',
    'rust_analyzer',
    'arduino_language_server',
    'bashls',
    'cssls',
    'dockerls',
    'docker_compose_language_service',
    'gopls',
    'html',
    'jsonls',
    'marksman',
    'sqlls',
})

lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

lsp.setup()
