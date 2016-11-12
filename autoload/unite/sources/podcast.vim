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


let s:source = {
      \ 'name': 'podcast',
      \ 'description': 'Podcast player',
      \ 'default_kind': 'podcast'
      \}

function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort
  let arglead = tolower(a:arglead)
  return filter(podcast#get_channel_names(), '!stridx(tolower(v:val), arglead)')
endfunction

function! s:source.gather_candidates(args, context) abort
  let names = len(a:args) == 0 ? podcast#get_channel_names() : a:args
  let candidates = []
  for name in names
    let items = podcast#get_items(name)
    for item in items
      let item.word = item.title . ' [' . name . ']'
    endfor
    call extend(candidates, items)
  endfor
  return candidates
endfunction


function! unite#sources#podcast#define() abort
  return s:source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
