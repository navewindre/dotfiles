set autoindent expandtab tabstop=2 shiftwidth=2 number
set mouse=a
set mousemodel=popup
set noshowmode
set termguicolors
set title
set smartcase
set showtabline=2
set nocompatible
filetype plugin on

lua <<EOF
  local Plug = vim.fn['plug#'];
  vim.call('plug#begin');

  Plug('chriskempson/base16-vim')
  Plug('neovim/nvim-lspconfig')
  Plug('hrsh7th/cmp-nvim-lsp')
  Plug('hrsh7th/cmp-buffer')
  Plug('hrsh7th/cmp-path')
  Plug('hrsh7th/cmp-cmdline')
  Plug('hrsh7th/nvim-cmp')
  Plug('itchyny/lightline.vim')
  Plug('shawnohare/hadalized.nvim')
  Plug('preservim/nerdtree')
  Plug('bignimbus/pop-punk.vim')
  Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
  Plug('nvim-lua/plenary.nvim')
  Plug('nvim-telescope/telescope.nvim', { tag = '0.1.8' })
  Plug('hrsh7th/cmp-vsnip')
  Plug('hrsh7th/vim-vsnip')
  Plug('TabbyML/vim-tabby')
  Plug('Yggdroot/indentLine')
  Plug('johnfrankmorgan/whitespace.nvim')
  Plug('sheerun/vim-polyglot')
  Plug('dense-analysis/ale')
  Plug('stevearc/dressing.nvim')
  Plug('nvim-lua/plenary.nvim')
  Plug('MunifTanjim/nui.nvim')
  Plug('MeanderingProgrammer/render-markdown.nvim')
  Plug('nvim-tree/nvim-web-devicons')
  Plug('HakonHarnes/img-clip.nvim')
  Plug('jcdickinson/wpm.nvim')

  Plug('yetone/avante.nvim', { ['branch'] = 'main', ['do'] = function() require('avante.api').build() end } )
  vim.call('plug#end');

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  vim.opt.updatetime = 500
  local diagnostics_enabled = true
  function ToggleDiagnostics()
    diagnostics_enabled = not diagnostics_enabled
    if diagnostics_enabled then
      vim.diagnostic.enable()
      print("diagnostics: on")
    else
      vim.diagnostic.disable()
      print("diagnostics: off")
    end
  end

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
   cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
   })

  require("wpm").setup({
    sample_count = 8,
    sample_interval = 750,
    percentile = 1
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities
  }

  require('lspconfig')['ts_ls'].setup {
    capabilities = capabilities
  }

  require('lspconfig')['intelephense'].setup {
    capabilities = capabilities
  }

  require('lspconfig')['jdtls'].setup {
    capabilities = capabilities
  }

  vim.diagnostic.config({
    signs = false
  })

  require('whitespace-nvim').setup({
    highlight = 'Underlined',
    ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard' },
    -- `ignore_terminal` configures whether to ignore terminal buffers
    ignore_terminal = true,
  })

  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "javascript", "html", "lua", "vim", "vimdoc", "java", "sql", "query", "markdown", "markdown_inline" },
    sync_install = false,
    textobjects = { enable = true },
    injections = {
      enable = true,
    },
    auto_install = true,
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
    highlight = {
      enable = true,
      disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
              return true
          end
      end,

      additional_vim_regex_highlighting = false,
    },
    query_linter = {
      enable = true,
      lint_events = {"BufWrite", "CursorHold"},
    },
  }

  require('img-clip').setup( {
    -- recommended settings
    default = {
      embed_image_as_base64 = false,
      prompt_for_file_name = false,
      drag_and_drop = {
        insert_mode = true,
      },
    },
  } )

  require('render-markdown').setup {
    file_types = { "markdown", "Avante" },
    enable = true,
  }
  require('avante_lib').load()
  require('avante').setup({
      mappings = {
      --- @class AvanteConflictMappings
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
    },
    provider = "ollama",
    vendors = {
     ---@type AvanteProvider
      ollama = {
        ["local"] = true,
        endpoint = "127.0.0.1:11434/v1",
        model = "llama3.1:8b-instruct-q5_K_M",
        parse_curl_args = function(opts, code_opts)
         return {
           url = opts.endpoint .. "/chat/completions",
           headers = {
             ["Accept"] = "application/json",
             ["Content-Type"] = "application/json",
           },
           body = {
             model = opts.model,
             messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
             max_tokens = 8192,
             stream = true,
           },
         }
        end,
        parse_response_data = function(data_stream, event_state, opts)
         require("avante.providers").openai.parse_response(data_stream, event_state, opts)
        end,
      },
    },

  })

