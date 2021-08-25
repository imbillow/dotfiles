-- Install packer
local install_path = vim.fn.stdpath 'data' ..
                       '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
                   install_path)
end

local use = require('packer').use
require('packer').startup {
  function()
    use 'wbthomason/packer.nvim' -- Package manager
    use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
    use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
    use 'ludovicchabant/vim-gutentags' -- Automatic tags management
    -- UI to select things (files, grep results, open buffers...)
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'},
        {'nvim-telescope/telescope-fzy-native.nvim'},
      },
      config = function()
        require('telescope').setup {
          defaults = {mappings = {i = {['<C-u>'] = false, ['<C-d>'] = false}}},
          extensions = {
            fzy_native = {
              override_generic_sorter = false,
              override_file_sorter = true,
            },
          },
        }
        require('telescope').load_extension('fzy_native')
        -- Add leader shortcuts
        vim.api.nvim_set_keymap('n', '<leader><space>',
                                [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>sf',
                                [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]],
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>sb',
                                [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]],
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>sh',
                                [[<cmd>lua require('telescope.builtin').help_tags()<CR>]],
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>st',
                                [[<cmd>lua require('telescope.builtin').tags()<CR>]],
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>sd',
                                [[<cmd>lua require('telescope.builtin').grep_string()<CR>]],
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>sp',
                                [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>so',
                                [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]],
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>?',
                                [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]],
                                {noremap = true, silent = true})
      end,
    }
    use {
      'joshdick/onedark.vim',
      requires = {'tpope/vim-fugitive'},
      config = function()
        vim.cmd [[colorscheme onedark]]
        vim.g.lightline = {
          colorscheme = 'onedark',
          active = {
            left = {
              {'mode', 'paste'},
              {'gitbranch', 'readonly', 'filename', 'modified'},
            },
          },
          component_function = {gitbranch = 'fugitive#head'},
        }
      end,
    } -- Theme inspired by Atom
    use 'itchyny/lightline.vim' -- Fancier statusline
    -- Add indentation guides even on blank lines
    use 'lukas-reineke/indent-blankline.nvim'
    -- Add git related info in the signs columns and popups
    use {
      'lewis6991/gitsigns.nvim',
      requires = {'nvim-lua/plenary.nvim'},
      config = function()
        require('gitsigns').setup {
          signs = {
            add = {hl = 'GitGutterAdd', text = '+'},
            change = {hl = 'GitGutterChange', text = '~'},
            delete = {hl = 'GitGutterDelete', text = '_'},
            topdelete = {hl = 'GitGutterDelete', text = '‾'},
            changedelete = {hl = 'GitGutterChange', text = '~'},
          },
        }
      end,
    }
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use {
      'nvim-treesitter/nvim-treesitter',
      config = require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true, -- false will disable the whole extension
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
        indent = {enable = true},
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
        },
        autopairs = {enable = true},
      },
    }
    -- Additional textobjects for treesitter
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use {
      'neovim/nvim-lspconfig',
      requires = {'kabouzeid/nvim-lspinstall'},
      config = function()
        local nvim_lsp = require 'lspconfig'
        local on_attach = function(_, bufnr)
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc',
                                      'v:lua.vim.lsp.omnifunc')

          local opts = {noremap = true, silent = true}
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',
                                      '<Cmd>lua vim.lsp.buf.declaration()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',
                                      '<Cmd>lua vim.lsp.buf.definition()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
                                      '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',
                                      '<cmd>lua vim.lsp.buf.implementation()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',
                                      '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa',
                                      '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr',
                                      '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl',
                                      '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D',
                                      '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn',
                                      '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',
                                      '<cmd>lua vim.lsp.buf.references()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca',
                                      '<cmd>lua vim.lsp.buf.code_action()<CR>',
                                      opts)
          -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e',
                                      '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d',
                                      '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d',
                                      '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q',
                                      '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
                                      opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so',
                                      [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
                                      opts)
          vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport =
          true
        capabilities.textDocument.completion.completionItem.preselectSupport =
          true
        capabilities.textDocument.completion.completionItem.insertReplaceSupport =
          true
        capabilities.textDocument.completion.completionItem.labelDetailsSupport =
          true
        capabilities.textDocument.completion.completionItem.deprecatedSupport =
          true
        capabilities.textDocument.completion.completionItem
          .commitCharactersSupport = true
        capabilities.textDocument.completion.completionItem.tagSupport = {
          valueSet = {1},
        }
        capabilities.textDocument.completion.completionItem.resolveSupport = {
          properties = {'documentation', 'detail', 'additionalTextEdits'},
        }

        local lspinstall = require 'lspinstall'
        lspinstall.setup()
        local servers = lspinstall.installed_servers()
        for _, lsp in ipairs(servers) do
          nvim_lsp[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities,
          }
        end
        require'lspsaga'.init_lsp_saga()
      end,
    }
    use 'glepnir/lspsaga.nvim'
    use {
      'hrsh7th/nvim-cmp',
      config = function()
        vim.o.completeopt = 'menuone,noselect'
        local luasnip = require 'luasnip'
        local cmp = require 'cmp'
        cmp.setup {
          map_cr = true, --  map <CR> on insert mode
          map_complete = true, -- it will auto insert `(` after select function or method item
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
          mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            },
            ['<Tab>'] = function(fallback)
              if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true,
                                                               true, true), 'n')
              elseif luasnip.expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                  '<Plug>luasnip-expand-or-jump', true, true,
                                  true), '')
              else
                fallback()
              end
            end,
            ['<S-Tab>'] = function(fallback)
              if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true,
                                                               true, true), 'n')
              elseif luasnip.jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                  '<Plug>luasnip-jump-prev', true, true, true),
                                '')
              else
                fallback()
              end
            end,
          },
          sources = {
            {name = 'cmp-tabnine'}, {name = 'nvim_lsp'}, {name = 'luasnip'},
            {name = 'buffer'},
          },
        }
      end,
    }
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use {
      'tzachar/cmp-tabnine',
      run = './install.sh',
      requires = 'hrsh7th/nvim-cmp',
    }
    use {
      'windwp/nvim-autopairs',
      config = {
        require('nvim-autopairs').setup {
          disable_filetype = {'TelescopePrompt', 'vim'},
          check_ts = true,
        },
      },
    }
    use {
      'folke/which-key.nvim',
      config = function() require('which-key').setup {} end,
    }
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {'kyazdani42/nvim-web-devicons'},
    }
    use 'dstein64/vim-startuptime'
  end,
  config = {
    git = {default_url_format = 'https://hub.fastgit.org/%s.git'},
    profile = {enable = false},
  },
}

