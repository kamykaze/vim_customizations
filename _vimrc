"----------- INITIALIZATION: This needs to be at the top of .vimrc ------------------
" pathogen allows you to manage your plugins and runtime files in their own private directories
" http://www.vim.org/scripts/script.php?script_id=2332
"
" Adding a module is as simple as unzipping the module inside .vim/bundle/[module_name]
" or if you use git
"
" git submodule add http://github.com/user/module_name.git .vim/bundle/[module_name]

filetype on
filetype off

" load barebones vim settings (the one I curl onto a server I don't have my own user profile)
so ~/.vimrc_bare

"-- History --

" Number of undos to save
set history=500

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,n~/.viminfo

" restores cursor position
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

"##### CORE  #########################################
if has('vim_starting')
   set runtimepath+=~/.vim/bundle/neobundle/
endif

" Setup NeoBundle for plugin management
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
  \ 'build': {
    \ 'mac': 'make -f make_mac.mak',
    \ 'unix': 'make -f make_unix.mak',
    \ 'cygwin': 'make -f make_cygwin.mak',
    \ 'windows': '"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\nmake.exe" make_msvc32.mak',
  \ },
\ }

call neobundle#end()
filetype plugin indent on


"##### ERRORS ########################################
" make sure we use audible bell since we're using powerline
set novisualbell


"  "##### FILE / BUFFER MANAGEMENT ###############################
"  
"  " Centralize backups, swapfiles and undo history
"  set backupdir=~/.vim/backups
"  set directory=~/.vim/swaps
"  if exists("&undodir")
"      set undodir=~/.vim/undo
"  endif
"  
"  " Change swap backup frequency (reduce from default of 4s and 200 chars)
"  set updatetime=10000
"  set updatecount=500
"  
"  " configuration for Quickbuf plugin
"  if mapcheck("<leader>b", "N") != ""
"    nunmap <leader>b
"    let g:qb_hotkey = "<leader>b"
"  endif
"  
"----- SESSION PLUGIN OPTIONS ---------------------
NeoBundle 'xolox/vim-session'
" change default session directory to avoid showing up on dotfiles repo
let g:session_directory='~/.vim_sessions'
let g:session_autosave = 'yes'

"##### EDITING #######################################

" convenient copy & paste to clipboard (Mac only)
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    vmap <C-x> :!reattach-to-user-namespace pbcopy<CR>
    vmap <C-c> :w !reattach-to-user-namespace pbcopy<CR><CR>
    imap <C-v><C-v> <Esc>:r !reattach-to-user-namespace pbpaste<CR>
  endif
endif

