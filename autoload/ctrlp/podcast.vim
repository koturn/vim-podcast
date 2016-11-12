" ============================================================================
" FILE: podcast.vim
" AUTHOR: koturn <jeak.koutan.apple@gmail.com>
" DESCRIPTION: {{{
" Podcast player for Vim.
" This file is a extension for ctrlp.vim.
" ctrlp.vim: https://github.com/ctrlpvim/ctrlp.vim
" }}}
" ============================================================================
if get(g:, 'loaded_ctrlp_podcast', 0)
  finish
endif
let g:loaded_ctrlp_podcast = 1
let s:save_cpo = &cpo
set cpo&vim

let s:ctrlp_builtins = ctrlp#getvar('g:ctrlp_builtins')

function! s:get_sid_prefix() abort
  return matchstr(expand('<sfile>'), '^function \zs<SNR>\d\+_\zeget_sid_prefix$')
endfunction
let s:sid_prefix = s:get_sid_prefix()
delfunction s:get_sid_prefix

let g:ctrlp_ext_var = add(get(g:, 'ctrlp_ext_vars', []), {
      \ 'init': s:sid_prefix . 'init()',
      \ 'accept': s:sid_prefix . 'accept',
      \ 'lname': 'podcast',
      \ 'sname': 'podcast',
      \ 'type': 'tabs',
      \ 'sort': 0,
      \ 'nolim': 1
      \})
let s:id = s:ctrlp_builtins + len(g:ctrlp_ext_vars)
unlet s:ctrlp_builtins s:sid_prefix


function! ctrlp#podcast#start(...) abort
  let s:names = a:0 == 0 ? podcast#get_channel_names() : a:000
  call ctrlp#init(s:id)
endfunction


function! s:init() abort
  call s:syntax()
  let [s:candidates, words] = [[], []]
  for name in s:names
    let candidates = podcast#get_items(name)
    call extend(s:candidates, candidates)
    call extend(words, map(candidates, 'v:val.title . "\t" . ' . string(name)))
  endfor
  return words
endfunction

function! s:accept(mode, str) abort
  call ctrlp#exit()
  let str = a:str[: strridx(a:str, "\t") - 1]
  for candidate in s:candidates
    if candidate.title ==# str
      call podcast#play(candidate)
      call podcast#show_info()
      return
    endif
  endfor
endfunction

function! s:syntax() abort
  if ctrlp#nosy() | return | endif
  call ctrlp#hicheck('CtrlPPodcastTabExtra', 'Comment')
  syntax match CtrlPPodcastTabExtra '\zs\t.*$'
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
