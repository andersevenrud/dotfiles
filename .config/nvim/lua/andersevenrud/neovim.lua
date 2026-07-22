--
-- NeoVim 0.11+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local jsonpath = require'andersevenrud.jsonpath'

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
    local extension = {}
    local pattern = {}

    for k, v in pairs(aliases) do
        local ext = k:match('^%*%.([%w_]+)$')
        if ext then
            extension[ext] = v
        else
            pattern[k] = v
        end
    end

    vim.filetype.add({ extension = extension, pattern = pattern })
end

-- Custom rules per filetype
M.set_rules = function(rules)
    local group = vim.api.nvim_create_augroup('FiletypeRules', { clear = true })

    for ft, options in pairs(rules) do
        vim.api.nvim_create_autocmd('FileType', {
            group = group,
            pattern = ft,
            callback = function(args)
                for k, v in pairs(options) do
                    vim.bo[args.buf][k] = v
                end
            end,
        })
    end
end

-- Keymaps
M.set_keymaps = function(keymaps, bufnr)
    for _, v in ipairs(keymaps) do
        if v.lsp ~= nil then
            M.add_on_attach(v.lsp, function(_, bnr)
                M.set_keymaps(v.keybindings, bnr)
            end)
        else
            local opts = vim.deepcopy(v[4] or {})

            -- vim.keymap.set defaults to non-recursive and ignores `noremap`
            opts.remap = opts.noremap ~= true
            opts.noremap = nil
            opts.desc = v[5]
            opts.buffer = bufnr

            vim.keymap.set(v[1], v[2], v[3], opts)
        end
    end
end

-- Diagnostic sign text per severity
M.create_diagnostic_signs = function(signs)
    local text = {}
    for k, v in pairs(signs) do
        text[vim.diagnostic.severity[k]] = v
    end
    return text
end

-- Autocmds, grouped by namespace
M.set_auto_commands = function(entries)
    for ns, cmds in pairs(entries) do
        local group = vim.api.nvim_create_augroup(ns, { clear = true })

        for _, cmd in pairs(cmds) do
            local action = cmd[3]
            vim.api.nvim_create_autocmd(cmd[1], {
                group = group,
                pattern = cmd[2],
                callback = type(action) == 'function' and action or nil,
                command = type(action) == 'string' and action or nil,
            })
        end
    end
end

-- Converts wildcard options to lua patterns
M.wildcards_to_table = function(wildignore)
    local result = {}

    for _, v in ipairs(wildignore) do
        local pattern = v:gsub('[%^%$%(%)%%%.%[%]%+%-%?]', '%%%0')

        if pattern:find('%*') then
            table.insert(result, pattern:gsub('%*', '.*') .. '$')
        else
            table.insert(result, pattern .. '$')
            table.insert(result, pattern .. '/')
        end
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

-- lazy.nvim plugin loader wrapper
M.lazy_load = function(config, shims)
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
    if not vim.uv.fs_stat(lazypath) then
        vim.fn.system({
            'git', 'clone', '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath
        })
    end
    vim.opt.rtp:prepend(lazypath)

    local specs = {}
    for _, v in ipairs(config.load) do
        if type(v) == 'string' and shims[v] then
            table.insert(specs, vim.tbl_deep_extend('keep', { v }, shims[v]))
        else
            table.insert(specs, type(v) == 'string' and { v } or v)
        end
    end

    require'lazy'.setup(specs, config.options)
end

-- Treesitter setup (nvim-treesitter `main` branch)
--
-- The `main` branch provides no modules: it only installs parsers and queries.
-- Features are enabled per buffer, which is done here for every filetype that
-- resolves to an installed parser.
M.setup_treesitter = function(config)
    local ts = require'nvim-treesitter'

    ts.setup(config.options)
    ts.install(config.install)

    for ft, lang in pairs(config.languages) do
        vim.treesitter.language.register(lang, ft)
    end

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterFeatures', { clear = true }),
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
            if not lang then
                return
            end

            -- NOTE: `get_lang` falls back to the filetype itself when it has no
            -- mapping, so plugin UI buffers (TelescopePrompt, noice, etc.) end up
            -- here as well. `language.add` returns `nil, err` instead of raising
            -- when no parser exists, hence checking its result and not just the
            -- pcall status.
            local ok, added = pcall(vim.treesitter.language.add, lang)
            if not ok or not added then
                return
            end

            vim.treesitter.start(args.buf, lang)

            if config.indent then
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })
end

