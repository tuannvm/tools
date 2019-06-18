"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/tuannvm/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/tuannvm/.cache/dein')
  call dein#begin('/Users/tuannvm/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/tuannvm/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
" snippets
"  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets')
" editorconfig
  call dein#add('editorconfig/editorconfig-vim')
" focus on single window
  call dein#add('dhruvasagar/vim-zoom')
" for comment
  call dein#add('tpope/vim-commentary')
" resize
  " call dein#add('simeji/winresizer')
" copy over ssh
""  call dein#add('fcpg/vim-osc52')
" auto complete
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/neoinclude.vim')
  " call dein#add('neoclide/coc.nvim', {'build': './install.sh'})
" linting
  call dein#add('w0rp/ale')
" textobj
  call dein#add('michaeljsmith/vim-indent-object')
  call dein#add('kana/vim-textobj-user')
  call dein#add('kana/vim-textobj-entire')
  call dein#add('kana/vim-textobj-line')
" grep
  call dein#add('mhinz/vim-grepper')
  call dein#add('skwp/greplace.vim')
" python support  
  call dein#add('Chiel92/vim-autoformat')
" gist support
  call dein#add('mattn/gist-vim')
  call dein#add('mattn/webapi-vim')
" go support  
  call dein#add('fatih/vim-go')
  " call dein#add('jodosha/vim-godebug')
  " call dein#add('zchee/deoplete-go', {'build': 'make'})
  " call dein#add('autozimu/LanguageClient-neovim', {'build': 'bash install.sh'})
" function tagbar
"  call dein#add('majutsushi/tagbar')
" sort
  call dein#add('christoomey/vim-sort-motion')
" ansible
"  call dein#add('pearofducks/ansible-vim')
" markdown
  " call dein#add('dhruvasagar/vim-table-mode')
  " call dein#add('tuannvm/vim-markdown-toc')
  " call dein#add('previm/previm')
"  call dein#add('tyru/open-browser.vim')
  call dein#add('plasticboy/vim-markdown')

" change content inside parathense
"  call dein#add('wellle/targets.vim')
" git support
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')
  call dein#add('shumphrey/fugitive-gitlab.vim')
" terraform support
  call dein#add('hashivim/vim-terraform')
" theme
  call dein#add('lifepillar/vim-solarized8')
" tmux
" call dein#add('christoomey/vim-tmux-navigator')
" helm
  call dein#add('towolf/vim-helm')
" fuzzy search
  call dein#add('junegunn/fzf.vim')
"  call dein#add('junegunn/fzf', {'build': './install --all'})
" terminal
  call dein#add('mklabs/split-term.vim')
  call dein#add('wincent/terminus')
" difftool
  call dein#add('whiteinge/diffconflicts')
" statusbar
  call dein#add('rbong/vim-crystalline')
" json
  call dein#add('elzr/vim-json')
" nerdtree
"  call dein#add('scrooloose/nerdtree')
"  call dein#add('jistr/vim-nerdtree-tabs')
" change surround quote
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-repeat')
if dein#check_install()
  call dein#install()
endif

" You can specify revision/branch/tag.
  call dein#add('Shougo/deol.nvim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

set runtimepath+=~/.vim_runtime

" tmux hack
nnoremap <silent> <BS> :TmuxNavigateLeft<cr>

source ~/.config/nvim/my_configs.vim
" source ~/.config/nvim/basic.vim

