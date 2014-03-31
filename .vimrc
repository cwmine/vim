function! MySys()
    if has('win32') || has ('win64')
        return 'windows'
    elseif has("unix")
        return 'unix'
    else
        return 'mac'
    endif
endfunction


" 默认脚本
if MySys()=='windows'
    source $VIMRUNTIME/vimrc_example.vim
    " no need 
    "source $VIMRUNTIME/mswin.vim
    "behave mswin

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

" 我的脚本
" 基本设置

if MySys()=="unix" || MySys()== "mac" "shell 设置

    set shell =bash
else
    "if use cygwin
    "set shell=E:cygwininsh
endif
set history =400 " 命令记录的最大行数

set  nocp       " 不兼容vi的操作方式
set  ru     " 打开状态标尺栏
set  hls    " 高亮找到文本
set  is     " 即时检索
set backspace=indent,eol,start  " 使在insert模式下用backspace删除非添加的部分
set whichwrap=b,s,<,>,[,]   " 使在行首往前移动光标能跳跃到上一行
if has("eval")&& v:version>=600
    filetype plugin indent on   " 自动检测文件类型，启用自动相应类型缩进
endif
if exists("&autoread")       " 若外部修改文件，自动载入
    set autoread
endif
set mouse=a                 "始终允许鼠标
set ic                      "忽略大小写，关闭用noic

    "映射快捷键key
let mapleader = ","
let g:mapleader = ","
if MySys()=='windows'       "打开vimrc文件
    "nmap <silent><leader>ee :e $VIM/_vimrc<cr>
    nmap <silent><leader>ee :e ~/.vimrc<cr>
else
    " 打开config文件
    nmap <silent><leader>ee :e ~/.vimrc<cr>
endif
    " 保存快捷键
nmap <silent><leader>wn :w<cr>
    " 取消高亮
nmap <silent><leader>l :nohl<cr>
    " 重头同步语法高亮，对于语法高亮出现问题的有效
nmap <silent><leader>$ :syntax sync fromstart<cr>

    " maximize the GVIM window(without the title bar)
let g:window_maximum_status=0
function! SwitchGvimMaximum()
    if MySys()=='windows'
        if g:window_maximum_status==0
            simalt ~x "call libcallnr('vimtweak.dll','EnableMaximize',1)
            call libcallnr('vimtweak.dll','EnableCaption',0)
            let g:window_maximum_status=1
        else
            simalt ~r "call libcallnr('vimtweak.dll','EnableMaximize',1)
            call libcallnr('vimtweak.dll','EnableCaption',1)
            let g:window_maximum_status=0
        endif
    endif
endfunction
nmap <silent><leader>mx :call SwitchGvimMaximum()<cr>

"系统剪贴板操作
vnoremap <C-c> "+y

" 颜色字体
syntax on
if MySys()=="windows"
    if (has("gui_running"))
        set guifont=Inconsolata:h12:cANSI
        set guifontwide="Microsoft YaHei":h12:cGB2312
    endif
else
    if (has("gui_running"))
        set guifont=Bitstream\ Vera\ Sans\ Mono\ 10.5
        set gfw=Yahei\ Mono\ 10.5
    endif
endif

" 字符编码及中文支持
set encoding=utf8       " 默认编码utf8
if exists("&ambiwidth") " if you use vim in tty, uxterm -cjk or putty with options' Treat CJK ambiguous characters as wide' on
    set ambiwidth=double        " 防止不同语言的字符能够显示
endif
if has("gui_running") || MySys()=="windows"
    set langmenu=zh_CN.UTF-8        " 菜单语言防止乱码
    language message zh_CN.UTF-8    " 强制提示语言的格式
else
    set encoding=utf-8        "设置命令提示符vim不乱码
    set termencoding=utf-8      "终端下的编码,gvim没必要设置
endif
if MySys()=="windows"   "解决中文乱码问题
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
endif

