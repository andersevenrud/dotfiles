--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local on_attach_list = {}

local M = {
    config = {}
}

-- protected require
M.prequire = function(req, fallback)
    local status, result = pcall(require, req)
    if status == false then
        return fallback
    end
    return result
end

-- Options
M.set_options = function(options)
    for k, v in pairs(options) do
        vim.opt[k] = v
    end
end

-- Highlights
M.set_highlights = function(highlights)
    for k, v in pairs(highlights) do
        vim.api.nvim_set_hl(0, k, v)
    end
end

-- Custom filetypes
M.set_aliases = function(aliases)
    for k, v in pairs(aliases) do
        vim.cmd('autocmd BufNewFile,BufRead ' .. k .. ' set ft=' .. v)
    end
end

-- Custom rules per filetype
M.set_rules = function(rules)
    for k, v in pairs(rules) do
        local locals = {}
        for a, b in pairs(v) do
            table.insert(locals, string.format('%s=%s', a, b))
        end
        vim.cmd('autocmd FileType ' .. k .. ' setlocal ' .. table.concat(locals, ' '))
    end
end

-- Keymaps mardown output
M.set_keymaps_dump = function(keymaps)
    local paddings = { 8, 12, 16, 38 }

    local pad = function(s, l, p)
        return s .. string.rep(p or ' ', l - #s)
    end

    local tick = function(s)
        return '`' .. s .. '`'
    end

    local printer = function(...)
        local strings = {}

        for i, v in ipairs({ ... }) do
            if v == '-' then
                table.insert(strings, pad(v, paddings[i], v))
            else
                table.insert(strings, pad(v, paddings[i]))
            end
        end

        print(' | ' .. table.concat(strings, ' | ') .. ' |')
    end

    local function iterate(k, lsp)
        for _, v in ipairs(k) do
            if v.lsp ~= nil then
                iterate(v.keybindings, v.lsp)
            else
                local mode = v[1]
                local submode = lsp and tick(lsp) or ''
                local binding = tick(v[2])
                local description = v[5] or v[3]
                printer(mode, submode, binding, description)
            end
        end
    end

    printer('Mode', 'LSP', 'Binding', 'Description')
    printer('-', '-', '-', '-')
    iterate(keymaps)
end

-- Keymaps
M.set_keymaps = function(keymaps, bufnr)
    for _, v in ipairs(keymaps) do
        if v.lsp ~= nil then
            M.add_on_attach(v.lsp, function(_, bnr)
                M.set_keymaps(v.keybindings, bnr)
            end)
        else
            if bufnr ~= nil then
                vim.api.nvim_buf_set_keymap(bufnr, v[1], v[2], v[3], v[4] and v[4] or {})
            else
                vim.api.nvim_set_keymap(v[1], v[2], v[3], v[4] and v[4] or {})
            end
        end
    end
end

-- LSP Signs
M.set_diagnostic_signs = function(signs)
    for k, v in pairs(signs) do
        vim.fn.sign_define(k, v)
    end
end

-- LSP Handler handlers
M.set_lsp_handlers = function(handlers)
    local lsp_handlers = {
        ['textDocument/publishDiagnostics'] = vim.lsp.diagnostic.on_publish_diagnostics,
        ['textDocument/hover'] = vim.lsp.handlers.hover,
        ['textDocument/signatureHelp'] = vim.lsp.handlers.signature_help
    }

    for k, v in pairs(handlers) do
        vim.lsp.handlers[k] = vim.lsp.with(
            lsp_handlers[k],
            v
        )
    end
end

-- Autocmd
M.autocmd = function(cmd)
    local group = table.concat(cmd[1], ',')
    vim.cmd(string.format('autocmd %s %s %s', group, cmd[2], cmd[3]))
end

-- Wrapper for multiple commands
M.autocmds = function(cmds)
    for _, c in pairs(cmds) do
        M.autocmd(c)
    end
end

-- Wrapper for multiple commands with a namespace
M.autocmds_ns = function(ns, cmds)
    vim.cmd('augroup ' .. ns)
    vim.cmd('autocmd!')
    M.autocmds(cmds)
    vim.cmd('augroup END')
end

-- Wrapper for autocmds_ns over entries
M.set_auto_commands = function(entries)
    for ns, cmds in pairs(entries) do
        M.autocmds_ns(ns, cmds)
    end
end

-- Converts wildcard options to a table
M.wildcars_to_table = function(wildignore)
    local result = {}
    for _, v in ipairs(wildignore) do
        local p = v:gsub('^*.(%a+)$', '%%.%1')
        table.insert(result, p)
    end
    return result
end

-- Wrapper for applying globals
M.apply_globals = function(list, prefix)
    prefix = prefix and prefix or ''
    for k, v in pairs(list) do
        vim.g[prefix .. k] = v
    end
end

-- Creates a binding used for lsp on_attach
M.add_on_attach = function(ns, fn)
    if on_attach_list[ns] == nil then
        on_attach_list[ns] = {}
    end

    table.insert(on_attach_list[ns], fn)
end

-- Runs all bindings used for lsp on_attach
M.run_on_attach = function(ns, ...)
    local list = on_attach_list[ns]
    if list == nil then
        return
    end

    for _, fn in ipairs(list) do
        fn(...)
    end
end

-- Packer.nvim plugin loader wrapper
M.packer_load = function(config, shims)
    local startup = function(use)
        for _, v in ipairs(config.load) do
            if type(v) == 'string' and shims[v] then
                local s = vim.tbl_deep_extend('keep', { v }, shims[v])
                use(s)
            else
                use(v)
            end
        end
    end

    require'packer'.startup({
        startup,
        config = config.options
    })
end

-- null-ls source loading abstraction
M.load_null_ls_sources = function(nls, nlsh, nlsu, config)
    local sources = {}

    local check_executable = function(cmd)
        return vim.fn.executable(cmd) > 0
    end

    for _, ns in pairs({ 'formatting', 'diagnostics' }) do
        for _, t in pairs(config[ns]) do
            local name, root_file = unpack(t)
            local builtin = nls.builtins[ns][name]
            local instance = builtin.with({
                condition = function()
                    return check_executable(builtin._opts.command)
                end
            })

            if root_file then
                local command = builtin._opts.command
                local prefix = config.bin[root_file]

                instance = builtin.with({
                    command = command,
                    prefer_local = prefix,
                })
            end

            table.insert(sources, instance)
        end
    end

    return sources
end

-- Returns another string if the input is empty
M.empty_string_or = function(s, ors)
    return (s == nil or #s == 0) and ors or s
end

-- Lualine source for vim-arduino
M.lualine_arduino = function()
    if vim.bo.filetype == 'arduino' then
        local status, port = pcall(vim.call, 'arduino#GetPort')
        if status == true then
            local board = ' ' .. M.empty_string_or(vim.g.arduino_board, 'no board')
            local programmer = ' ' .. M.empty_string_or(vim.g.arduino_programmer, 'no programmer')
            local connection = ''
            if port then
                connection = ' ' .. port .. '  ' .. vim.g.arduino_serial_baud .. 'bps'
            end

            return board .. ' ' .. programmer .. ' ' .. connection
        end
    end

    return ''
end

-- Creates capabilities for LSP according to cmp
M.create_cmp_capabilities = function (capabilities)
    capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()

    local status, cmp = pcall(require, 'cmp_nvim_lsp')
    if status == false then
        return capabilities
    end

    return cmp.update_capabilities(capabilities)
end

-- Creates lua lsp options
M.create_sumneko_server_options = function(settings)
    local sumneko_root_path = vim.fn.stdpath('data') .. '/' .. 'lsp_servers/sumneko_lua/extension/server'
    local sumneko_binary = sumneko_root_path .. '/bin/lua-language-server'
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    return {
        cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
        settings = vim.tbl_deep_extend('force', {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = runtime_path
                },
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true)
                },
            }
        }, settings)
    }
