--
-- NeoVim 0.11+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local M = {
    register = '*'
}

local unquote = function(node, bufnr)
    return (vim.treesitter.get_node_text(node, bufnr):gsub('^"(.*)"$', '%1'))
end

local root_node = function(bufnr)
    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'json')
    if not ok or not parser then
        return nil
    end

    local tree = parser:parse()[1]
    return tree and tree:root() or nil
end

-- Path to the value under the cursor
M.get = function(bufnr)
    bufnr = bufnr or 0

    local node = vim.treesitter.get_node({ bufnr = bufnr })
    local parts = {}

    while node do
        local parent = node:parent()
        if not parent then
            break
        end

        if parent:type() == 'pair' then
            local key = parent:field('key')[1]
            if key then
                table.insert(parts, 1, unquote(key, bufnr))
            end
        elseif parent:type() == 'array' then
            for i = 0, parent:named_child_count() - 1 do
                if parent:named_child(i) == node then
                    table.insert(parts, 1, tostring(i))
                    break
                end
            end
        end

        node = parent
    end

    return table.concat(parts, '.')
end

-- Node matching a path, descending from the document root
M.find = function(path, bufnr)
    bufnr = bufnr or 0

    local node = root_node(bufnr)
    if not node then
        return nil
    end

    for _, segment in ipairs(vim.split(path, '.', { plain = true, trimempty = true })) do
        while node and node:type() ~= 'object' and node:type() ~= 'array' do
            node = node:named_child(0)
        end

        if not node then
            return nil
        end

        local found = nil

        if node:type() == 'array' then
            found = node:named_child(tonumber(segment) or -1)
        else
            for i = 0, node:named_child_count() - 1 do
                local pair = node:named_child(i)
                local key = pair:type() == 'pair' and pair:field('key')[1]
                if key and unquote(key, bufnr) == segment then
                    found = pair:field('value')[1] or pair
                    break
                end
            end
        end

        if not found then
            return nil
        end

        node = found
    end

    return node
end

-- Moves the cursor to a path
M.goto_path = function(path, bufnr)
    local node = M.find(path, bufnr)
    if not node then
        return false
    end

    local row, col = node:range()
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
    return true
end

M.setup = function()
    vim.api.nvim_create_user_command('JsonPath', function(args)
        if args.args ~= '' then
            if not M.goto_path(args.args) then
                vim.notify('No such path: ' .. args.args, vim.log.levels.WARN)
            end
            return
        end

        local path = M.get()
        if path == '' then
            return
        end

        vim.fn.setreg(M.register, path)
        vim.notify(path)
    end, { nargs = '?' })
end

return M
