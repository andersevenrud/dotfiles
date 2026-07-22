--
-- NeoVim 0.11+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local M = {}

local current_window = nil
local original_window = nil

local tmux = function(args, blocking)
    local proc = vim.system(vim.list_extend({ 'tmux' }, args))
    local result = blocking and proc:wait(1000) or nil
    return result and vim.trim(result.stdout or '') or ''
end

-- tmux rejects window names containing '.' or ':'
local rename_window = function(name, blocking)
    if name == '' or (not blocking and name == current_window) then
        return
    end

    current_window = name
    tmux({ 'rename-window', (name:gsub('[.:]', '-')) }, blocking)
end

M.setup = function()
    if not os.getenv('TMUX') then
        return
    end

    original_window = tmux({ 'display-message', '-p', '#{window_name}' }, true)

    local group = vim.api.nvim_create_augroup('TmuxWindowTitles', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost', 'BufNewFile', 'BufEnter' }, {
        group = group,
        callback = function()
            local name = vim.fn.expand('%:t')

            rename_window(name)

            if name ~= '' then
                vim.o.titlestring = ' ' .. name
            end
        end,
    })

    vim.api.nvim_create_autocmd('VimLeave', {
        group = group,
        callback = function()
            rename_window(original_window, true)
        end,
    })
end

return M
