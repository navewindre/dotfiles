let g:mapleader = '\'
let g:vsnip_snippet_dir = '~/.config/nvim/snippets'
" fuck zig niggers
let g:polyglot_disabled = ['autoindent']

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
  Plug('mengelbrecht/lightline-bufferline')
  Plug('preservim/nerdtree')
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
  Plug('puremourning/vimspector')

  Plug('yetone/avante.nvim', { ['branch'] = 'main', ['do'] = 'make' } )
  vim.call('plug#end');

  -- Set up nvim-cmp.
  local cmp = require('cmp');

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
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {},
    mapping = cmp.mapping.preset.insert({
      -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        -- { name = 'man' }
      }, {
        { name = 'buffer' }
    })
  })

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
      { name = 'path' },
      { name = 'man' },
    }, { { name = 'cmdline' } } )
  })

  cmp.register_source('man', {
    complete = function(self, request, callback)
      local input = string.match(request.context.cursor_before_line, "Man%s+(.*)$")
      if not input then
        return
      end
      local result = {}
      local handle = io.popen("man -k . | cut -d ' ' -f 1,2 | sed 's/ (/(/'")
      if handle then
        for line in handle:lines() do
          if vim.startswith(line:lower(), input:lower()) then
            table.insert(result, {
              label = line,
              kind = cmp.lsp.CompletionItemKind.File,
            })
          end
        end
        handle:close()
      end
      callback({ items = result, isIncomplete = false })
    end
  })

  require("wpm").setup({
    sample_count = 8,
    sample_interval = 750,
    percentile = 1
  })

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.offsetEncoding = "utf-16"
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities
  }

  require('lspconfig')['ts_ls'].setup {
    capabilities = capabilities,
    settings = {
      eslint = {
        rules = {
          eqeqeq = "off"
        }
      }
    }
  }

  require('lspconfig')['zls'].setup {
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
        api_key_name = '',
        endpoint = "127.0.0.1:11434/v1",
        -- model = 'qwen2.5:7b-instruct-q4_K_M',
        model = 'qwen2.5-coder:7b-instruct-q5_K_M',
        -- model = 'yi-coder:9b-chat-q4_0',
        -- model = "codestral",
        -- model = "codestral:22b-v0.1-q6_K",
        -- model = "mistral-nemo:12b-instruct-2407-q8_0",
        -- model = "mistral-nemo:12b-instruct-2407-q4_K_S",
        -- model = "deepseek-coder-v2:16b-lite-instruct-q5_K_M",
        -- model = "llama3.1:8b-instruct-q5_K_M",
        -- model = "starcoder2:15b-instruct-v0.1-q3_K_S",
        -- model = "gemma2:27b-instruct-q5_K_M",
        -- model = "mixtral:8x7b-instruct-v0.1-q3_K_L",
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
             max_tokens = 20000,
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

set autoindent expandtab tabstop=2 shiftwidth=2 number
set mouse=a
set mousemodel=popup
set noshowmode
set termguicolors
set title
set foldnestmax=1
set foldlevel=10000
set foldmethod=indent
set smartcase
set showtabline=2
set nocompatible
set guicursor+=i:-blinkwait175-blinkoff150-blinkon175
set signcolumn=number

filetype plugin on
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_enable_debug_logging = 0
let g:lightline = {
    \ 'colorscheme': 'landscape',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fmtcustom', 'tabbycustom', 'enccustom', 'ftcustom', 'wpm' ] ]
    \ },
    \ 'tabline': {
    \   'left': [ ['buffers'] ],
    \   'right': [ ['close'], ['tabscustom'] ]
    \ },
    \ 'component_expand': {
    \   'buffers': 'lightline#bufferline#buffers'
    \ },
    \ 'component_type': {
    \   'buffers': 'tabsel'
    \ },
    \ 'component_function': {
    \   'tabline_tabs': 'TablineTabs',
    \   'wpm': 'WPM',
    \   'ftcustom': 'CustomFT',
    \   'enccustom': 'CustomEncode',
    \   'fmtcustom': 'CustomFileFormat',
    \   'tabscustom': 'CustomTabs',
    \   'tabbycustom': 'TabbyStatus'
    \ }
\ }

