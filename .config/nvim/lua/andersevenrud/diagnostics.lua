--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local nls = require'null-ls'
local nlsh = require'null-ls.helpers'
local nlsm = require'null-ls.methods'

-- TODO: Submit this as a PR
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

local null_with = function(root_file, prefix)
    return function(cmd, builtin)
        return nlsh.conditional(function(utils)
            local project_local_bin = prefix .. cmd

            return builtin.with({
                command = utils.root_has_file(project_local_bin) and project_local_bin or cmd,
                conditional = function()
                    return utils.root_has_file(root_file)
                end,
            })
        end)
    end
end

local null_npx = null_with('package.json', 'node_modules/.bin/')
local null_composer = null_with('composer.json', 'vendor/bin/')

return function()
    return {
        sources = {
            null_npx('eslint', nls.builtins.formatting.eslint),
            null_npx('prettier', nls.builtins.formatting.prettier),
            null_composer('php-cs-fixer', nls.builtins.formatting.phpcsfixer),
            nls.builtins.formatting.stylua.with({
                conditional = function(utils)
                    return utils.root_has_file('stylua.toml')
                end
            }),

            null_npx('eslint', nls.builtins.diagnostics.eslint),
            null_npx('stylelint', stylelint),
            null_composer('phpcs', nls.builtins.diagnostics.phpcs),
            nls.builtins.diagnostics.luacheck,
        }
    }
end
