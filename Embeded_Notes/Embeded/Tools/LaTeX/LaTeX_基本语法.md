# 基本语法

## 常用的关键字

- `\begin`：布置语句块
- `\documentclass`： 设置文章的类型
- `\usepackage`：导入使用包
- `\newcommand`：定义新的命令
- `\par `：产生新的段落
- `\quad`：类似于制表符
- `\chapter`：章节
- `\tableofcontents`：产生目录
- 
- 

## 复杂应用

### 自定义新的命令

```tex
\newcommand\degree(命令名){^\circ}(命令内容)
```

## 环境

### equation 环境

用于自动生成行间号

```tex
\begin{equation}
	AB^2 = BC^2 + AC^2
\end{equation}
```

![自动生成行间号](../../../pictures/Pasted%20image%2020211218220400.png)


