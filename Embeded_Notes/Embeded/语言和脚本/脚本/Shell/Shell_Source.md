# Shell_Source

## Shell

### shell 基本介绍

Shell 是一个用 [C语言](../../编程语言/C/C语言/C_Source.md) 编写的程序，它是用户使用 [Linux_Source](../../../嵌入式系统/操作系统/Linux/Linux_Source.md) 的桥梁。\
Shell **既是一种命令语言，又是一种程序设计语言**

Shell 是指一种应用程序，这个应用程序提供了一个界面，用户通过这个界面 **访问操作系统内核** 的服务

### Shell 脚本

Shell 脚本（shell script），是一种为 shell 编写的脚本程序\
业界所说的 shell 通常都是指 shell 脚本，但是 shell 和 shell script 是两个不同的概念

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

## Shell 脚本
[Shell_变量](Shell_变量.md)\
[Shell_传参](Shell_传参.md)\
[Shell_运算符](Shell_运算符.md)