set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1 "使其支持各种文件编码的自动识别（从最严格的编码到最不严格的编码latan1（能“解码仍和乱码”））,若误判 在:e(打开文件)后加++enc=编码格式 来完成文件的读入

" 文本设置
set sw=4    " 自动缩进为4个空格
set ts=4    " tab为四个字符宽度
set et      " 编辑状态下（Insert）,输入tab键 输出的是空格，对已存在的文件处理，需输入:retab
set smarttab    " backspace 自动删除由tab生成的空格
set nospell       " 拼写检查
set nowrap          " 不折行

" 断行编辑
set tw=0  " 行最大宽度（超过tw 就自动折行）
set lbr     " 不在单词中断行
set fo+=mB  " 支持亚洲语言的断行（更多看help fo）

" C/C++ (仅对 C/C++有效)
set sm      " 显示括号配对
set cin     " C/C++自动缩进
set cino=:0g0t0(sus)    " 设置C/C++风格自动缩进的选项（具体help cino）

" 其他设置
set selectmode=     " 不使用selectmode 用鼠标和shift+方向键来选择区域的模式
set keymodel=       " 不使用shift+方向键来跳过单词字符,startsel,stopsel来开启
set wildmenu        " 在命令模式时，将补全内容用一个漂亮的单行菜单显示出来
colo torte          " 配色方案（在菜单 编辑->配色方案列出所有配色方案）

" 图形界面（gvim）
if has("gui_running")
    set mousemodel=popup    " 右键鼠标弹出菜单
    set guioptions-=b       " 添加水平滚动条
    set guioptions-=m       " 菜单
    set guioptions-=T       " 后台标签页打开
    set guioptions-=l       " 左滚动条始终存在
    set guioptions-=L       " 左滚动条必要时显示
    set guioptions-=r       " 右
    set guioptions-=R       " 右

endif


"会话
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,slash,unix  "使在windows和unix下的session文件通用

"Project自动载入workspace.vim,并将workspace.vim所在文件夹设为工作目录
if filereadable("workspace.vim")
    source workspace.vim
elseif filereadable("../workspace.vim")
    source ../workspace.vim
endif

