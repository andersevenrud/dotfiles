--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

-- These are my custom dianostics sorces
-- NOTE: https://github.com/jose-elias-alvarez/null-ls.nvim/pull/188

local nls = require'null-ls'
local nlsh = require'null-ls.helpers'
local nlsm = require'null-ls.methods'

local stylelint = nlsh.make_builtin({
    factory = nlsh.generator_factory,
    method = nlsm.internal.DIAGNOSTICS,
    filetypes = { 'scss', 'less', 'css', 'sass' },
    generator_opts = {
        command = 'stylelint',
        args = { '--formatter', 'json', '--stdin-filename', '$FILENAME' },
        to_stdin = true,
        format = 'json_raw',
        on_output = function(params)
            params.messages = params.output and params.output[1] and params.output[1].warnings or {}

            if params.err then
                for _, v in pairs(vim.fn.json_decode(params.err)) do
                    for _, e in pairs(v.warnings) do
                        table.insert(params.messages, e)
                    end
                end
            end

            local parser = nlsh.diagnostics.from_json({
                attributes = {
                    severity = 'severity',
                    message = 'text',
                },
                severities = {
                    nlsh.diagnostics.severities['warning'],
                    nlsh.diagnostics.severities['error'],
                },
            })

            return parser({ output = params.messages })
        end
    }
})

local stylelintfix = nlsh.make_builtin({
    factory = nlsh.formatter_factory,
    method = nlsm.internal.FORMATTING,
    filetypes = { 'scss', 'less', 'css', 'sass' },
    generator_opts = {
        command = 'stylelint',
        args = { '--fix', '--stdin', '-' },
        to_stdin = true,
    }
})

return {
    formatting = {
        stylelint = stylelintfix
    },
    diagnostics = {
        stylelint = stylelint
    }
}
