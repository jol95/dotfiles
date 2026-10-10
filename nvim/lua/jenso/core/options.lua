-- Leader must be set before any mapping that uses it
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.opt
o.number = true
o.relativenumber = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.signcolumn = "yes"
o.scrolloff = 8
o.termguicolors = true
o.clipboard = "unnamedplus"
