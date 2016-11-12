" ============================================================================
" FILE: mozaicfm.vim
" AUTHOR: koturn <jeak.koutan.apple@gmail.com>
" DESCRIPTION: {{{
" Podcast player for Vim.
" This file is a definition of parser for mozaic.fm.
" mozaic.fm: https://mozaic.fm
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim


let s:V = vital#podcast#new()
let s:List = s:V.import('Data.List')
let s:XML = s:V.import('Web.XML')


function! podcast#mozaicfm#define() abort
  return s:channel
endfunction

let s:channel = {
      \ 'name': 'mozaicfm',
      \ 'url': 'http://feeds.feedburner.com/mozaicfm'
      \}

function! s:channel.parse(dom) abort
  let items = a:dom.childNode('channel').childNodes('item')
  return filter(map(items, 's:make_info(v:val)'), 'len(v:val) == 5')
endfunction

function! s:make_info(item) abort
  let info = {}
  for c in filter(a:item.child, 'type(v:val) == 4')
    if c.name ==# 'title'
      let info.title = c.value()
    elseif c.name ==# 'description'
      let info.note = s:parse_description('<html>' . c.value() . '</html>')
    elseif c.name ==# 'pubDate'
      let info.pubDate = c.value()
    elseif c.name ==# 'itunes:summary'
      let info.summary = c.value()
    elseif c.name ==# 'enclosure'
      let info.enclosure = substitute(c.attr.url, '^https', 'http', '')
    endif
  endfor
  return info
endfunction

function! s:parse_description(xml) abort
  let lis = s:List.flatten(map(s:XML.parse(a:xml).childNodes('ul'), 'v:val.childNodes("li")'), 1)
  return map(map(filter(lis, '!empty(v:val.child) && type(v:val.child[0]) == 4'), 'v:val.child[0]'), '{
        \ "href": has_key(v:val.attr, "href") ? v:val.attr.href : "",
        \ "text": v:val.value()
        \}')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