" Relative Line Numbers in Sign Column (0-9 only, 0 for current line)
" Place this in ~/.vim/plugin/relative_sign_numbers.vim

if exists('g:loaded_relative_sign_numbers')
    finish
endif
let g:loaded_relative_sign_numbers = 1

" Save signs state
let s:signs = {}

function! s:UpdateSignColumn()
    execute 'sign unplace * group=RelativeLineNumbers'
    let disallowed_langs = []
    if index(disallowed_langs, &filetype) >= 0
      return
    endif
    let l:cur_line = line('.')
    let l:last_line = line('$')

    if !has_key(s:signs, 0)
        execute 'sign define RelNum0 text=0 texthl=LineNr'
        let s:signs[0] = 1
    endif

    let l:start = 1
    if l:cur_line > 10
        let l:start = l:cur_line - 10
    endif

    let l:end = l:cur_line + 10
    if l:end > l:last_line
        let l:end = l:last_line
    endif

    for l:lnum in range(l:start, l:end)
        if l:lnum != l:cur_line 
            let l:distance = abs(l:cur_line - l:lnum)
            if l:distance > 0 && l:distance <= 9
                if !has_key(s:signs, l:distance)
                    execute 'sign define RelNum' . l:distance . ' text=' . l:distance . ' texthl=LineNr'
                    let s:signs[l:distance] = 1
                endif
                execute 'sign place ' . l:lnum . ' line=' . l:lnum . 
                      \' name=RelNum' . l:distance . 
                      \' group=RelativeLineNumbers buffer=' . bufnr('')
            endif
        endif
    endfor
endfunction

augroup RelativeSignNumbers
    autocmd!
    autocmd BufEnter,WinEnter,CursorMoved,CursorMovedI * call s:UpdateSignColumn()
augroup END

command! EnableRelativeSignNumbers call s:UpdateSignColumn()
command! DisableRelativeSignNumbers execute 'sign unplace * group=RelativeLineNumbers'
let g:lightline.component_raw = {'buffers': 1}
let g:lightline#bufferline#clickable = 1
let g:lightline#bufferline#show_number = 2

let g:zig_fmt_autosave=0
let g:ale_javascript_eslint_options = '--config /home/aurelia/.eslintrc.json'

function! CustomTabs()
  if tabpagenr('$') == 1
    return ''
  endif

  let current_tab = tabpagenr()
  let tab_list = []

  for i in range(1, tabpagenr('$'))
    if i == current_tab
      call add(tab_list, '[' . i . ']')
    else
      call add(tab_list, i)
    endif
  endfor

  return join(tab_list, ' | ')
endfunction

function CustomFileFormat()
  if &filetype != 'Avante' && &filetype != 'AvanteInput'
    return &fileformat
  endif
  return ''
endfunction

function CustomEncode()
  if &filetype != 'Avante' && &filetype != 'AvanteInput'
    return &fileencoding
  endif
  return ''
endfunction

function CustomFT()
  if &filetype != 'Avante' && &filetype != 'AvanteInput'
    return &filetype
  endif
  return ''
endfunction

function WPM()
  if &filetype != 'Avante' && &filetype != 'AvanteInput'
    return (luaeval("require('wpm').historic_graph()") . ' ' . luaeval("require('wpm').wpm()")) . 'wpm'
  endif
  return ''
endfunction

function TabbyStatus()
  if !exists("g:tabby_inline_completion_trigger")
    let g:tabby_inline_completion_trigger = 'auto'
  endif
  if g:tabby_inline_completion_trigger == 'auto'
    return ''
  endif
  if g:tabby_inline_completion_trigger == 'manual'
    return 'ai: manual'
  endif
  return 'ai: off'
endfunction

function ToggleTabby()
  if !exists("g:tabby_inline_completion_trigger")
    let g:tabby_inline_completion_trigger = 'auto'
  endif
  if g:tabby_inline_completion_trigger == 'auto'
    let g:tabby_inline_completion_trigger = 'manual'
  elseif g:tabby_inline_completion_trigger == 'off'
    let g:tabby_inline_completion_trigger = 'auto'
  else
    let g:tabby_inline_completion_trigger = 'off'
  endif
