----------------------------------------------------------
-- БАЗОВЫЕ ФУНКЦИИ (UNDO, SWAP, BACKUP)
----------------------------------------------------------

-- Директории для специальных файлов Vim
local undodir    = vim.fn.stdpath('cache') .. '/undo'
local backupdir  = vim.fn.stdpath('cache') .. '/backup'
local swapdir    = vim.fn.stdpath('cache') .. '/swap'

-- Если папки нет — создай
vim.fn.mkdir(undodir, "p")
vim.fn.mkdir(backupdir, "p")
vim.fn.mkdir(swapdir, "p")

-- Опции swap и backup
vim.opt.swapfile = false            -- Отключить swap, если не нужен
vim.opt.backup = true               -- Включить backup (на случай сбоя)
vim.opt.backupdir = backupdir
vim.opt.undofile = true             -- Включить сохранение истории undo
vim.opt.undodir = undodir
-- vim.opt.swapfile = true           -- Если хочется swap, раскомментируйте
-- vim.opt.directory = swapdir

----------------------------------------------------------
-- БАЗОВЫЕ НАСТРОЙКИ ИНТЕРФЕЙСА
----------------------------------------------------------
---

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Отступы
vim.opt.tabstop = 2         -- ширина табуляции (2 пробела)
vim.opt.shiftwidth = 2      -- ширина "отступа" для автоотступа (>> и <<)
vim.opt.expandtab = true    -- всегда использовать пробелы вместо табов
vim.opt.autoindent = true   -- включить автоматический отступ
vim.opt.smartindent = true  -- умный отступ (для большинства языков)

----------------------------------------------------------
-- УСТАНОВКА МЕНЕДЖЕРА ПЛАГИНОВ (Lazy.nvim)
-- Позволяет удобно автоматически скачивать и обновлять плагины Neovim.
-- При первом запуске сам скачивает себя с GitHub, настройка занимает пару секунд.
----------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim" }
  },
  ----------------------------------------------------------
  -- ПЛАГИНЫ-ОДНОСТРОЧНИКИ (коротко и ясно)
  ----------------------------------------------------------
  -- Автоматическое определение отступов (tab/space)
  'tpope/vim-sleuth',
  -- Поддержка иконок для тем и файлового дерева
  'nvim-tree/nvim-web-devicons',
  -- Полезная библиотека для многих современных плагинов
  'nvim-lua/plenary.nvim',

  -- Настройка темы
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },

  ----------------------------------------------------------
  -- GIT-ИНТЕГРАЦИЯ (lewis6991/gitsigns.nvim)
  -- Показывает цветные полоски рядом со строками для визуального контроля изменений в git-репозитории.
  ----------------------------------------------------------
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- ДИСПЕТЧЕР ФАЙЛОВ (neo-tree.nvim)
  ----------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- уже установлен
      "MunifTanjim/nui.nvim",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  ----------------------------------------------------------
  -- АВТОДОПОЛНЕНИЕ И LSP (nvim-cmp + плагины + lspconfig)
  ----------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip"
    },
  },
  {
    "neovim/nvim-lspconfig"
  },

  ----------------------------------------------------------
-- СТАТУС-ЛИНИЯ (lualine.nvim)
----------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  }

  -- другие плагины для вставки

})


----------------------------------------------------------
-- ГОРЯЧИЕ КЛАВИШИ
----------------------------------------------------------
-- Открытие/закрытие дерева по <leader>e (чаше это \e или <Space>e)
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Neo-tree toggle" })

-- Переключение буферов через Tab и Shift-Tab
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprev<CR>', { desc = 'Prev Buffer' })


----------------------------------------------------------
-- НАСТРОЙКА ПЛАГИНОВ
----------------------------------------------------------

-- ТЕМА
vim.opt.termguicolors = true
vim.cmd('colorscheme tokyonight')

-- Настройка nvim-treesitter - подсветка синтаксиса
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "lua",
    "vim",
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "yaml",
    "markdown",
    "markdown_inline",
    "bash",
    "dockerfile",
    "gitignore",
    "go",
    "python"
  },
  highlight = { enable = true },
  indent = { enable = true },
}

-- НАСТРОЙКА lualine (статус-линиия)
----------------------------------------------------------
require('lualine').setup {
  options = {
    theme = 'auto',         -- автоматически выбрать тему, подстраиваясь под твою colorscheme
    section_separators = '', -- убрать декоративные разделители, если не нравятся
    component_separators = '',
    icons_enabled = true,
  }
}

-- НАСТРОЙКА АВТОДОПОЛНЕНИЯ (nvim-cmp)
----------------------------------------------------------
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<Tab>']     = cmp.mapping.select_next_item(),
    ['<S-Tab>']   = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' }
  })
})

-- НАСТРОЙКА ЯЗЫКОВОГО СЕРВЕРА (nvim-lspconfig + mason)
----------------------------------------------------------
require("lspconfig").pyright.setup{}
require("lspconfig").ts_ls.setup{}
require("lspconfig").lua_ls.setup{}

----------------------------------------------------------
-- НАСТРОЙКА GITSIGNS И HOTKEYS
----------------------------------------------------------
require('gitsigns').setup({
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '-' },
    topdelete    = { text = '-' },
    changedelete = { text = '~' }
  },
  keymaps = {}, -- чтобы кастомные хоткеи не конфликтовали
})

----------------------------------------------------------
-- GIT HOTKEYS
----------------------------------------------------------

-- Перейти к следующему hunk (изменению)
vim.keymap.set('n', ']c', function()
  require('gitsigns').next_hunk()
end, { desc = "Git: Next hunk" })

-- Перейти к предыдущему hunk
vim.keymap.set('n', '[c', function()
  require('gitsigns').prev_hunk()
end, { desc = "Git: Previous hunk" })

-- Просмотреть diff/preview текущего hunk
vim.keymap.set('n', '<leader>gp', function()
  require('gitsigns').preview_hunk()
end, { desc = "Git: Preview hunk" })

-- Откатить изменения (reset hunk)
vim.keymap.set('n', '<leader>gr', function()
  require('gitsigns').reset_hunk()
end, { desc = "Git: Reset hunk" })

-- Стадировать текущий hunk (add)
vim.keymap.set('n', '<leader>gs', function()
  require('gitsigns').stage_hunk()
end, { desc = "Git: Stage hunk" })

-- Просмотреть изменения в строке под курсором
vim.keymap.set('n', '<leader>gb', function()
  require('gitsigns').blame_line()
end, { desc = "Git: Blame line" })

