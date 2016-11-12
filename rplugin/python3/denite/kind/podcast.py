"""
FILE: podcast.vim
AUTHOR: koturn <jeak.koutan.apple@gmail.com>
DESCRIPTION: {{{
Podcast player for Vim.
This file is a extension for denite.vim and provides denite-kind.
denite.nvim: https://github.com/Shougo/denite.nvim
}}}
"""

from .base import Base


class Kind(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'podcast'
        self.default_action = 'podcast'

    def action_podcast(self, context):
        self.vim.call('podcast#play', context['targets'][0])
