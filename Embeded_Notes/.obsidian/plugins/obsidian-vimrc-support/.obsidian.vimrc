
"开启高亮
syntax on

"vim可以识别文件类型
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

"更改tab的格式,将tab设置成2
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2

"设置编码
set encoding=utf-8
"自动换行
set wrap
"显示命令
set showcmd
"命令补全选择
set wildmenu
"搜索高亮
set hlsearch
set incsearch
"搜索忽略大小写
set ignorecase
"智能大小写区分
set smartcase
"进入新文件去除高亮,刷新也可以去除高亮
exec "nohlsearch"
"出错时，发出视觉提示，通常是屏幕闪烁
set visualbell
"启用256色
set t_Co=256
"当文件在外部被修改时，自动重新读取
set autoread     
"行首按退格可以退回上一行
set backspace=indent,eol,start
"光标回到上次文件打开的位置
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"刷新
map R :source $MYVIMRC<CR>
"去除高亮的快捷键
map <tab><CR> :nohlsearch<CR>
"映射jk为esc键
inoremap jk <esc>
