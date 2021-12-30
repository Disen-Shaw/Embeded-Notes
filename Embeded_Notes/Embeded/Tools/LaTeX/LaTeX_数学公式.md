# 数学公式

## 数学公式

$\LaTeX$ 中的数学公式分为 `文本模式` 和 `数学模式` \
文本模式适用于普通的文本内的数学公式排版，数学模式适用于数学公式的排版

## 行内公式

有以下两种格式

+ `$公式$`
+ `\(公式)`

### 数学环境排版

```latex
\begin{math}
	数学公式
\end{math}
```

## 行间公式

+ 使用 `$$公式$$` 来排版行间公式
+ 使用 `\[公式]` 排版行间公式

### 数学环境排版

```latex
\begin{displaymath}

\end{displaymath}
```


如果要对公式进行排版，需要使用 `equation` 进行排版( 需要使用`amsmath`宏包 )

```latex
\begin{equation}
\end{equation}
% 如果不需要编号，使用
\begin{equation*}
\end{equation*}
```


排版的数学公式置于以上描述的环境或者特殊符号内



## 数学公式
### 上下标

+ 上标：`^`
+ 下标：`-`
+ 乘号：`\times`

多字符的上下标文本需要加{}

### 希腊字母

具体查看 [Markdown](../Markdown.md)

### 矩阵排版
矩阵排版属于行间数学公式，使用 

```latex
\[
	\begin{matrix}
		1 & 2 \\
		3 & 4
	\end{matrix}
\]
```

具体格式查看 [Markdown](../Markdown.md)，行内矩阵使用 `smallmatrix`


## 多行公式

$\LaTeX$ 中的多行公式，需要使用 `amsmath` 和 `amssymb`

```latex
\begin{gather}
\end{gather}
```

可以实现公式的多行排版，并且每一行都有编号，如果不需要编号，可以

+ 使用 `gather*` 环境内的公式都不编号
+ 使用 `\notag` 规定某行不进行编号

使用 `align` 可以对公式进行对齐，在行内使用 `&` 进行对齐\
使用 `cases` 对多行公式进行对其，例如

```latex
$$
\begin{equation}
f(x)=
	\begin{cases}
		x^2+1 \\
		2x+1
	\end{cases}
\end{equation}
$$
```