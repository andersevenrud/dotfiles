--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local M = {
    c = {}
}

local on_attach_list = {}

local lsp_handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.diagnostic.on_publish_diagnostics,
    ['textDocument/hover'] = vim.lsp.handlers.hover,
    ['textDocument/signatureHelp'] = vim.lsp.handlers.signature_help
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
        if v.link then
            vim.highlight.link(k, v.link)
        else
            vim.highlight.create(k, v)
        end
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
M.set_lsp_signs = function(signs)
    for k, v in pairs(signs) do
        vim.fn.sign_define(k, v)
    end
end

-- LSP Handler options
M.set_lsp_options = function(options)
    for k, v in pairs(options) do

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
                local utils = nlsu.make_conditional_utils()

                if prefix then
                    local project_local_bin = prefix .. command
                    command = utils.root_has_file(project_local_bin) and project_local_bin or command
                end

                instance = builtin.with({
                    command = command,
                    condition = function(utils)
                        return utils.root_has_file(root_file) and check_executable(command)
                    end
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

    return nil
end

-- Initialization wrapper
M.load = function(config, shims)
    M.c = config

    M.set_options(config.vim.options)
    M.set_highlights(config.vim.highlights)
    M.set_aliases(config.vim.aliases)
    M.set_rules(config.vim.rules)
    M.set_keymaps(config.vim.keybindings)
    M.set_lsp_signs(config.lsp.signs)
    M.set_lsp_options(config.lsp.options)
    M.set_auto_commands(config.vim.autocommands)
    M.packer_load(config.packer, shims)
end

return M
