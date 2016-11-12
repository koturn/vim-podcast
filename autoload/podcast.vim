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
  echomsg a:item.enclosure
  call s:mplayer.play(a:item.enclosure)
endfunction

function! podcast#stop() abort
  call s:mplayer.stop()
endfunction

function! podcast#update(names) abort
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

function! podcast#show_info(name) abort
  if empty(s:current_channel) || !s:mplayer.is_playing() | return | endif
  let channel = podcast#{name}#define()
  let start_time = reltime()
  if has_key(channel, 'show_info')
    channel.show_info()
  else
    echo '[TITLE] ' s:current_channel.title
    echo '[PUBLISHED DATE] ' s:current_channel.pubDate
    echo '[FILE URL] ' s:current_channel.enclosure
    echo '[SUMMARY]'
    echo '  ' s:current_channel.summary
    echo '[NOTES]'
    for item in s:current_channel.note
      echo '  -' item.text
    endfor
  endif
endfunction

function! podcast#complete_channel(arglead, cmdline, cursorpos) abort
  let arglead = tolower(a:arglead)
  return filter(copy(s:channel_names), '!stridx(tolower(v:val), arglead)')
endfunction


function! s:update_channel(name) abort
  if g:podcast#verbose
    echomsg '[vim-podcast]: Start update channel:' a:name
  endif
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
