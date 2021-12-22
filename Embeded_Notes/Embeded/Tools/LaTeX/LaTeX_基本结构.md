# 文章结构

## 文章基本结构

```tex
% 导言区
\documentclass{article} %book, report, letter

% 正文区（文稿区）
\begin{document}

\end{document}
```

- 一个 $\LaTeX$ 文件只能有一个 `document`
- "%" 后面的为注释，不参与编译和输出
- 正文段与段之间使用空行表示

导言区主要用于设置一些全局命令，例如

| 命令            | 说明     |   
| ------------- | ------ | 
| \title{标题}    | 设置文章标题 |   
| \author{作者}   | 文章的作者  |   
| \date{\today} | 文章的时间  |  

为了输出标题等信息，需要在正文中输入 `\maketitle` 命令\
`letter` 文件格式没有 `title` 这个结构

用 `$内容$(行内)` 和 `$$内容$$(行间)` 包围的内容为 <u>数学模式</u>

## 自体字号设置

### 字体属性

在 $\LaTeX$ 中，文字总共有五种属性

- 自体编码
	- 正文自体编码：OT1、T1、EU1等
	- 数字自体编码：OML、OMS、OMX等
- 字体族
	- 罗马字体
	- 无衬线字体
	- 打字机字体
- 自体系列
	- 粗细
	- 宽度
- 自体形状
	- 直立
	- 斜体
	- 伪斜体
	- 小型大写
- 自体大小

### 字体设置

可以通过 `命令` 和 `声明` 进行设置，字体大小可以在{article}前面加放括号设置参数

```tex
\documentclass[12pt]{article}
\zihao{字号} 内容				% 设置中文字号大小
```

默认12磅字体(只有10、11、12磅)

- 字体族设置： 用 {} 可以设置作用域，声明需要在大括号内
	- 罗马字体
		- 设置：`\textrm`
		- 声明：`\rmfamily`
	- 无衬线字体：
		- 设置：`\textsf`
		- 声明：`sffamily`
	- 打字机字体：
		- 设置：`\texttt`
		- 声明：`ttfamily`
- 字体系列设置：
	- 中等：
		- 设置：`\textmd`
		- 声明：`mdseries`
	- 粗体：
		- 设置 `\textbf`
		- 声明：`\bfseries`
- 字体形状
	- 直立文本：`\textup` -- `\upshape`
	- 意大利斜体：`\textit` -- `\itshape`
	- 伪斜体：`\textsl` -- `slshape`
	- 小体大写文本：`\textsc` -- `scshape`

### 中文字体

- 宋体：`{\songti 宋体}`
- 仿宋体：`{\fangsong 仿宋体}`
- 楷书：`{\kaishu 楷书}`
- 黑体：`{\quad 黑体}`

