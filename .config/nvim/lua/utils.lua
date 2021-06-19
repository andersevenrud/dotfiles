--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local M = {}

-- A very crude way to use wildignore list
M.wildcars_to_table = function(defaults)
    local result = {}
    for _, v in pairs(vim.split(vim.o.wildignore, ',')) do
        local p = v:gsub('^*.(%a+)$', '%%.%1')
        table.insert(result, p)
    end
    return vim.tbl_extend('keep', defaults, result)
end

-- Overrides diagnosticls configuration with a custom merge
M.compose_diagnostic_config = function(from, config, requiredFiles)
    return vim.tbl_extend('keep', config, {
        requiredFiles = vim.tbl_extend('keep', requiredFiles, from.rootPatterns)
    }, from)
end

-- Collapses a tuple, i.e. creates object from entries
M.collapse_tuple_array = function(a)
    local result = {}
    for _, v in ipairs(a) do
        for _, ft in pairs(v[1]) do
            result[ft] = v[2]
        end
    end
    return result
end

-- Extended LSP capabilities
M.get_lsp_capabilities = function(extended)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if extended then
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                'documentation',
                'detail',
                'additionalTextEdits',
            }
        }
    end
    return capabilities
end

return M