end

-- Automate insallation of lsp servers
M.install_all_lsp_servers = function()
    local names = vim.tbl_keys(M.config.lsp.servers)
    local lsp_installer = require'mason.api.command'

    lsp_installer.MasonInstall(names)
end

-- Automates setup of LSP integrations
M.setup_lsp = function()
    local lsp_installer = require'mason'
    local lsp_signature = require'lsp_signature'
    local nvim_lsp = require'lspconfig'
    local capabilities = M.create_cmp_capabilities()
    local names = vim.tbl_keys(M.config.lsp.servers)
    local flags = M.config.lsp.flags

    local set_options = function(_, bufnr)
        for k, v in pairs(M.config.lsp.options) do
            vim.api.nvim_buf_set_option(bufnr, k, v)
        end
    end

    local on_attach = function(k)
        return function(...)
            M.run_on_attach(k, ...)
            M.run_on_attach('*', ...)
            set_options(...)
            lsp_signature.on_attach(M.config.lsp_signature)
        end
    end

    local create_options = function(name)
        return vim.tbl_extend('keep', {
            capabilities = capabilities,
            flags = flags,
            on_attach = on_attach(name)
        }, M.config.lsp.servers[name])
    end

    lsp_installer.setup({})

    for _, name in pairs(names) do
        local options = create_options(name)
        nvim_lsp[name].setup(options)
    end
end

-- Initialization wrapper
M.load = function(config, shims)
    M.config = config
    M.set_options(config.vim.options)
    M.set_highlights(config.vim.highlights)
    M.set_aliases(config.vim.aliases)
    M.set_rules(config.vim.rules)
    M.set_keymaps(config.vim.keybindings)
    M.set_lsp_handlers(config.lsp.handlers)
    M.set_auto_commands(config.vim.autocommands)
    M.packer_load(config.packer, shims)

    M.set_diagnostic_signs(config.diagnostics.signs)
    vim.diagnostic.config(config.diagnostics.options)

    -- M.set_keymaps_dump(config.vim.keybindings)
    vim.cmd([[command LspInstallAll :lua require'andersevenrud.neovim'.install_all_lsp_servers()]])
end

return M