endfunction

function! TablineTabs()
  return lightline#tabline()
endfunction

let g:tabby_keybinding_accept = '<Tab>'
autocmd Filetype json,jsonc let g:indentLine_setConceal = 0
autocmd Filetype javascriptreact,typescriptreact TSEnable indent
autocmd Filetype * call tabby#inline_completion#keybindings#Setup()

function! SWB()
  execute('call lightline#bufferline#go_previous()')
endfunction

function! SW()
  execute('call lightline#bufferline#go_next()')
endfunction

function! Q()
  let float_visible = 0
  let winid = 0
  for win in range(1, winnr('$'))
    let config = nvim_win_get_config(win_getid(win))
    if has_key(config, 'relative') && config.relative != ''
      let float_visible = 1
      let winid = win_getid(win)
      break
    endif
  endfor
  if float_visible
    call nvim_win_close(winid, v:true)
    return
  endif


  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    NERDTreeClose
  else
    call feedkeys(":nohlsearch\<CR>")
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
      call feedkeys(':bd')
    else
      call feedkeys(':q')
    endif
  endif
endfunction

function! GoToTab(tab_number)
  execute 'call lightline#bufferline#go(' . a:tab_number . ')'
endfunction

function! InputTabNumber()
  let l:tab_number = nr2char(getchar())
  if l:tab_number =~ '\d'
    call GoToTab(str2nr(l:tab_number))
  endif
endfunction

function! TurnOffDiag()
  let disallowed_langs = ['c', 'cpp', 'javascript', 'typescript', 'typescriptreact', 'javascriptreact']
  if index(disallowed_langs, &filetype) >= 0
    ALEDisable
  endif
endfunction

function! AddSpacesToParentheses() range
    let saved_search = @/
    let pattern = '\v(\w+\()(\S.{-})(\))'
    execute a:firstline . ',' . a:lastline . 's/' . pattern . '/\1 \2 \3/ge'
    execute a:firstline . ',' . a:lastline . 's/( )/( )/ge'
    execute a:firstline . ',' . a:lastline . 's/(\s\+/( /ge'
    execute a:firstline . ',' . a:lastline . 's/\s\+)/ )/ge'
    let @/ = saved_search
endfunction

function! OpenLsp()
  let float_visible = 0
  for win in range(1, winnr('$'))
    let config = nvim_win_get_config(win_getid(win))
    if has_key(config, 'relative') && config.relative != ''
      let float_visible = 1
      break
    endif
  endfor

  if float_visible
    call Q()
  endif

  call feedkeys('K')
endfunction

function! OpenFloat()
  let float_visible = 0
  let g:float_winid = 0
  for win in range(1, winnr('$'))
    let config = nvim_win_get_config(win_getid(win))
    if has_key(config, 'relative') && config.relative != ''
      let float_visible = 1
      let g:float_winid = win_getid(win)
      break
    endif
  endfor


lua <<EOF
local win = vim.diagnostic.open_float(nil, {focus=false})
if win == nil then
  vim.fn.feedkeys('K')
end
EOF

endfunction

function! GFLine()
  let file_line = expand('<cfile>')
  let parts = split(file_line, '#L')
  if len(parts) > 1
      execute 'e +' . parts[1] . ' ' . parts[0] | sleep 200m
      execute('call lightline#bufferline#go_next()')
      set number
  else
      normal! gf
  endif
endfunction

nnoremap <leader>c "+yy
vnoremap <leader>c "+y
nnoremap <leader>p "+gP
vnoremap <leader>p "+P

nnoremap gf :call GFLine()<CR>
vnoremap <leader>ap :call AddSpacesToParentheses()<CR>

autocmd BufReadPost * call TurnOffDiag()

nnoremap <CR> :noh<CR><CR>

nnoremap <C-e> :NERDTree<CR>
inoremap <C-e> <Esc>:NERDTree<CR>
vnoremap <C-e> <Esc>:NERDTree<CR>

nnoremap <Esc> :call Q()<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <S-Tab> :call SWB()<CR>
nnoremap <Tab> :call SW()<CR>

nnoremap w <S-e>
nnoremap <S-w> <S-b>
nnoremap <S-e> b

