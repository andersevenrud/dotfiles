local secrets = require("secrets")
local nvim_lsp = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'gitsigns'.setup()
require'nvim-ts-autotag'.setup()
require'lsp_signature'.on_attach()
require'lspsaga'.init_lsp_saga{}

--
-- Lualine
--
require'lualine'.setup{
  options = {
    theme = 'nord'
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = { { 'branch', icon = '' }, { 'diagnostics', sources = { 'nvim_lsp' } } },
    lualine_c = { { 'filename', file_status = true } },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  }
}

--
-- Compe
--
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    treesitter = true;
    tabnine = {
      max_num_results = 6;
      priority = 0;
      max_line = 1000;
    }
  };
}

--
-- Treesitter
--
require'nvim-treesitter.configs'.setup{
  ensure_installed = {
    'typescript',
    'javascript',
    'css',
    'bash',
    'html',
    'json',
    'lua',
    'python',
    'c',
    'cpp',
    'regex',
    'vue'
  },
  context_commentstring = {
    enable = true
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
}

--
-- Telescope
--
require'telescope'.setup{
  builtin = {
    treesitter = true
  }
}

--
-- LSP Servers
--
nvim_lsp.dockerls.setup{
  capabilities = capabilities
}
nvim_lsp.yamlls.setup{
  capabilities = capabilities
}
nvim_lsp.pyls.setup{
  capabilities = capabilities
}
nvim_lsp.vuels.setup{
  capabilities = capabilities
}
nvim_lsp.cssls.setup{
  capabilities = capabilities
}
nvim_lsp.vuels.setup{
  capabilities = capabilities
}
nvim_lsp.html.setup {
  capabilities = capabilities
}
nvim_lsp.tsserver.setup {
  capabilities = capabilities,
    on_attach = function(client, bufnr)
        require("nvim-lsp-ts-utils").setup {}

        -- no default maps, so you may want to define some here
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Go", ":LspOrganize<CR>", {silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Gf", ":LspFixCurrent<CR>", {silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Gr", ":LspRenameFile<CR>", {silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Gi", ":LspImportAll<CR>", {silent = true})
    end
}
nvim_lsp.intelephense.setup{
  capabilities = capabilities,
  init_options = {
    licenceKey = secrets.intelephense.licenceKey
  }
}

--
-- Hide the inline diagnostics
--
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = true,
    signs = true,
  }
)
vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]
vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]
