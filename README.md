## My NeoVim configs

### About

<p>This repository contains my personal NeoVim configurations, focused on providing a modern, complete, and highly customizable development environment. Although it's just a backup of my workflow and not a distribution, I’m sharing it for anyone who wishes to copy or use it as a reference</p>

<p align="center">
<img src="https://github.com/leandrofmoraes/neovim-configs/blob/master/.screenshots/leovim_01.png" align="right" width="400px">
</p>

### Contents

1. <a href="https://github.com/leandrofmoraes/neovim-configs#features" target="_blank">Features</a>
2. <a href="https://github.com/leandrofmoraes/neovim-configs#dependencies" target="_blank">Dependencies</a>
3. <a href="https://github.com/leandrofmoraes/neovim-configs#how-to-install-" target="_blank">Installation</a>
4. <a href="https://github.com/leandrofmoraes/neovim-configs#more-screenshots" target="_blank">Screenshots</a>
5. <a href="https://github.com/leandrofmoraes/neovim-configs#notes" target="_blank">Notes</a>

### Features.

- Customized [Tokyonight](https://github.com/folke/tokyonight.nvim) colorscheme
- Personalized lualine sessions
- Organized plugins and settings by files and directories
- Plugin management with [lazy.nvim](https://github.com/folke/lazy.nvim)
- LSP clients configured via [lspconfig](https://github.com/neovim/nvim-lspconfig)
- Autocompletion using either [blink.cmp](https://cmp.saghen.dev/) or [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- AI Assistance with [Copilot](https://github.com/zbirenbaum/copilot.lua) and [Tabnine](https://github.com/tzachar/cmp-tabnine)
- Complete IDE experience for Java, C/C++, Lua, JavaScript, and more
- Debugging with [nvim-dap](https://github.com/mfussenegger/nvim-dap) integration and pre-configured debug adapters
- File explorer integration with either [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) or [snacks explorer](https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md)

### Dependencies.

- git > To install the config and plugins
- [Nerd Fonts](https://www.nerdfonts.com/) > Used to display icons
- npm > Used to install certain mason packages
- [ripgrep](https://github.com/BurntSushi/ripgrep) > Used to give telescope results
- [Find file](https://github.com/sharkdp/fd) > Used in telescope to search for files

### How to Install ?

- Open your favorite terminal emulator, copy and paste this command.

```bash
git clone https://github.com/leandrofmoraes/neovim-configs.git ~/.config/nvim && nvim
```

### More Screenshots

| Running a Spring boot project using ToggleTerm plugin                                               | Editing a Lua file                                                                                  |
| --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| ![img](https://github.com/leandrofmoraes/neovim-configs/blob/master/.screenshots/Screenshot_01.png) | ![img](https://github.com/leandrofmoraes/neovim-configs/blob/master/.screenshots/Screenshot_02.png) |
