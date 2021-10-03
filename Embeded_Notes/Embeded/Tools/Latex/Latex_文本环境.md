# $\LaTeX$文本环境
## 环境
在 $\LaTeX$ 中，用 `\begin` 和 `\end` 包含起来的特殊段落称之为环境，不同的环境的内容将采用不同的发那个时来排版在文本段落中，常见的环境有列表环境，对齐环境和定理环境等

## 列表环境
列表环境有三种
+ 无序列表
+ 有序列表
+ 描述列表

它们的使用分别如   

**无编号列表**
```tex
\begin{itemize}
\item	无编号的列表1
\item	无编号的列表2
\end{itemize}
```

**有编号列表**
```tex
\begin{enumerate}
\item	[列表序号]	无编号的列表
\item	[列表序号]	带编号的列表
\end{enumerate}
```
**描述列表**
```tex
\begin{description}
\item[] 无编号的列表
\item[] 有编号的列表
\end{description}

```

## 居中对齐
默认情形，文章段落都是两侧对齐的，但我们也可以排版居中对齐和单侧对齐的段落在 $\LaTeX$ 中，可以用 `center` 环境得到居中的文本段落，其中可以用 `\\` 换行
```tex
\begin{center}
居中对齐的文本
居中对齐的文本
居中对齐的文本
\end{center}
```

如果居中段落在一行放不下，只会在最后一行是居中的，其它行都填  
满页面宽度．在一个环境内部，用命令 `\centering` 也可以让后面的文本都居中放置

## 向左对齐
可以用 `flushleft` 环境得到向左对齐的文本段落
```tex
\begin{flushleft}
The quick brown fox jumps over the lazy dog.  
The quick brown fox jumps over the lazy dog.  
The quick brown fox jumps over the lazy dog.  
The quick brown fox jumps over the lazy dog.
\end{flushleft}
```
在一个环境内部，用 `\raggedright` 声明同样可以让文本  
向左对齐


## 向右对齐
可以使用 `flushright` 环境得到向右对齐的文本段落  
```tex
\begin{flushright}  
The quick brown fox jumps over the lazy dog.  
The quick brown fox jumps over the lazy dog.  
The quick brown fox jumps over the lazy dog.  
The quick brown fox jumps over the lazy dog.  
\end{flushright}
```

在一个环境内部，用 `\raggedleft` 声明同样可以让文本向  
右对齐


## 定理环境
定理命题的撰写例子

```tex
\newtheorem{dingli}{Theorem}  
\newtheorem{tuilun}{Corollary}  
\begin{dingli}  
This is a theorem.  
\end{dingli}  
\begin{tuilun}  
This is a corollary.  
\end{tuilun}
```
Theorem 和 Corollary 内容可以被其他内容替代

## 定理编号
若想要定理和推论一起标号，可以这样使用
```tex
\newtheorem{thrm}{Theorem}  
\newtheorem{corl}[thrm]{Corollary}  
\begin{thrm}  
This is a theorem.  
\end{thrm}  
\begin{corl}  
This is a corollary.  
\end{corl}
```

如果希望新的一节重新开始定理的编号，可以
```tex
\newtheorem{thm}{Theorem}[section]  
\begin{thm}  
This is another theorem.  
\end{thm}  
\renewcommand{\thethm}{\arabic{section}-\arabic{thm}}  
\begin{thm}  
This is another theorem.  
\end{thm}
```
![Pasted image 20210909083427](../../../pictures/Pasted%20image%2020210909083427.png)

## 抄录环境
$\LaTeX$ 中有一些特殊字符不能直接输入，如果要排版程序代码就不那么方便，可以使用 `verbatim` 环境

### 抄录命令
类似地还有个抄录命令 `\verb` 用于简短的抄录文本  
 `\verb` 命令的参数必须用两个相同的符号包含起来，不能用花  
括号包含参数

