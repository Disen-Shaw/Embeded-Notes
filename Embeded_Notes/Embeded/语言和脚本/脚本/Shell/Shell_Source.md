# Shell_Source

[Source](https://www.bilibili.com/video/BV19t411s7Jx?p=9&spm_id_from=pageDriver)

## Shell 基础

### shell 基本介绍

Shell 是一个用 [C语言](../../编程语言/C系语言/C语言/C_Source.md) 编写的解释性语言，它是用户使用 [Linux](../../../嵌入式系统/操作系统/Linux/Linux_Source.md) 的桥梁。\
Shell **既是一种命令语言，又是一种程序设计语言**

Shell 是指一种应用程序，这个应用程序提供了一个界面，用户通过这个界面 **访问操作系统内核** 的服务

### Shell 脚本

Shell 脚本（shell script），是一种为 shell 编写的脚本程序\
业界所说的 shell 通常都是指 shell 脚本，但是 shell 和 shell script 是两个不同的概念

## Shell 脚本用途

- 自动化批量系统初始化

- 自动化批量软件部署

- 管理应用程序

- 日志分析处理程序

- 自动化备份恢复程序

- 自动化信息采集监控程序

## Shell 脚本的基本知识

### 第一个 shell 脚本

```shell
#!/bin/sh
echo "hello world"
```

输出 `hello world` 字符串

`#!` 一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，使用哪一种 Shell

### Shell 脚本的两种形态

1. 作为可执行程序
   ```shell
   ./main.sh
   ```
2. 作为解释器参数
   ```shell
   sh main.sh
   ```

## 登陆 shell 与 非登陆 shell

语法有一些区别：

```shell
# 登陆shell
su - 用户名
# 非登陆shell
su 用户名
```

### 登陆 shell

- /etc/profile
- /etc/bashrc
- ~/.bash_profile
- ~/.bashrc

### 非登陆shell

- /etc/bashrc
- ./bashrc

## GNU/Bash Shell 特点

### 命令和历史功能

- 上下键查找 shell 历史
- !number：之前执行的 number 个命令
- !string：上个执行的 `string` 开头的命令
- !!：上一条命令

### 别名功能

- alias：重命名和查看别名
- unalias：取消别名

## Shell 基本内容

[Shell_通配符与正则表达式](Shell_通配符与正则表达式.md)\
[Shell_变量](Shell_变量.md)\
[Shell_传参](Shell_传参.md)\
[Shell_运算符](Shell_运算符.md)
