# Git 开始使用

## 初次运行前 GIT 的配置

Git  自带一个 `git config` 的工具来设置  Git  的外观和行为的配置变量，这些变量存储在三个不同的位置

- `/etc/gitconfig`：包含系统上每一个用户及他们仓库的 **通用配置**，
  - 如果在执行 `git config` 时带上 `--system` 选项，那么它就会读写该文件中的配置变量

- `~/.gitconfig` 或 `~/.config/git/config` 文件：只针对当前用户
  - 可以传递 `--global` 选项让 Git 读写此文件，这会对本用户系统上 **所有** 的仓库生效

- 当前使用仓库的 Git 目录中的 `config` 文件（即 `.git/config`）：针对该仓库
  - 可以传递 `--local` 选项让 Git 强制读写此文件

每一个级别会覆盖上一个级别的配置，即 `.git/config` 的配置变量会覆盖 `/etc/gitconfig` 中的配置变量

### 设置用户信息

安装  Git  之后，要做的第一件事是设置 **用户名** 和 **邮件地址**，每一个  Git  提交都会使用这些信息，这些信息会写入每一次提交中，不可以更改

```shell
git config --global user.name "Disen Shaw"
git config --global user.email shaodisheng1314@gmail.com
```

当想要对特定项目使用不同的用户名称与邮件地址时\
可以在那个项目目录下运行没有 `--global` 选项的命令来配置

### 文本编辑器

当 Git 需要你输入信息时会调用它，如果未配置，Git 会使用操作系统默认的文本编辑器

```shell
git config --global core.editor nvim
```

### 检查配置信息

如果想要检查配置，可以使用

```shell
git config --list
```

也可以使用 `git config <key>` 来查询 Git 的某一项配置

```shell
git config user.name 
```
