" ============================================================================
" FILE: podcast.vim
" AUTHOR: koturn <jeak.koutan.apple@gmail.com>
" DESCRIPTION: {{{
" descriptions.
" unite.vim: https://github.com/Shougo/unite.vim
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim


let s:kind = {
      \ 'name': 'podcast',
      \ 'action_table': {},
      \ 'default_action': 'play'
      \}

let s:kind.action_table.play = {
      \ 'description': 'play specified item'
      \}
function! s:kind.action_table.play.func(candidate) abort
  call podcast#play(a:candidate)
endfunction


function! unite#kinds#podcast#define() abort
  return s:kind
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
