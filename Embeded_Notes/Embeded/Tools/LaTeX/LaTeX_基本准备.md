# 基本准备

安装 $\LaTeX$ 相关的软件，并且配置好环境\
[Linux](../../嵌入式系统/操作系统/Linux/Linux_Source.md) 安装后会自动将可执行文件添加到路径中

### 查看是否安装成功

在终端中执行

```shell
tex -v
latex -v
xelatex -v
```

查看是否正确输出信息，如果正确输出信息，则表示安装成功

### 初步编写测试

编写代码如下(简单的 hello world 程序)

```tex
\documentclass{article}
\begin{document}
	Hello World
\end{document}
```

documentclass：表示文章类型

执行 `latex x.tex` 进行编译，生成 `.dvi` 后缀的文件\
然后使用 `dvipdfmx` 将该文件转化为 `.pdf` 后缀的文件，即生成PDF文件完成

### 其他编译方式

使用 `xelatex` 直接进行编译，会直接生成 PDF 文件

##  中文处理方式

### 构建要求

- 构建命令：xelatex
- 默认字体编码：UTF-8

### CTEX

在 `导言区` 中加入

```tex
\usepackage{ctex}
```

将相应的内容改为中文，<u>并且要自体支持</u>


