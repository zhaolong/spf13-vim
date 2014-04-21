" Identify platform {
    silent function! OSX()
        return has('macunix')
    endfunction
    silent function! LINUX()
        return has('unix') && !has('macunix') && !has('win32unix')
    endfunction
    silent function! WINDOWS()
        return  (has('win16') || has('win32') || has('win64'))
    endfunction
" }

" Environment {
    " Basics {
        set noesckeys           " avoid delay of shift+o
        set nocompatible        " must be first line
        if has ("unix") && "Darwin" != system("echo -n \"$(uname)\"")
          " on Linux use + register for copy-paste
          set clipboard=unnamedplus
        else
          " one mac and windows, use * register for copy-paste
          set clipboard=unnamed
        endif
    " }

    " Setup Bundle Support {
    " The next three lines ensure that the ~/.vim/bundle/ system works
        filetype on
        filetype off
        set rtp+=~/.vim/bundle/vundle
        call vundle#rc()
    " }

" }

" Bundles {
    " Use bundles config {
        if filereadable(expand("~/.vimrc.bundles"))
            source ~/.vimrc.bundles
        endif
    " }
" }

" General {
    set background=dark         " Assume a dark background
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " syntax highlighting
    scriptencoding utf-8

    " always switch to the current file directory.
    " autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore         " allow for cursor beyond last character
    set history=1000                " Store a ton of history (default is 20)
    set hidden                      " allow buffer switching without saving
" }

" Vim UI {
    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors = 256
        let g:solarized_termtrans = 1
        let g:solarized_underline = 0
        let g:solarized_bold = 0
        let g:solarized_italic = 0
        color solarized

        " Custom settings
        exe "hi! VertSplit  ctermbg = 232"
        exe "hi! LineNr     ctermbg = 232"
        exe "hi! Pmenu      ctermbg = 245   ctermfg = 232"
        exe "hi! PmenuSel   ctermbg = 232   ctermfg = 250"
        exe "hi! ErrorMsg   cterm = bold    ctermfg = 124"
        exe "hi! Visual     cterm = bold,reverse ctermfg = 250 ctermbg = 232"

        set fillchars=vert:\|,stl:\ ,stlnc:\ 
    endif

    " Show the line number relative to the line
    if exists("&relativenumber")
        autocmd BufEnter * set relativenumber
    endif

    set tabpagemax=15               " only show 15 tabs

    if has('cmdline_info')
        set ruler                   " show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
        set showcmd                 " show partial commands in status line and
                                    " selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2
        set statusline=%F%m%r%h%w
        set statusline+=%=[%l,%L][%p%%][%{&ff}]%y
    endif

    set backspace=indent,eol,start  " backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set showmatch                   " show matching brackets/parenthesis
    set incsearch                   " find as you type search
    " set hlsearch                    " highlight search terms
    set winminheight=0              " windows can be 0 line high
    set ignorecase                  " case insensitive search
    set smartcase                   " case sensitive when uc present
    set wildmenu                    " show list instead of just completing
    set wildmode=longest:full       " Complete till longest common string
    set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
    set nofoldenable                " auto fold code
    set foldmethod=indent
    set foldlevel=99
" }

" Formatting {
    set nowrap                      " wrap long lines
    set autoindent                  " indent at the same level of the previous line
    set shiftwidth=4                " use indents of 4 spaces
    set expandtab                   " tabs are spaces, not tabs
    set tabstop=4                   " an indentation every four columns
    set softtabstop=4               " let backspace delete indent
    set pastetoggle=<F2>            " pastetoggle (sane indentation on pastes)
" }

