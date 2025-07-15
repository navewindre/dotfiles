let g:mapleader = '\'
let g:vsnip_snippet_dir = '~/.config/nvim/snippets'
" fuck zig niggers
let g:polyglot_disabled = ['autoindent']
call plug#begin()
Plug 'chriskempson/base16-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'stevearc/vim-arduino'
Plug 'hrsh7th/nvim-cmp'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'preservim/nerdtree'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'navewindre/vim-tabby'
Plug 'Yggdroot/indentLine'
Plug 'johnfrankmorgan/whitespace.nvim'
Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'
Plug 'nvim-lua/plenary.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'HakonHarnes/img-clip.nvim'
Plug 'jcdickinson/wpm.nvim'
Plug 'puremourning/vimspector'

call plug#end()


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

if exists('g:loaded_relative_sign_numbers')
    finish
endif
let g:loaded_relative_sign_numbers = 1

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
      sleep 5m
      set number
  else
      normal! gf
  endif
endfunction

nnoremap <leader>c "+yy
vnoremap <leader>c "+y
nnoremap <leader>p "+gP
vnoremap <leader>p "+P

nnoremap <leader>f :lua vim.lsp.buf.code_action()<CR>
vnoremap <leader>f :lua vim.lsp.buf.code_action()<CR>

nnoremap <leader>rs :lua vim.lsp.buf.rename()<CR>
vnoremap <leader>rs :lua vim.lsp.buf.rename()<CR>

nnoremap gf :call GFLine()<CR>
vnoremap <leader>ap :call AddSpacesToParentheses()<CR>

autocmd BufReadPost,BufNew * call TurnOffDiag()

nnoremap <CR> :noh<CR><CR>

nnoremap <C-e> :NERDTreeMirror<CR>:NERDTreeFocus<CR>
inoremap <C-e> <Esc>:NERDTreeMirror<CR>:NERDTreeFocus<CR>
vnoremap <C-e> <Esc>:NERDTreeMirror<CR>:NERDTreeFocus<CR>

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
nnoremap <F12> :VimspectorToggle
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

nnoremap <C-j> <C-i>
nnoremap <leader>ta :call ToggleTabby()<CR>

xnoremap ip :<C-u>silent! normal! T,vt,<CR>
onoremap ip :<C-u>silent! normal! T,vt,<CR>

nnoremap <S-Up> <C-u>
nnoremap <S-Down> <C-d>
vnoremap <S-Up> <C-u>
vnoremap <S-Down> <C-d>

inoremap <S-Up> <Esc><C-u>i
inoremap <S-Down> <Esc><C-d>i

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
hi Identifier guifg=#27ea91
hi def link markdownId markdownIdDeclaration
hi def link markdownH1 RenderMarkdownH1
hi def link markdownH2 RenderMarkdownH2
hi def link markdownHeadingRule RenderMarkdownTableHead
hi def link markdownRule markdownH1
hi def link markdownIdDeclaration markdownCode
hi def link markdownLineStart markdownCode

hi SpecialChar ctermfg=9 guifg=#e4600e
hi SignColumn guibg=#000000

let g:vim_json_conceal=0
let g:markdown_syntax_conceal=0
let g:indentLine_color_term=239
let g:indentLine_color_gui='#141414'
let NERDTreeQuitOnOpen=1
let NERDTreeWinSize=36
let NERDTreeMinimalUI=1

autocmd BufNewFile,BufRead *.zig set shiftwidth=2
autocmd BufNewFile,BufRead *.modelfile set ft=gotmpl
autocmd BufNewFile,BufRead *.vsh set ft=glsl

aunmenu PopUp.Inspect
aunmenu PopUp.-1-
aunmenu PopUp.How-to\ disable\ mouse
anoremenu PopUp.Inspect <Cmd>Inspect<CR>

augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='TelescopeSelection', timeout=200 }
augroup END