""""""""""""""""""""""""""""""""""" Plugins
"##### for vundle: vim plugin manager####
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
        "let Vundle manage Vundle required!
" vim-scripts repos
Bundle 'taglist.vim'
Bundle 'minibufexpl.vim'
Bundle 'restart.vim'
Bundle 'fortran_codecomplete.vim'
" orginal repos on github
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
    " 文件管理器
"Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'
    " 语法检查器
Bundle 'klen/python-mode'
    " python tool with pylint rope pydoc breakpoints
Bundle  'coot/atp_vim'
    " automatic Latex Plugin



"#####vundle end###########
filetype plugin indent on   " required!rc()
" Plugin 设置
" ### python mode
"let g:pymode_lint = 0 
   " close pythonmode checker use syntastic checker
let g:pymode_virtualenv =1
    " automatic virtualenv decection also can use PymodeVirtualenv <path> to
    " activate
let g:pymode_breakpoint = 1
let g:pymode_lint =1
let g:pymode_lint_checkers = ['pyflakes', 'pylint', 'mccabe']
let g:pymode_rope_completion_bind = '<C-N>'
let g:pymode_lint_cwindow = 0
        " close the quickfix
let g:pymode_lint_on_write = 0
        " close save checking
let g:pymode_rope_complete_on_dot = 0
        " close the auto completion when typeing dot
autocmd FileType python nmap <silent><leader>ck :PymodeLintAuto<cr> :PymodeLint<cr>
        " add checking


"#### Syntastic
let g:syntastic_check_on_open = 1
"cpp
"let g:syntastic_cpp_include_dirs = ['/usr/include/']
"let g:syntastic_cpp_remove_include_errors = 1
"let g:syntastic_cpp_check_header = 1
"let g:syntastic_cpp_compiler = 'clang++'
"let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
"python
let g:syntastic_ignore_files = ['\.py$']
" ignore python checker if use pythonmode checker
"let g:syntastic_python_checkers=["pyflaks","pylint"]

"set error or warning signs
let g:syntastic_error_symbol = 'E'
let g:syntastic_warning_symbol = 'W'
"whether to show balloons
let g:syntastic_enable_balloons = 1
"

" ### TagList
if MySys()=="windows"
    let Tlist_Ctags_Cmd= '~\.vimrc\ctags.exe'
elseif MySys()=="unix"
    let Tlist_Ctags_Cmd= '/usr/bin/ctags'
endif
let Tlist_Show_One_File=1   "不同显示多个文件的tag只显示当前文件的
let Tlist_Show_Exit_OnlyWindow = 1  "最后之剩Taglist窗口，则退出Vim
let Tlist_Use_Right_Window = 1      "在右侧显示taglist窗口
    "F11 打开TList
nmap <silent><F11> : TlistToggle<cr>

"### NerdTree 文件浏览器
"autocmd VimEnter * NERDTree " 启动 vim 时一并启动 NerdTree
nmap <silent><F12> :NERDTreeToggle<cr>
            " 通过 F12 控制 NerdTree 的开关
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
            " 关闭 Vim 的最后一个当前文件时也退出 NerdTree

""### BufExplorer --> temporally using minibuffexpl only
""let g:bufExplorerDefaultHelp=0       " Do not show default help.
"let g:bufExplorerShowRelativePath=1  " Show relative paths.
"let g:bufExplorerSortBy='mru'        " Sort by most recently used.
"let g:bufExplorerSplitRight=0        " Split left.
"let g:bufExplorerSplitVertical=1     " Split vertically.
"let g:bufExplorerSplitVertSize = 30  " Split width
"let g:bufExplorerUseCurrentWindow=1  " Open in new window.
"autocmd BufWinEnter \[Buf\ List\] setl nonumber


""### OmniCompletetion  -> replace by YouCompleteMe instead
"let OmniCpp_NamespaceSearch = 1
"let OmniCpp_GlobalScopeSearch = 1
"let OmniCpp_ShowAccess = 1
"let OmniCpp_ShowPrototypeInAbbr = 1 " 显示函数参数列表
"let OmniCpp_MayCompleteDot = 1   " 输入 .  后自动补全
"let OmniCpp_MayCompleteArrow = 1 " 输入 -> 后自动补全
"let OmniCpp_MayCompleteScope = 1 " 输入 :: 后自动补全
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
"" 自动关闭补全窗口
"au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menuone,menu,longest
"" 弹出菜单配色
"highlight Pmenu    guibg=darkgrey  guifg=black
"highlight PmenuSel guibg=lightgrey guifg=black
"

"### minibufexpl plugin
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
        "control + the vim direction keys [hjkl] can be made to move you between windows.
        "control + arrow keys can be made to do the same thing
        "control + tab & shift + control + tab can be setup to switch through your open windows (like in MS Windows)
        "control + tab & shift + control + tab can alternatively be setup to cycle forwards and backwards through your modifiable buffers in the current window

""""""""""""""""""""""""""""""""""" For Language and Other Software
" for python
" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
" for Python style
"   UltimateVimPythonSetup
" for python end


"
"
" for fcitx
" ##### auto fcitx  ###########
let g:input_toggle = 1
function! Fcitx2en()
   let s:input_status = system("fcitx-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx-remote -c")
   endif
endfunction

function! Fcitx2zh()
   let s:input_status = system("fcitx-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx-remote -o")
      let g:input_toggle = 0
   endif
endfunction

if MySys()=="unix"
    set timeoutlen=150
    "退出插入模式
    autocmd InsertLeave * call Fcitx2en()
    "进入插入模式
    autocmd InsertEnter * call Fcitx2zh()
endif
"##### auto fcitx end ######
