# LaTex的大致使用方法
## 第一篇文章 Hello，world
```latex
\documentclass{article}
% 这里是导言区
\begin{document}
Hello, world!
\end{document}
```

### 分析
第一行"\documentclass{article}"包含了一个控制序列

控制序列是以'\'为开头，以第一个空格或者非字母结束的一串文字

它们并不会被输出，但是会影响文档的输出结果
这里的控制序列是\documentclass，后面紧跟的{article}是控制序列有一个必要的参数，改参数的值是 article ，这个控制序列的作用是调用名为 article 的文档类

其后面出现的控制序列`\begin`，这个控制序列总与`\end`成对出现

这两个控制序列以及它们中间的内容被称为 环境 
它们之后的第一个必要参数总是一致的，被称为环境名

`\begin` 和 `\documentclass` 之间的部分称为导言区

**导言区的控制序列通常会影响到整个文档的输出**



### 中英混排

`class`后面加上**ctex**的宏包，并且加上[UTF-8]文档选项

```latex
\documentclass[UTF-8]{ctexart}
\begin{document}
你好，world
\end{document}
```

## LaTeX语法格式

```latex
\documentclass[options]{class}
\begin{document}
% 录入正文内容
\end{document}
```

+ options：定制文档类的属性，不同的选项之间要用逗号隔开
+ class：指定文档类型，如book、report、article、letter等

### 注释

LaTeX有注释

+ 单行：以%开头，是单行注释
+ 多行：需要用到多行注释的包 \usepackage{verbatim}
  + \begin{comment}
    + 多行注释内容
  + \end{comment}

例如：

```latex
\documentclass{article}
\usepackage[UTF8]{ctex}
\usepackage{verbatim}
\begin{comment}
这是一段注释
\end{comment}
\begin{document}
	hello,world
\end{document}
```

### 换行、分段、分页

#### 换行

\\\\ ：换到下一行

\\newline也是换到下一行

这里的换行都是段内的换行

#### 分段

\\par：添加在段落末尾或另起一行做分段

**在分段后面敲两个回车**

#### 分页

\\newpage

添加在段落末尾或另起一行进行分页

实例：

```latex
%! Tex program = xelatex
\documentclass{article}
\usepackage[UTF8]{ctex}
\usepackage{verbatim}
\begin{document}
%换行
三更\\灯火五更鸡，


正是男儿读书时。\par
\noindent 黑发不知勤学早，\newpage

白首方悔读书迟。
\end{document}
```

## 文字的粗体、斜体、颜色、大小