local setup_key = function()
  vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<cr>',
                          {noremap = true, silent = true})

  vim.o.hlsearch = true
  vim.wo.number = true
  vim.wo.relativenumber = true
  vim.o.expandtab = true
  vim.o.shell = '/usr/bin/fish'
  vim.o.grepprg = 'rg --hidden --vimgrep --smart-case --'
  vim.o.list = true
  vim.o.listchars = 'tab:»·,nbsp:+,trail:·,extends:→,precedes:←'
  vim.o.autoread = true
  vim.o.autowrite = true
  vim.o.smartcase = true
  vim.o.lazyredraw = true
  vim.o.hidden = true
  vim.o.splitbelow = true
  vim.o.splitright = true
  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
  vim.o.smartindent = true

  vim.o.mouse = 'a'
  vim.o.breakindent = true
  vim.opt.undofile = true
  vim.o.ignorecase = true
  vim.o.updatetime = 250
  vim.wo.signcolumn = 'yes'
  vim.o.termguicolors = true

  vim.g.onedark_terminal_italics = 2
  vim.api.nvim_set_keymap('', '<Space>', '<Nop>',
                          {noremap = true, silent = true})
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Remap for dealing with word wrap
  vim.api.nvim_set_keymap('n', 'k', 'v:count == 0 ? \'gk\' : \'k\'',
                          {noremap = true, expr = true, silent = true})
  vim.api.nvim_set_keymap('n', 'j', 'v:count == 0 ? \'gj\' : \'j\'',
                          {noremap = true, expr = true, silent = true})

  -- Map blankline
  vim.g.indent_blankline_char = '┊'
  vim.g.indent_blankline_filetype_exclude = {'help', 'packer'}
  vim.g.indent_blankline_buftype_exclude = {'terminal', 'nofile'}
  vim.g.indent_blankline_char_highlight = 'LineNr'
  vim.g.indent_blankline_show_trailing_blankline_indent = false

  -- Highlight on yank
  vim.api.nvim_exec([[
    augroup YankHighlight
      autocmd!
      autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    augroup end
  ]], false)
  -- Y yank until the end of line  (note: this is now a default on master)
  vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true})
end
setup_key()
