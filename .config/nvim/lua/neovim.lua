--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local M = {}

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
M.set_keymaps = function(keymaps)
    for _, v in ipairs(keymaps) do
        vim.api.nvim_set_keymap(v[1], v[2], v[3], v[4] and v[4] or {})
    end
end

-- Signs
M.set_lsp_signs = function(signs)
    for k, v in pairs(signs) do
        vim.fn.sign_define(k, v)
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

-- Converts wildcard options to a table
M.wildcars_to_table = function(defaults)
    local result = {}
    for _, v in pairs(vim.split(vim.o.wildignore, ',')) do
        local p = v:gsub('^*.(%a+)$', '%%.%1')
        table.insert(result, p)
    end
    return vim.tbl_extend('keep', defaults, result)
end

-- Wrapper for applying globals
M.apply_globals = function(list, prefix)
    prefix = prefix and prefix or ''
    for k, v in pairs(list) do
        vim.g[prefix .. k] = v
    end
end

return M
