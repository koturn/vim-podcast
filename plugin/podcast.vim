" ============================================================================
" FILE: podcast.vim
" AUTHOR: koturn <jeak.koutan.apple@gmail.com>
" DESCRIPTION: {{{
" Podcast player for Vim.
" }}}
" ============================================================================
if exists('g:loaded_podcast')
  finish
endif
let g:loaded_podcast = 1
let s:save_cpo = &cpo
set cpo&vim

command! -bar PodcastStop  call podcast#stop()
command! -bar -nargs=* -complete=customlist,podcast#complete_channel PodcastUpdate  call podcast#update(<f-args>)
command! -bar PodcastShowInfo  call podcast#show_info()

command! -nargs=* -complete=customlist,podcast#complete_channel CtrlPPodcast  call ctrlp#podcast#start(<f-args>)


let &cpo = s:save_cpo
unlet s:save_cpo
