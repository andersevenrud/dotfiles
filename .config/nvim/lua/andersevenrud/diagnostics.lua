--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local compose_diagnostic_config = function(from, config, requiredFiles)
    return vim.tbl_extend('keep', config, {
        requiredFiles = vim.tbl_extend('keep', requiredFiles, from.rootPatterns)
    }, from)
end

local collapse_tuple_array = function(a)
    local result = {}
    for _, v in ipairs(a) do
        for _, ft in pairs(v[1]) do
            result[ft] = v[2]
        end
    end
    return result
end

return collapse_tuple_array({
    {
        { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue' },
        {
            linter = compose_diagnostic_config(require'diagnosticls-nvim.linters.eslint', {
                debounce = 1000,
                command = 'node_modules/.bin/eslint',
                rootPatterns = { 'package.json' },
                securities = {
                    [1] = 'error',
                    [2] = 'warning'
                }
            }, { 'package.json' }),

            formatter = compose_diagnostic_config(require 'diagnosticls-nvim.formatters.prettier', {
                command = 'node_modules/.bin/prettier',
                rootPatterns = { 'package.json' },
            }, { 'package.json' })
        }
    },
    {
        { 'scss', 'less', 'css' },
        {
            linter = compose_diagnostic_config(require'diagnosticls-nvim.linters.stylelint', {
                debounce = 1000,
                command = 'node_modules/.bin/stylelint',
                rootPatterns = { 'package.json' },
            }, { 'package.json', '.stylelintrc', 'stylelint.config.js' })
        }
    },
    {
        { 'php' },
        {
            linter = require'diagnosticls-nvim.linters.phpcs'
        }
    }
})
