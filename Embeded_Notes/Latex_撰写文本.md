# $\LaTeX$撰写文本
## 标题目录
要生成文章的标题栏，可以用下面几个命令
```tex
\title{文章标题}
\author{作者姓名}
\date{写作日期}
\maketitle
```
其中 `\date` 命令的参数为空时将不显示日期，而 `\date` 命令省略时将使用当前日期

文章的目录可以使用 `\tableofcontents` 命令生成

## 定理环境
在 $\LaTeX$ 中很容易编写自动编号的定理  
首先在导言区中写上
```tex
\newtheorem{theorem}{定理}  
\newtheorem{corollary}{推论}
```

然后在正文区中写上左侧的代码就得到右侧的结果

```tex
\begin{theorem}
定理内容
\end{theorem}

\begin{corollary}
定理推论
\end{corollary}
```

**用 `\begin{名称}` 和 `\end{名称}` 包含的内容称为一个环境**

## 制作表格
利用 `tabular` 环境，可以制作表格  
其中 `|l|ccc|` 中的 l 表示第一列左对齐，后面的三个 c 表示后面三列居中对齐

```tex
\begin{tabular}{|l|ccc|}
\hline
数学家 & 费马 & 欧拉 & 高斯 \\
\hline
年份 &1601 & 1707 & 1777 \\
\hline
\end{tabular}
```