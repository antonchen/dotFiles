"vimrc by Anton Chen
"2015-3-5 12:09:45
"
"判定当前操作系统类型
if has("win32") || has("win32unix")
    let g:OS#name = "win"
    let g:OS#win = 1
    let g:OS#mac = 0
    let g:OS#unix = 0
elseif has("mac")
    let g:OS#name = "mac"
    let g:OS#mac = 1
    let g:OS#win = 0
    let g:OS#unix = 0
elseif has("unix")
    let g:OS#name = "unix"
    let g:OS#unix = 1
    let g:OS#win = 0
    let g:OS#mac = 0
endif
if has("gui_running")
    let g:OS#gui = 1
else
    let g:OS#gui = 0
endif

"设置用户路径
if g:OS#win
    let $VIMFILES = $VIM.'/vimfiles'
    let $HOME = $VIMFILES
    let $WORKING = 'D:\Documents\Working'
    source $VIMRUNTIME/mswin.vim
    behave mswin
elseif g:OS#unix
    let $VIM = $HOME
    let $VIMFILES = '~/.vim'
elseif g:OS#mac
    let $VIM = $HOME
    let $VIMFILES = '~/.vim'
endif

if g:OS#win
	 " MyDiff 
	set diffexpr=MyDiff()
	function! MyDiff()
		  let opt = '-a --binary '
		  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
		  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
		  let arg1 = v:fname_in
		  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
		  let arg2 = v:fname_new
		  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
		  let arg3 = v:fname_out
		  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
		  let eq = ''
		  if $VIMRUNTIME =~ ' '
			if &sh =~ '\<cmd'
			  let cmd = '""' . $VIMRUNTIME . '\diff"'
			  let eq = '"'
			else
			  let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
			endif
		  else
			let cmd = $VIMRUNTIME . '\diff'
		  endif
		  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
endif

" Win平台下窗口全屏组件 gvimfullscreen.dll
" Alt + Enter 全屏切换
" Shift + t 降低窗口透明度
" Shift + y 加大窗口透明度
" Shift + r 切换Vim是否总在最前面显示
" Vim启动的时候自动使用当前颜色的背景色以去除Vim的白色边框
if g:OS#gui && g:OS#win && has('libcall')
    let g:MyVimLib = 'gvimfullscreen.dll'
    function! ToggleFullScreen()
        call libcall(g:MyVimLib, 'ToggleFullScreen', 1)
    endfunction

    let g:VimAlpha = 245
    function! SetAlpha(alpha)
        let g:VimAlpha = g:VimAlpha + a:alpha
        if g:VimAlpha < 180
            let g:VimAlpha = 180
        endif
        if g:VimAlpha > 255
            let g:VimAlpha = 255
        endif
        call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
    endfunction

    let g:VimTopMost = 0
    function! SwitchVimTopMostMode()
        if g:VimTopMost == 0
            let g:VimTopMost = 1
        else
            let g:VimTopMost = 0
        endif
        call libcall(g:MyVimLib, 'EnableTopMost', g:VimTopMost)
    endfunction
    "映射 Alt+Enter 切换全屏vim
    map <a-enter> <esc>:call ToggleFullScreen()<cr>
    "切换Vim是否在最前面显示
    nmap <s-r> <esc>:call SwitchVimTopMostMode()<cr>
    "增加Vim窗体的不透明度
    nmap <s-t> <esc>:call SetAlpha(10)<cr>
    "增加Vim窗体的透明度
    nmap <s-y> <esc>:call SetAlpha(-10)<cr>
    " 默认设置透明
    autocmd GUIEnter * call libcallnr(g:MyVimLib, 'SetAlpha', g:VimAlpha)
endif

"配置文件自动载入
if g:OS#win
    autocmd! bufwritepost source $VIM/_vimrc %
elseif g:OS#unix
    autocmd! bufwritepost source $VIM/.vimrc %
elseif g:OS#mac
    autocmd! bufwritepost source $VIM/.vimrc %
endif

set nocompatible "不要vim模仿vi模式，兼容设置
set backspace=indent,eol,start "设置退格键
set pastetoggle=<F3> " <F3> Paste
filetype off

"Vundle设置
set rtp+=$VIMFILES/bundle/Vundle.vim/
let path=$VIMFILES.'/bundle'
call vundle#begin(path)

Plugin 'gmarik/Vundle.vim'

"插件
Plugin 'bling/vim-airline'
Plugin 'mhinz/vim-startify'
Plugin 'majutsushi/tagbar'
Plugin 'Shougo/neocomplete.vim'
Plugin 'tracyone/snippets'
Plugin 'tracyone/dict'
Plugin 'SirVer/ultisnips'
Plugin 'aperezdc/vim-template'

"New
Plugin 'EasyGrep'

"颜色
"Plugin 'Lucius'
Plugin 'tomasr/molokai'
call vundle#end()
filetype plugin indent on

"设置文件头信息
let g:username = 'Anton Chen'
let g:email = 'contact@antonchen.com'
let g:license = 'BSD'

"UltiSnips
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsListSnippets = '<C-Tab>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
let g:UltiSnipsSnippetDirectories = ["bundle/snippets"]
let g:UltiSnipsSnippetsDir = $VIMFILES.'/bundle/snippets'

"启用 neocomplete
let g:neocomplete#enable_at_startup = 1

"Tagbar
nmap <F8> :TagbarToggle<CR>

"中文乱码
set encoding=utf-8
set fenc=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set termencoding=utf-8
if g:OS#win
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8
endif
if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
endif

"关闭自动检测
let g:fencview_autodetect=0

"新文件换行符
set fileformat=unix
set fileformats=unix,dos,mac

"禁止UTF-8 BOM
set nobomb

"自动识别文件类型
filetype on

"界面设置
set number
set numberwidth=6
set laststatus=2
set cursorline
if g:OS#win
    set guifont=DejaVu_Sans_Mono_for_Powerline:h12
elseif g:OS#gui
    set guifont=Sauce\ Code\ Powerline\ Regular\ 12
endif
set shortmess=atI                          

"隐藏菜单栏
if g:OS#gui
set guioptions-=m " 隐藏菜单栏
set guioptions-=T " 隐藏工具栏
set guioptions-=L " 隐藏左侧滚动条
set guioptions-=r " 隐藏右侧滚动条
set guioptions-=b " 隐藏底部滚动条
set showtabline=0 " 隐藏Tab栏
endif

"默认窗口位置和大小
if g:OS#gui
    winpos 235 235
    set lines=25 columns=108
endif

"代码高亮
"colorscheme Lucius
"LuciusBlack
colorscheme molokai 
let g:rehash256 = 1
syntax enable
syntax on

"设置制表符缩进
set ts=4
set expandtab

"继承缩进
set autoindent
set shiftwidth=4

"只在标签中显示文件名
"function ShortTabLabel ()
"    let bufnrlist = tabpagebuflist (v:lnum)
"    let label = bufname (bufnrlist[tabpagewinnr (v:lnum) -1])
"    let filename = fnamemodify (label, ':t')
"    return filename
"endfunction
"set guitablabel=%{ShortTabLabel()}

"显示匹配
set showmatch

"上次文件编辑位置
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"标签跳转
map <S-Up> :bp<CR>
map <S-Down> :bn<CR>

"设置文件默认保存目录
if g:OS#win
    exec 'cd ' . fnameescape($WORKING)
endif

"airline插件设置
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'luna'
set t_Co=256
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
if g:OS#win
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
elseif g:OS#unix
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
endif
