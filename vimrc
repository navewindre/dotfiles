set autoindent expandtab tabstop=2 shiftwidth=2 number
set mouse=a
set noshowmode
set termguicolors
set title
set smartcase
filetype plugin on

let g:lightline = {
      \ 'colorscheme': 'landscape',
      \ }

call plug#begin()

Plug 'chriskempson/base16-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'itchyny/lightline.vim'
Plug 'shawnohare/hadalized.nvim'
Plug 'preservim/nerdtree'
Plug 'bignimbus/pop-punk.vim'
Plug 'romgrk/barbar.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'TabbyML/vim-tabby'
Plug 'Yggdroot/indentLine'
Plug 'johnfrankmorgan/whitespace.nvim'

let g:tabby_keybinding_accept = '<Tab>'

call plug#end()

function! SW()
  if winnr('$') > 1
    wincmd w
  else
    BufferNext
  endif
endfunction

function! Q()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    NERDTreeClose
  else
    if winnr('$') > 1 
      q 
    else
      let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
      if len(buffers) > 1 
        BufferClose
      else
        call feedkeys(':q') 
      endif
    endif
  endif
endfunction

nnoremap <C-e> :NERDTree<CR>
inoremap <C-e> <Esc>:NERDTree<CR>
vnoremap <C-e> <Esc>:NERDTree<CR>

nnoremap <Esc> :call Q()<CR>
nnoremap <Tab> :call SW()<CR>
nnoremap <C-Tab> :BufferNext<CR>

nnoremap <F1> :BufferPick<CR>
inoremap <F1> <ESC>:BufferPick<CR>
vnoremap <F1> <ESC>:BufferPick<CR>

nnoremap <F2> :Telescope live_grep<CR>
nnoremap <C-f> :Telescope current_buffer_fuzzy_find<CR>

nnoremap <F4> :lua ToggleDiagnostics()<CR>

vnoremap <Tab> >gv
nnoremap <S-Tab> <gv
inoremap <S-Tab> <C-d>
vnoremap <S-Tab> <gv

colorscheme base16-synth-midnight-dark
highlight LineNr guibg=#000000
highlight Identifier ctermfg=1 guifg=#06ea61
highlight String ctermfg=1 guifg=#ea5971
highlight Character ctermfg=1 guifg=#dddddd
highlight CmpItemKindDefault guifg=#7cede9 guibg=#222222
highlight Variable guifg=#00FF00 ctermfg=Green
highlight javaScriptIdentifier guifg=#ff40ff ctermfg=Blue
highlight Delimiter ctermfg=14 guifg=#f77440
let g:vim_json_conceal=0
let g:markdown_syntax_conceal=0
let g:indentLine_color_term=239
let g:indentLine_color_gui='#141414'

let NERDTreeQuitOnOpen=1

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

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


  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities
  }

  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities
  }
  
  require('lspconfig')['intelephense'].setup {
    capabilities = capabilities
  }

  require('lspconfig')['jdtls'].setup {
    capabilities = capabilities
  }

  require('barbar').setup {
    animation = false,
    icons = {
      filetype = {
        enabled = false
      }
    },
    minimum_padding = 1,
    maximum_padding = 1,
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
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "c", "cpp", "javascript", "lua", "vim", "vimdoc", "java", "query", "markdown", "markdown_inline" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
      enable = true,

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
      disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
              return true
          end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
    

EOF
