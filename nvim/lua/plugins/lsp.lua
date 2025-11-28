---@diagnostic disable: undefined-global
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    -- 1. Запускаем Mason
    require("mason").setup()

    -- 2. Настраиваем связку Mason и LSP
    require("mason-lspconfig").setup({
      -- Список серверов для автоматической установки
      ensure_installed = { "ts_ls", "html", "cssls", "lua_ls", "eslint", "emmet_language_server" },

      handlers = {
        -- Стандартная настройка для большинства серверов
        function(server_name)
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = function(_, bufnr)
              local opts = { buffer = bufnr, noremap = true, silent = true }
              -- Горячие клавиши LSP
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            end,
          })
        end,

        -- Специфичная настройка для Emmet
        ["emmet_language_server"] = function()
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          require("lspconfig").emmet_language_server.setup({
            capabilities = capabilities,
            filetypes = {
              "css", "eruby", "html", "javascript", "javascriptreact",
              "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue"
            },
          })
        end,

        -- Специфичная настройка для Lua
        ["lua_ls"] = function()
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require("lspconfig").lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = { diagnostics = { globals = { "vim" } } }
            }
          })
        end,
      }
    })
  end
}
