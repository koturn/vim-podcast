"""
FILE: podcast.vim
AUTHOR: koturn <jeak.koutan.apple@gmail.com>
DESCRIPTION: {{{
Podcast player for Vim.
This file is a extension for denite.nvim and provides denite-source.
denite.nvim: https://github.com/Shougo/denite.nvim
}}}
"""

from .base import Base


class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'podcast'
        self.kind = 'podcast'

    def gather_candidates(self, context):
        names = self.vim.call('podcast#get_channel_names') if len(context['args']) == 0 else context['args']
        candidates = []
        for name in names:
            items = self.vim.call('podcast#get_items', name)
            for item in items:
                item['word'] = item['title'] + ' [' + name + ']'
            candidates += items
        return candidates
