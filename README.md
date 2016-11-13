vim-podcast
===========

[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)

Podcast player for Vim.


## Usage

This plugin provides extension for following plugins.

- [denite.nvim](https://github.com/Shougo/denite.nvim)
- [unite.vim](https://github.com/Shougo/unite.vim)
- [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)

```vim
" With denite.nvim
:Denite podcast:{channel-name}
" With untie.vim
:Unite podcast:{channel-name}
" With ctrlp.vim
:CtrlPPodcast {channel-name}
```

For the first time, this plugin takes a long time to parse feed XML. From the
Second and subsequent, this plugin use the cache of parsing result of XML.

If you want to update cache, execute following command.

```vim
:PodcastUpdate {channel-name}
```

If you want to stop playing, execute following command.

```vim
:PodcastStop
```


### Supported channel

channel-name | podcast name
-------------|---------------------------------------------
backpacefm   | [backspace.fm](http://backspace.fm/)
mozaicfm     | [mozaic.fm](https://mozaic.fm)
rebuildfm    | [rebuild.fm](https://rebuild.fm)


## Installation

### With [dein.vim](https://github.com/Shougo/neobundle.vim)

Write following code to your `.vimrc` and execute `:call dein#install()` in
your Vim.

```vim
call dein#add('koturn/vim-podcast', {
      \ 'depends': ['denite.nvim', 'unite.vim', 'ctrlp.vim'],
      \ 'on_cmd': [
      \   'PodcastStop',
      \   'PodcastUpdate',
      \   'CtrlPPodcast',
      \ ],
      \ 'on_source': ['denite.nvim', 'unite.vim']
      \})
```

### With [NeoBundle](https://github.com/Shougo/neobundle.vim)

Write following code to your `.vimrc` and execute `:NeoBundleInstall` in your
Vim.

```vim
NeoBundle 'koturn/vim-podcast'
```

If you want to use `:NeoBundleLazy`, write following code in your .vimrc.

```vim
NeoBundle 'koturn/vim-podcast', {
      \ 'depends': ['Shougo/denite.nvim', 'Shougo/unite.vim', 'ctrlpvim/ctrlp.vim'],
      \ 'on_cmd': [
      \   'PodcastStop',
      \   'PodcastUpdate',
      \   'CtrlPPodcast',
      \ ],
      \ 'on_source': ['denite.nvim', 'unite.vim']
      \}
```

### With [Vundle](https://github.com/VundleVim/Vundle.vim)

Write following code to your `.vimrc` and execute `:PluginInstall` in your Vim.

```vim
Plugin 'koturn/vim-podcast'
```

### With [vim-plug](https://github.com/junegunn/vim-plug)

Write following code to your `.vimrc` and execute `:PlugInstall` in your Vim.

```vim
Plug 'koturn/vim-podcast'
```

### With [vim-pathogen](https://github.com/tpope/vim-pathogen)

Clone this repository to the package directory of pathogen.

```
$ git clone https://github.com/koturn/vim-podcast.git ~/.vim/bundle/vim-podcast
```

### With packages feature

In the first, clone this repository to the package directory.

```
$ git clone https://github.com/koturn/vim-podcast.git ~/.vim/pack/koturn/opt/vim-podcast
```

Second, add following code to your `.vimrc`.

```vim
packadd vim-podcast
```

### With manual

If you don't want to use plugin manager, put files and directories on
`~/.vim/`, or `%HOME%/vimfiles/` on Windows.


## Dependent plugins

### Required

- [koturn/vim-mplayer](https://github.com/koturn/vim-mplayer)

### Optional

One of following plugin is required.

- [Shougo/denite.nvim](https://github.com/Shougo/denite.nvim)
- [Shougo/unite.vim](https://github.com/Shougo/unite.vim)
- [ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)

If your vim didn't be compiled with `+job`, following plugin is required.

- [Shougo/vimporc.vim](https://github.com/Shougo/vimporc.vim)


## Requirements

- [mplayer](http://www.mplayerhq.hu)


## LICENSE

This software is released under the MIT License, see [LICENSE](LICENSE).