vnoremap w <S-e>
vnoremap <S-w> <S-b>
vnoremap <S-e> b

noremap <leader><Tab> :tabn<CR>
noremap <leader><S-Tab> :tabp<CR>

nnoremap <F1> :call InputTabNumber()<CR>
inoremap <F1> <ESC>:call InputTabNumber()<CR>
vnoremap <F1> <ESC>:call InputTabNumber()<CR>

nnoremap <F2> :Telescope live_grep<CR>
nnoremap <C-f> :Telescope current_buffer_fuzzy_find<CR>
nnoremap <C-x> :Telescope marks<CR>

nnoremap <F4> :lua ToggleDiagnostics()<CR>

nnoremap <F7> :VimspectorReset<CR>
nnoremap <leader>b :VimspectorBreakpoints<CR>
nnoremap <leader>d :VimspectorDisassemble<CR>
nnoremap <leader>[ <Plug>VimspectorUpFrame
nnoremap <leader>] <Plug>VimspectorDownFrame
nnoremap <silent> <C-Space> <Plug>VimspectorBalloonEval

inoremap <S-Tab> <C-d>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nnoremap <leader><left> <Plug>lightline#bufferline#move_previous()
nnoremap <leader><right> <Plug>lightline#bufferline#move_next()

nnoremap t :call OpenFloat()<CR>
nnoremap T :call OpenLsp()<CR>

nnoremap gd <C-]>
nnoremap <leader>gd :Telescope diagnostics<CR>

nnoremap <leader>gr :Telescope lsp_references<CR>

nnoremap [[ ?{<CR>:nohl<CR>
nnoremap ]] /}<CR>:nohl<CR>
nnoremap ][ /{<CR>:nohl<CR>
nnoremap [] ?}<CR>:nohl<CR>

vnoremap [[ ?{<CR>:<C-u>nohl<CR>gv
vnoremap ]] /}<CR>:<C-u>nohl<CR>gv
vnoremap ][ /{<CR>:<C-u>nohl<CR>gv
vnoremap [] ?}<CR>:<C-u>nohl<CR>gv

nnoremap <C-l> <C-i>
nnoremap <leader>ta :call ToggleTabby()<CR>

colorscheme base16-synth-midnight-dark
hi LineNr guibg=#000000
hi String ctermfg=1 guifg=#ea5971
hi Character ctermfg=1 guifg=#dddddd
hi CmpItemKindDefault guifg=#7cede9 guibg=#101010
hi javaScriptIdentifier guifg=#ff40ff ctermfg=Magenta
hi Delimiter ctermfg=14 guifg=#cccccc
hi AvanteConflictCurrent guibg=#101010
hi AvanteConflictIncoming guibg=#102010
hi PmenuSel guibg=#ffffff guifg=#202020
hi Variable guifg=#40FF40 ctermfg=Green
hi @variable guifg=#40FF40 ctermfg=Green
hi Identifier guifg=#27ea91
hi def link @lsp.typemod.variable.defaultLibrary.javascriptreact Special
hi def link @lsp.typemod.variable.defaultLibrary.typescriptreact Special
hi def link @lsp.typemod.variable.defaultLibrary.javascript Special
hi def link @lsp.typemod.variable.defaultLibrary.typescript Special
hi def link @punctuation.special.javascript Delimiter
hi def link @lsp.type.keywordLiteral.zig Special
hi def link @lsp.type.string.zig NONE
hi @type.builtin.cpp guifg=#ea5ce2
hi SpecialChar ctermfg=9 guifg=#e4600e
hi SignColumn guibg=#000000

let g:vim_json_conceal=0
let g:markdown_syntax_conceal=0
let g:indentLine_color_term=239
let g:indentLine_color_gui='#141414'
let NERDTreeQuitOnOpen=1

autocmd BufNewFile,BufRead *.zig set shiftwidth=2
autocmd BufNewFile,BufRead *.modelfile set ft=gotmpl

aunmenu PopUp.Inspect
aunmenu PopUp.-1-
aunmenu PopUp.How-to\ disable\ mouse
anoremenu PopUp.Inspect <Cmd>Inspect<CR>

augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='TelescopeSelection', timeout=200 }
augroup END