EOF

let g:lightline = {
    \ 'colorscheme': 'landscape',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype', 'wpm' ] ]
    \ },
    \ 'tabline': {
    \   'left': [ ['tabs'] ],
    \   'right': [ ['buffers'] ]
    \ },
    \ 'component_function': {
    \   'tabline_tabs': 'TablineTabs',
    \   'wpm': 'WPM'
    \ }
\ }

function WPM()
  return (luaeval("require('wpm').historic_graph()") . ' ' . luaeval("require('wpm').wpm()")) . 'wpm'
endfunction

function! TablineTabs()
  return lightline#tabline()
endfunction


let g:tabby_keybinding_accept = '<Tab>'
autocmd Filetype json let g:indentLine_setConceal = 0

function! SW()
  if winnr('$') > 1
    wincmd w
  else
    tabnext
  endif
endfunction

function! Q()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    NERDTreeClose
  else
    if winnr('$') > 1 
      q
    else
      call feedkeys(':q')
    endif
  endif
endfunction

function! GoToTab(tab_number)
  execute 'tabn ' . a:tab_number
endfunction


function! InputTabNumber()
  let l:tab_number = nr2char(getchar())
  if l:tab_number =~ '\d'
    call GoToTab(str2nr(l:tab_number))
  endif
endfunction

nnoremap <C-e> :NERDTree<CR>
inoremap <C-e> <Esc>:NERDTree<CR>
vnoremap <C-e> <Esc>:NERDTree<CR>

nnoremap <Esc> :call Q()<CR>
nnoremap <Tab> :call SW()<CR>

nnoremap <F1> :call InputTabNumber()<CR>
inoremap <F1> <ESC>:call InputTabNumber()<CR>
vnoremap <F1> <ESC>:call InputTabNumber()<CR>

nnoremap <F2> :Telescope live_grep<CR>
nnoremap <C-f> :Telescope current_buffer_fuzzy_find<CR>

nnoremap <F4> :lua ToggleDiagnostics()<CR>

vnoremap <Tab> >gv
nnoremap <S-Tab> <gv
inoremap <S-Tab> <C-d>
vnoremap <S-Tab> <gv

let g:NERDTreeCustomOpenArgs = {
    \ 'file': {'where': 't', 'reuse': 'all'},
    \ 'dir': {}
\ }

colorscheme base16-synth-midnight-dark
hi LineNr guibg=#000000
hi String ctermfg=1 guifg=#ea5971
hi Character ctermfg=1 guifg=#dddddd
hi CmpItemKindDefault guifg=#7cede9 guibg=#101010
hi javaScriptIdentifier guifg=#ff40ff ctermfg=Blue
hi Delimiter ctermfg=14 guifg=#cccccc
hi AvanteConflictCurrent guibg=#101010
hi AvanteConflictIncoming guibg=#102010
hi PmenuSel guibg=#ffffff guifg=#202020
hi Variable guifg=#40FF40 ctermfg=Green
hi @variable guifg=#40FF40 ctermfg=Green
hi Identifier guifg=#27ea91
hi def link @lsp.typemod.variable.defaultLibrary.javascript Special
hi def link @punctuation.special.javascript Delimiter
hi SpecialChar ctermfg=9 guifg=#e4600e

let g:vim_json_conceal=0
let g:markdown_syntax_conceal=0
let g:indentLine_color_term=239
let g:indentLine_color_gui='#141414'
let NERDTreeQuitOnOpen=1

aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.Inspect
aunmenu PopUp.-1-
aunmenu PopUp.-2-