" reselect the text that was just pasted so I can perform commands (like indentation) on it (Steve Losh)
nnoremap <leader>v V`]

NeoBundle 'tpope/vim-repeat'            "allows certain plugins to repeat the last command using .
NeoBundle 'tpope/vim-surround'          "adds mappings for adding/changing/deleting surrounding characters like {}, [], '', and even html tags



"  "----- AUTO COMPLETION ----------------------------
"  " map <tab> to either insert a tab, or use <C-N> depending on where the cursor is
"  "function! CleverTab()
"  "    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$' 
"  "        return "\<Tab>"
"  "    elseif strpart( getline('.'), col('.')-2, 1 ) =~ '\s$'
"  "        return "\<Tab>"
"  "    else
"  "        return "\<C-N>"
"  "    endif
"  "endfunction
"  "inoremap <Tab> <C-R>=CleverTab()<CR>
"  
"  " Note: to use these omnicomplete functions, use Ctrl-k, Ctrl-o, then Ctrl-o again to loop through the options
"  autocmd BufNewFile,BufRead *.less set filetype=less.css
"  autocmd BufNewFile,BufRead *.scss set filetype=scss.css
"  autocmd BufNewFile,BufRead *.html set filetype=htmldjango.html
"  autocmd BufNewFile,BufRead *.json set filetype=javascript
"  autocmd BufNewFile,BufRead *.py set filetype=python.django
"  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"  autocmd FileType actionscript set omnifunc=actionscriptcomplete#CompleteAS
"  autocmd BufNewFile,BufRead *.as set filetype=actionscript
"  autocmd FileType javascript,html,htmldjango,scss,css set tabstop=2
"  autocmd FileType javascript,html,htmldjango,scss,css set softtabstop=2
"  autocmd FileType javascript,html,htmldjango,scss,css set shiftwidth=2
"  
"  "autocmd FileType css,scss,javascript imap <buffer> { {<CR>}<Esc>ko<tab>
"  autocmd FileType css,scss,javascript inoremap <buffer> { {}<Left>
"  autocmd FileType css,scss,javascript inoremap <buffer> {} {}
"  autocmd FileType css,scss,javascript inoremap <buffer> {<CR> {<CR>}<Esc>O<Tab>
"  autocmd FileType htmldjango inoremap <buffer> {{ {{<space><space>}}<Left><Left><Left>
"  autocmd FileType htmldjango inoremap <buffer> {% {%<space><space>%}<Left><Left><Left>
"  autocmd FileType css,scss nnoremap <buffer> <leader>} $%bt<space>v^yf{%A<space>/*<space><esc>pA<space>*/<esc>
"  
"  autocmd FileType css,scss,javascript setlocal foldmethod=marker foldmarker={,}
"  
"  
"----- FILE HANDLING -------------------------------
NeoBundle 'scrooloose/nerdtree'
let NERDTreeIgnore=['.pyc$[[file]]']
nnoremap <leader><tab> :NERDTreeToggle<CR>
" searches files within current working directory (use <CR> to open in current window, or <C-J> to open in a new window)
nnoremap <silent> ss :FufCoverageFile<CR> 
" searches files that are currently open (use <CR> to load the file in the current window, or <C-J> to jump to the window where the file is open)
nnoremap <silent> sb :FufBuffer<CR>
" Disabled modes we are not using (no reason to use extra memory and slow things down)
let g:fuf_modesDisable = [ 'dir', 'mrufile', 'mrucmd', 'bookmarkfile', 'bookmarkdir', 'tag', 'buffertag', 'taggedfile', 'jumplist', 'changelist', 'line', 'help', 'given', 'givendir', 'givencmd', 'callback', 'callbackitem', ]
" Set <CR> to open in a split window (instead of current window)
let g:fuf_keyOpenSplit = '<CR>'

"##### NAVIGATION ##################################

NeoBundle 'Lokaltog/vim-easymotion'
" remap easymotion leader key to avoid conflict with my custom binding <Leader>,
let g:EasyMotion_leader_key = '<space>'

"--------- WINDOWS --------------------------------


"  " #### TODO: Folds #######
"  " fold by indentation
"  "set foldmethod=indent
"  " set default fold level, 0=all minimized
"  set foldlevel=2
"  " do not show a column to indicate a fold
"  set foldcolumn=2
"  " prevent deep folding
"  set foldnestmax=3
"  
"  " quick fold current block (brackets)
"  nnoremap <leader>f $va{zf
"  
"  " custom fold text from http://dhruvasagar.com/2013/03/28/vim-better-foldtext
"  function! NeatFoldText() "{{{2
"    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
"    let lines_count = v:foldend - v:foldstart + 1
"    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
"    let foldchar = matchstr(&fillchars, 'fold:\zs.')
"    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
"    let foldtextend = lines_count_text . repeat(foldchar, 8)
"    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
"    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
"  endfunction
"  set foldtext=NeatFoldText()
"  " }}}2

"###### UI ########################################

" Do not Show the current mode (Normal/Visual/etc.) (already using powerline)
set noshowmode

" If 256 colors are supported
set t_Co=256
let g:hybrid_use_Xresources = 1
colorscheme hybrid

" Enable mouse support
set mouse:a

" when closing a bracket, briefly flash the corresponding open bracket
"set showmatch
"set matchtime=2

" color overflow region
"set colorcolumn=80,120
"let &colorcolumn=join(range(80,119),",")
"highlight ColorColumn ctermbg=233 guibg=#181818


"----- Rainbow Parentheses --------------------
" this makes it so parenthesis, brackets, etc. are colored differently depending on their nesting
NeoBundle 'kien/rainbow_parentheses.vim'
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadChevrons
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces
inoremap <leader>`` <esc>:RainbowParenthesesToggle<cr>a
nnoremap <leader>`` :RainbowParenthesesToggle<cr>
nnoremap <leader>`r :RainbowParenthesesLoadRound<cr>
nnoremap <leader>`s :RainbowParenthesesLoadSquare<cr>
nnoremap <leader>`b :RainbowParenthesesLoadBraces<cr>
nnoremap <leader>`c :RainbowParenthesesLoadBraces<cr>

let g:Powerline_colorscheme = 'solarized256'
let g:Powerline_symbols = 'fancy'


"##### KEYBOARD SHORTCUTS ##############################

"------ VIM ----------------------------------

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :tabe $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>


"------ HTML/CSS -----------------------------
" Sort css properties (courtesy of Steve Losh)
autocmd FileType css nnoremap <leader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

" Some people like merging all css definitions in one line. Use this to sPlit them into multiple lines
autocmd FileType css map <Leader>P :s/\([{;]\)<space>*\([^$]\)/\1\r<space><space><space><space>\2/g<CR>:noh<CR>

" Append a tag to the end of the current selector 
" (eg: using at on a line like "body #content p {" will take the cursor before the { and go into isnert mode)
autocmd FileType css map <Leader>ca f{i

" adding emmet (http://emmet.io) support
let g:user_emmet_leader_key = '<C-n>'
let g:user_emmet_expandabbr_key = '<s-tab><s-tab>'
let g:user_emmet_togglecomment_key = '<c-_>'
"let g:user_emmet_next_key = '<C-,>'
"let g:user_emmet_prev_key = '<C-;>'

let g:use_emmet_complete_tag = 1
let g:user_emmet_settings = {
\    'indentation' : '  ',
\    'html' : {
\        'snippets' : {
\          'dbl' : "{% block %}\n\t${child}|\n{% endblock %}",
\          'comment' : "{% comment %}\n\t${child}|\n{% endcomment %}",
\          'if' : "{% if | %}\n\t${child}|{% endif %}",
\          'else' : "{% else %}|",
\        },
\    },
\    'css' : {
\        'filters': 'html, fc',
\        'indentation' : '  ',
\        'snippets': {
\            'bgp': 'background-position:|;',
\            'c': 'color:|;',
\            'hp': 'height:|px;',
\            'hh': 'height:auto;',
\            'wp': 'width:|px;',
\            'ww': 'width:100%;|',
\        },
\    },
\}

"------ GIT -----------------------------
NeoBundle 'tpope/vim-fugitive'
map <leader>g :Gstatus<cr>

" adding multiple cursors support
" NeoBundle 'terryma/vim-multiple-cursors'
" let g:multi_cursor_use_default_mapping=0
" let g:multi_cursor_start_key='<C-p>'
"let g:multi_cursor_next_key='<C-n>'
"let g:multi_cursor_prev_key='<C-p>'
"let g:multi_cursor_skip_key='<C-x>'
"let g:multi_cursor_quit_key='<Esc>'
"  
NeoBundle 'airblade/vim-gitgutter'

"----- Snippets -------------------------
NeoBundle 'msanders/snipmate.vim'
NeoBundle 'kamykaze/snipmate_for_django'
" adding snippets directories
let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/,~/.vim/bundle/snipmate_for_django/snippets/'

"  " adding powerline
"  
"  if system('whoami') != "root\n"
"  "else
"      set runtimepath+=~/dotfiles/utilities/powerline/powerline/bindings/vim
"  endif
"  
"  if ! has('gui_running')
"      set ttimeoutlen=10
"      augroup FastEscape
"          autocmd!
"          au InsertEnter * set timeoutlen=300
"          au InsertLeave * set timeoutlen=750
"      augroup END
"  endif
"  
"  
"  noremap <silent> <leader>t  :TlistToggle<CR>
"  
"  
"##### TOOLS ########################################
"----- Tmux Integration ---------------------
NeoBundle 'jgdavey/tslime.vim'
vmap <Leader>m <Plug>SendSelectionToTmux
nmap <Leader>m <Plug>NormalModeSendToTmux
nmap <Leader>z <Plug>SetTmuxVars

"  "---- CtrlP mapping ---------------------------
"  let g:ctrlp_custom_ignore = {
"      \ 'dir':  '\v[\/]public\/media$'
"      \ }
"  let g:ctrlp_working_path_mode = 0
"  let g:ctrlp_follow_symlinks = 1
"  let g:ctrlp_prompt_mappings = {
"    \ 'PrtCurLeft()':         ['<left>', '<c-^>'],
"    \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>', '<c-h>']
"    \ }
"  nnoremap <leader><space>w :CtrlP $VIRTUAL_ENV/src/django-webcube<CR>
"  nnoremap <leader><space>d :CtrlP $VIRTUAL_ENV/lib/python2.7/site-packages/django<CR>
"  nnoremap <leader><space>. :CtrlP ..<cr>
"  nnoremap <leader><space>r :CtrlP ~/ref/
"  nnoremap <leader>/ :CtrlPLine %<cr>
"  
"  "---- Ack mapping ---------------------------
"  nnoremap <C-A> :Ack 
"  nnoremap <leader>a :Ack <cword><CR>
"  nnoremap <leader><CR>w :Ack  $VIRTUAL_ENV/src/django-webcube<home><right><right><right><right>
"  nnoremap <leader><CR>d :Ack  $VIRTUAL_ENV/lib/python2.7/site-packages/django<home><right><right><right><right>
"  nnoremap <leader><CR>r :Ack  ~/ref/<home><right><right><right><right>
"  nnoremap <leader><CR>a :Ack <cword> 
"  
"- #TODO replace CtrlP and Ack with Unite
"---- Unite mapping ---------------------------
NeoBundle 'Shougo/unite.vim'
NeoBundle 'h1mesuke/unite-outline'
let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>t :<C-u>Unite -buffer-name=files   -start-insert file_rec<cr>
nnoremap <leader>f :<C-u>Unite -buffer-name=files   -start-insert file<cr>
"nnoremap <leader>r :<C-u>Unite -buffer-name=mru     -start-insert file_mru<cr>
nnoremap <leader>o :<C-u>Unite -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>
nnoremap <leader>e :<C-u>Unite -buffer-name=buffer  buffer<cr>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction


" TODO: sort these
NeoBundle 'clones/vim-l9'
NeoBundle 'vim-scripts/django.vim'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'KohPoll/vim-less'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'xolox/vim-misc'
NeoBundle 'michaeljsmith/vim-indent-object'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/livestyle-vim'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'goldfeld/vim-seek'
NeoBundle 'Yggdroot/indentLine'
"NeoBundle 'vim-scripts/taglist.vim'
"NeoBundle 'mileszs/ag.vim'
"NeoBundle 'Lokaltog/powerline'

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
