" ============================================================================
" FILE: podcast.vim
" AUTHOR: koturn <jeak.koutan.apple@gmail.com>
" DESCRIPTION: {{{
" Podcast player for Vim.
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim


let g:podcast#verbose = get(g:, 'podcast#verbose', 0)
let g:podcast#cache_dir = get(g:, 'podcast#cache_dir', expand('~/.cache/podcast'))

let s:V = vital#podcast#new()
let s:CacheFile = s:V.import('System.Cache').new('file', {'cache_dir': g:podcast#cache_dir})
let s:HTTP = s:V.import('Web.HTTP')
let s:XML = s:V.import('Web.XML')

let s:mplayer = mplayer#new()
let s:current_item = {}
let s:channel_names = map(split(globpath(expand('<sfile>:h') . '/podcast/', '*.vim', 1), "\n"), 'fnamemodify(v:val, ":t:r")')

function! podcast#play(item) abort
  let s:current_item = a:item
  call s:mplayer.play(a:item.enclosure)
endfunction

function! podcast#stop() abort
  call s:mplayer.stop()
endfunction

function! podcast#update(...) abort
  let names = a:0 == 0 podcast#get_channel_names() : a:000
  for name in names
    call s:update_channel(name)
  endfor
endfunction

function! podcast#get_items(name) abort
  let infos = s:CacheFile.get(a:name)
  return empty(infos) ? s:update_channel(a:name) : copy(infos)
endfunction

function! podcast#get_channel_names() abort
  return copy(s:channel_names)
endfunction

function! podcast#show_info() abort
  if empty(s:current_item) || !s:mplayer.is_playing() | return | endif
  echo '[TITLE]' s:current_item.title
  echo '[PUBLISHED DATE]' s:current_item.pubDate
  if has_key(s:current_item, 'duration')
    echo '[DURATION]' s:current_item.duration
  endif
  echo '[FILE URL]' s:current_item.enclosure
  echo '[SUMMARY]'
  echo ' ' s:current_item.summary
  if !empty(s:current_item.note)
    echo '[NOTES]'
    for item in s:current_item.note
      echo '  -' item.text
    endfor
  endif
endfunction

function! podcast#complete_channel(arglead, cmdline, cursorpos) abort
  let arglead = tolower(a:arglead)
  return filter(copy(s:channel_names), '!stridx(tolower(v:val), arglead)')
endfunction


function! s:update_channel(name) abort
  echomsg '[vim-podcast]: Start update channel:' a:name
  let channel = podcast#{a:name}#define()
  let start_time = reltime()

  let [time, response] = [start_time, s:HTTP.get(channel.url)]
  if response.status != 200
    echoerr '[vim-podcast] HTTP error [' . response.status . ']: ' . response.statusText
    return
  endif
  if g:podcast#verbose
    echomsg '[HTTP request]:' reltimestr(reltime(time)) 's'
  endif

  let [time, dom] = [reltime(), s:XML.parse(response.content)]
  if g:podcast#verbose
    echomsg '[parse XML]:   ' reltimestr(reltime(time)) 's'
  endif

  let [time, infos] = [reltime(), channel.parse(dom)]
  if g:podcast#verbose
    echomsg '[parse DOM]:   ' reltimestr(reltime(time)) 's'
    echomsg '[total]:       ' reltimestr(reltime(start_time)) 's'
  endif

  call s:CacheFile.set(a:name, infos)
  return infos
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
