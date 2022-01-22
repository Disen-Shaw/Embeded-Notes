# Neovim Lua 基本设置

## vim - lua 配置中的一些内部变量

- vim.g.{name}：全局变量
- vim.b.{name}：缓冲区变量
- vim.w.{name}：窗口变量
- vim.t.{name}：选项卡变量
- vim.v.{name}：预定义变量

删除变量只需要将之设置为 `nil`

```lua
vim.g.some_global_variable = nil
```

## 映射定义

Neovim 提供了一系列 api 函数来设置获取和删除映射

### 全局映射

- vim.api.nvim_set_keymap()
- vim.api.nvim_get_keymap()
- vim.api.nvim_del_keymap()

### 缓冲区映射

- vim.api.nvim_buf_set_keymap()
- vim.api.nvim_buf_get_keymap()
- vim.api.nvim_buf_del_keymap()

### 映射函数说明

传递给函数的 **第一个参数** 是一个包含映射生效模式名称的字符串

| 字符串                 | 帮助页面        | 影响到的模式                                   | 在 [Vimscripts](../Vimscripts/Vim_基本设置.md) 中的映射 |
| ------------------- | ----------- | ---------------------------------------- | ---------------------------------------------- |
| `''` (Empty String) | mapmode-nvo | Normal, Visual, Select, Operator-pending | :map                                           |
| `n`                 | mapmode-n   | Normal                                   | :nmap                                          |
| `v`                 | mapmode-v   | Visual and Select                        | :vmap                                          |
| `s`                 | mapmode-s   | Select                                   | :smap                                          |
| `x`                 | mapmode-x   | Visual                                   | :xmap                                          |
| `o`                 | mapmode-o   | Operator-pending                         | :omap                                          |
| `!`                 | mapmode-!   | Insert and Command-line                  | :map!                                          |
| `i`                 | mapmode-i   | Insert                                   | :imap                                          |
| `l`                 | mapmode-l   | Insert, Command-line, Lang-Arg           | :lmap                                          |
| `c`                 | mapmode-c   | Command-line                             | :cmap                                          |
| `t`                 | mapmode-t   | Terminal                                 | :tmap                                          |

传递给函数的 **第二个参数** 是包含映射左侧的字符串(要映射的快捷键)，空字符串 相当于 `<Nop>`\
第三个参数是 **要映射的命令**\
最后一个参数是 **一个表** 包含 `:help map-argumant` 中定义的映射布尔值选项