" Key (re)Mappings {

    let mapleader = ','

    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Fast tab
    map <C-J> gT
    map <C-K> gt

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    command! -nargs=* -complete=file E tabe <args>                                                                                                                                       

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    """ Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    "clearing highlighted search
    nmap <silent> <leader>/ :nohlsearch<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ee :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " nmap <silent> <leader>/ :nohlsearch<CR>
    nmap <silent> <leader>/ :set invhlsearch<CR>

    " Scrolling in vim autocomplete box with jk movement keys
    " inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("\<C-j>"))
    " inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("\<C-k>"))

    " Line numbrer toggle
    nnoremap <F3> :set nonumber! norelativenumber!<CR>
" }

" Plugins {

    " Misc {
        let b:match_ignorecase = 1
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags
    " }

    " NerdTree {
        map <C-n> :NERDTreeToggle<CR>
        " map <C-n> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
        " map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeShowLineNumbers=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    " }

    " Tabularize {
        nmap <Leader>a= :Tabularize /=<CR>
        vmap <Leader>a= :Tabularize /=<CR>
        nmap <Leader>a: :Tabularize /:<CR>
        vmap <Leader>a: :Tabularize /:<CR>
        nmap <Leader>a:: :Tabularize /:\zs<CR>
        vmap <Leader>a:: :Tabularize /:\zs<CR>
        nmap <Leader>a, :Tabularize /,<CR>
        vmap <Leader>a, :Tabularize /,<CR>
        nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
     " }

     " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        nmap <leader>sl :SessionList<CR>
        nmap <leader>ss :SessionSave<CR>
     " }

     " TagBar {
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
        exec "hi! TagbarHighlight ctermbg=232"
        let g:tagbar_autofocus=1
        let g:tagbar_show_linenumbers=1
        let g:tagbar_iconchars=['+', '-']
        let g:tagbar_autoclose=1
        let g:tagbar_type_php = {
            \ 'ctagstype' : 'php',
            \ 'kinds'     : [
                \ 'i:interfaces',
                \ 'c:classes',
                \ 'd:constant definitions',
                \ 'f:functions',
                \ 'j:javascript functions:1'
            \ ]
        \ }
     "}

     " BufExplorer {
        let g:bufExplorerSortBy='fullpath'
        let g:bufExplorerShowRelativePath=0
     " }

     " Fuzzyfinder {
        noremap <silent> <C-\> :FufTagWithCursorWord!<CR>

        nnoremap <silent> <leader>fb :FufBuffer<CR>
        nnoremap <silent> <leader>ft :FufTag<CR>
        nnoremap <silent> <leader>f, :FufBufferTag<CR>
        nnoremap <silent> <leader>f. :FufBufferTagAll<CR>

        let g:fuf_keyOpenSplit=''
        let g:fuf_keyOpenVsplit=''
        let g:fuf_enumeratingLimit=20

        " No php variable
        let g:fuf_buffertag__php='--language-force=php --php-types=cdf'
     " }
     
     " Ctrlp {
        let g:ctrlp_working_path_mode='ra'
        let g:ctrlp_root_markers = ['.ctrlp']
        let g:ctrlp_max_files=0
        let g:ctrlp_lazy_update=1
        let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

        " On Windows use "dir" as fallback command.
        if WINDOWS()
            let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
        elseif executable('ag')
            let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
        elseif executable('ack')
            let s:ctrlp_fallback = 'ack %s --nocolor -f'
        else
            let s:ctrlp_fallback = 'find %s -type f'
        endif
        let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': s:ctrlp_fallback
        \ }

        " let g:ctrlp_prompt_mappings = {
        "     \ 'AcceptSelection("t")': ['<c-l>'],
        "     \ 'PrtCurRight()':        ['<c-t>', '<right>'],
        " \ }
     "
     
     " Airline {
        let g:airline_theme = 'sol'

        let g:airline_left_sep = ''
        let g:airline_right_sep = ''

        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#tab_nr_type = 1
        let g:airline#extensions#tabline#left_sep = ''
        let g:airline#extensions#tabline#left_alt_sep = ''
        let g:airline#extensions#tabline#fnamemod = ':t'
        let g:airline#extensions#tabline#show_buffers = 0

        let g:airline_section_c = '%f%m'
        let g:airline_section_warning = ''
        let g:airline_section_z = '%p%% %l:%L'

        let g:airline_detect_modified = 0

        let g:airline_theme_patch_func = 'AirlineThemePatch'
        function! AirlineThemePatch(palette)
            if g:airline_theme == 'luna'
                let color = a:palette.tabline['airline_tab']
                let color[2] = 251
            endif
        endfunction
     " }

     " Neocomplcache {
        let g:neocomplcache_enable_at_startup = 1
        let g:neocomplcache_max_list = 10

        " Define dictionary.
        let g:neocomplcache_dictionary_filetype_lists = {
        \   'default'   : '',
        \   'php'       : '~/.vim/bundle/vim-dict/dict/php.dic'
        \ }

        " Plugin key-mappings.
        inoremap <expr><C-g>     neocomplcache#undo_completion()
        inoremap <expr><Space>   pumvisible() ? neocomplcache#close_popup()."\<SPACE>" : "\<Space>"

        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
            return neocomplcache#smart_close_popup() . "\<CR>"
            " For no inserting <CR> key.
            "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
        endfunction
     " }

     " Neosnippet {
     
        " Tell Neosnippet about the other snippets
        let g:neosnippet#snippets_directory = '~/.vim/bundle/vim-snippets/snippets'

        " Plugin key-mappings.
        imap <C-k>     <Plug>(neosnippet_expand_or_jump)
        smap <C-k>     <Plug>(neosnippet_expand_or_jump)
        xmap <C-k>     <Plug>(neosnippet_expand_target)

        " For snippet_complete marker.
        if has('conceal')
          set conceallevel=2 concealcursor=i
        endif
     " }
" }

" GUI Settings {
    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " remove the toolbar bar
        set guioptions-=r           " remove the scroll bar
        set lines=40                " 40 lines of text instead of 24,
        if has("gui_gtk2")
            set guifont=Menlo:11
        else
            set guifont=Menlo:h11
        endif
        if has('gui_macvim')
            set transparency=5          " Make the window slightly transparent
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256                 " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        if &term =~ '256color'
          " disable Background Color Erase (BCE) so that color schemes
          " render properly when inside 256-color tmux and GNU screen.
          " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
          set t_ut=
        endif
    endif

    set nospell                     " spell checking 0ff
" }

" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let separator = "."
        let parent = $HOME
        let prefix = '.vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = parent . '/' . prefix . dirname . "/"
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }
" }