-- Treesitter textobject keymaps (nvim-treesitter-textobjects `main` branch)
--
-- The `main` branch dropped its keymap configuration in favour of plain
-- keymaps calling into its modules, which is abstracted away here.
M.setup_treesitter_textobjects = function(config)
    require'nvim-treesitter-textobjects'.setup(config.options)

    local map = function(modes, lhs, fn, desc)
        vim.keymap.set(modes, lhs, fn, { silent = true, desc = desc })
    end

    for lhs, query in pairs(config.select) do
        map({ 'x', 'o' }, lhs, function()
            require'nvim-treesitter-textobjects.select'.select_textobject(query, 'textobjects')
        end, 'Select ' .. query)
    end

    for name, keys in pairs(config.swap) do
        for lhs, query in pairs(keys) do
            map('n', lhs, function()
                require'nvim-treesitter-textobjects.swap'[name](query)
            end, 'Swap ' .. query)
        end
    end

    for name, keys in pairs(config.move) do
        for lhs, query in pairs(keys) do
            map({ 'n', 'x', 'o' }, lhs, function()
                require'nvim-treesitter-textobjects.move'[name](query, 'textobjects')
            end, 'Move ' .. query)
        end
    end
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
M.create_autocomplete_capabilities = function (capabilities)
    capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()

    local autocomplete_capabilities = require('blink.cmp').get_lsp_capabilities()

    return vim.tbl_deep_extend('force', capabilities, autocomplete_capabilities)
end

-- Creates the arduino LSP command, using the first cli config found
M.create_arduino_command = function(candidates)
    local cmd = { 'arduino-language-server' }

    local config = vim.iter(candidates):map(vim.fn.expand):find(function(path)
        return vim.uv.fs_stat(path) ~= nil
    end)

    if config then
        vim.list_extend(cmd, { '-cli-config', config })
    end

    return cmd
end

-- Automates setup of LSP integrations
M.setup_lsp = function()
    local mason = require'mason'
    local mason_lsp = require'mason-lspconfig'
    local capabilities = M.create_autocomplete_capabilities()
    local names = vim.tbl_keys(M.config.lsp.servers)
    local flags = M.config.lsp.flags

    local set_options = function(_, bufnr)
        for k, v in pairs(M.config.lsp.options) do
            vim.bo[bufnr][k] = v
        end
    end

    local attach_plugins = function(client, bufnr)
        if client:supports_method('textDocument/documentColor') then
            vim.lsp.document_color.enable(true, { bufnr = bufnr })
        end

        if client:supports_method('textDocument/documentHighlight') then
            vim.api.nvim_create_augroup('lsp_document_highlight', {
                clear = false
            })
            vim.api.nvim_clear_autocmds({
                buffer = bufnr,
                group = 'lsp_document_highlight',
            })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                group = 'lsp_document_highlight',
                buffer = bufnr,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                group = 'lsp_document_highlight',
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end

    local on_attach = function(k)
        return function(...)
            M.run_on_attach(k, ...)
            M.run_on_attach('*', ...)
            set_options(...)
            attach_plugins(...)
        end
    end

    mason.setup({})

    mason_lsp.setup({
        ensure_installed = names,
        automatic_enable = false
    })

    M.install_mason_packages(M.config.mason.packages)

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
            local client_id = ev.data.client_id
            local client = assert(vim.lsp.get_client_by_id(client_id))
            on_attach(client.name)(client, ev.buf)
        end
    })

    vim.lsp.config('*', {
        capabilities = capabilities,
        flags = flags,
    })

    for _, name in ipairs(names) do
        vim.lsp.config(name, M.config.lsp.servers[name])
        vim.lsp.enable(name)
    end
end

-- Mason packages where the lspconfig name mapping is ambiguous or absent
M.install_mason_packages = function(packages)
    local registry = require'mason-registry'

    for _, name in ipairs(packages) do
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() then
            pkg:install()
        end
    end
end

-- Debugger UI, opened and closed with the session
M.setup_dap_ui = function(config)
    local dap = require'dap'
    local dapui = require'dapui'

    dapui.setup(config)

    dap.listeners.after.event_initialized['dapui'] = function() dapui.open() end
    dap.listeners.before.event_terminated['dapui'] = function() dapui.close() end
    dap.listeners.before.event_exited['dapui'] = function() dapui.close() end
end

-- Debug adapters and configurations
M.setup_dap = function(config)
    local dap = require'dap'

    for name, adapter in pairs(config.adapters) do
        dap.adapters[name] = adapter
    end

    for ft, configurations in pairs(config.configurations) do
        dap.configurations[ft] = configurations
    end
end

-- Initialization wrapper
M.load = function(config, shims)
    M.config = config
    M.apply_globals(config.vim.globals)
    M.set_options(config.vim.options)
    M.set_highlights(config.vim.highlights)
    M.set_aliases(config.vim.aliases)
    M.set_rules(config.vim.rules)
    M.set_keymaps(config.vim.keybindings)
    M.set_auto_commands(config.vim.autocommands)
    M.lazy_load(config.lazy, shims)

    vim.diagnostic.config(vim.tbl_extend('force', config.diagnostics.options, {
        signs = { text = M.create_diagnostic_signs(config.diagnostics.signs) },
    }))

    jsonpath.setup()
end

return M
