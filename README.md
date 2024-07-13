## My NeoVim configs

### About
<p>This repository contains personal settings, which I use in neovim. In addition to paying special attention to appearance and usability, the main objective is to have a centralized configuration, easier to maintain and control, moving away a little (but not completely) from the encapsulation of distributions.</p>

<p align="center">
<img src="https://github.com/leandrofmoraes/neovim-configs/blob/master/.screenshots/leovim_01.png" align="right" width="400px">
</p>

### Contents
1. <a href="https://github.com/leandrofmoraes/neovim-configs#features" target="_blank">Features</a>
2. <a href="https://github.com/leandrofmoraes/neovim-configs#dependencies" target="_blank">Dependencies</a>
3. <a href="https://github.com/leandrofmoraes/neovim-configs#how-to-install-" target="_blank">Installation</a>
4. <a href="https://github.com/leandrofmoraes/neovim-configs#more-screenshots" target="_blank">Screenshots</a>
5. <a href="https://github.com/leandrofmoraes/neovim-configs#notes" target="_blank">Notes</a>
</p>

### Features.
- Customized [Tokyonight](https://github.com/folke/tokyonight.nvim) colorscheme
- Fast search for files and preview using [telescope](https://github.com/nvim-telescope/telescope.nvim) plugin
- Browse for references and diagnostics using LSP and [trouble-nvim](https://github.com/folke/trouble.nvim)
- Customized lualine sessions
- Modules leveraged from [LazyVim](https://github.com/LazyVim/LazyVim)
- Centralized plugin configuration
- Complete IDE for Java, C/C++, Lua and Web development (HTML, CSS, JS, TS)

#####

### Dependencies.

- git > To install the config and plugins
- [Nerd Fonts](https://www.nerdfonts.com/) > Used to display icons
- npm > Used to install certain mason packages
- [ripgrep](https://github.com/BurntSushi/ripgrep) > Used to give telescope results
- [Find file](https://github.com/sharkdp/fd) > Used in telescope to search for files
- [Ranger](https://github.com/ranger/ranger) > Used as a file explorer (optional)

### How to Install ?

- From your $HOME directory, copy and paste the command.
```bash
git clone https://github.com/leandrofmoraes/neovim-configs.git ~/.config/nvim && nvim
```

### More Screenshots

| Running a Spring boot project using ToggleTerm plugin | Editing a Lua file
|-|-|
|![img](https://github.com/leandrofmoraes/neovim-configs/blob/master/.screenshots/Screenshot_01.png)|![img](https://github.com/leandrofmoraes/neovim-configs/blob/master/.screenshots/Screenshot_02.png)

#### Notes
Other repositories were used as references and deserve to be cited.
- [J4de/nvim:](https://codeberg.org/j4de/nvim)
- [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public)
- [LunarVim](https://github.com/LunarVim/LunarVim)
- [LazyVim](https://github.com/LazyVim/LazyVim)
