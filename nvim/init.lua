---@diagnostic disable: undefined-global
----------------------------------------------------------
-- 1. БАЗОВЫЕ НАСТРОЙКИ (OPTIONS)
-- Здесь мы говорим Neovim, как себя вести: отступы, нумерация, буфер обмена.
----------------------------------------------------------

-- Определяем пути для хранения временных файлов (undo, backup),
-- чтобы они не мусорили в папках проекта.
local undodir = vim.fn.stdpath('cache') .. '/undo'
local backupdir = vim.fn.stdpath('cache') .. '/backup'
local swapdir = vim.fn.stdpath('cache') .. '/swap'

-- Создаем эти папки, если их нет
vim.fn.mkdir(undodir, "p")
vim.fn.mkdir(backupdir, "p")
vim.fn.mkdir(swapdir, "p")

-- Настройки сохранения
vim.opt.swapfile = false -- Отключаем swap-файлы
vim.opt.backup = false   -- Бэкапы тоже не нужны
vim.opt.undofile = true  -- ВАЖНО: сохранять историю отмены (Undo) после перезагрузки
vim.opt.undodir = undodir

-- Внешний вид
vim.opt.number = true         -- Показать номера строк
vim.opt.relativenumber = true -- Относительные номера
vim.opt.mouse = 'a'           -- Разрешить использование мышки
vim.opt.termguicolors = true  -- Включить поддержку 16 млн цветов
vim.opt.scrolloff = 8         -- Курсор не прилипает к краю экрана

-- Системный буфер обмена
vim.opt.clipboard = 'unnamedplus'

-- Поиск
vim.opt.ignorecase = true -- Игнорировать регистр при поиске
vim.opt.smartcase = true  -- Если написана Большая буква, искать точно
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- ГЛАВНАЯ КЛАВИША (Leader Key) - Пробел
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ОТСТУПЫ (Идеально для React/JS)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

----------------------------------------------------------
-- 2. МЕНЕДЖЕР ПЛАГИНОВ (LAZY.NVIM)
----------------------------------------------------------

-- Проверяем и устанавливаем Lazy.nvim, если его нет
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- СПИСОК ПЛАГИНОВ
require("lazy").setup({

  -- [ТЕМА] Tokyo Night
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- [БИБЛИОТЕКИ]
  'nvim-tree/nvim-web-devicons',
  'nvim-lua/plenary.nvim',

  -- [ФАЙЛОВЫЙ МЕНЕДЖЕР] Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Explorer" },
    },
  },

  -- [ПОИСК] Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find Text' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
    end
  },

  -- [ПОДСВЕТКА] Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "javascript", "typescript", "tsx", "html", "css", "json", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- [АВТОМАТИЗАЦИЯ]
  { 'windwp/nvim-ts-autotag', opts = {} },
  { 'windwp/nvim-autopairs',  event = "InsertEnter", opts = {} },

  -- [КОММЕНТАРИИ]
  { 'numToStr/Comment.nvim',  opts = {},             lazy = false },

  -- [GIT]
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        map('n', ']c', function() gs.next_hunk() end)
        map('n', '[c', function() gs.prev_hunk() end)
        map('n', '<leader>gp', gs.preview_hunk)
        map('n', '<leader>gb', gs.blame_line)
      end
    },
  },

  -- [LSP, MASON, CMP] Настройка интеллекта
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "html", "cssls", "lua_ls", "eslint" },
        handlers = {
          function(server_name)
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = function(_, bufnr)
                local opts = { buffer = bufnr, noremap = true, silent = true }
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
              end,
            })
          end,
          ["lua_ls"] = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = { globals = { "vim" } }
                }
              }
            })
          end,
        }
      })
    end
  },

  -- [ФОРМАТИРОВАНИЕ] Prettier
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },

  -- [АВТОДОПОЛНЕНИЕ] CMP
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        })
      })
    end
  },

  -- [СТАТУС-СТРОКА]
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      },
    }
  }
})

----------------------------------------------------------
-- 4. ОБЩИЕ ХОТКЕИ
----------------------------------------------------------
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprev<CR>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR><Esc>', { silent = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- Перемещение строк в Normal Mode (Alt+j / Alt+k)
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Перемещение блоков в Visual Mode (выделил и двигаешь)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Удобный выход из скобок (имитация стрелки вправо в режиме Insert)
vim.keymap.set('i', '<C-l>', '<Right>', { desc = "Move right in insert mode" })
