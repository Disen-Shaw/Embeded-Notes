# LaTeX
## 解决问题
+ [在线手册](https://texdoc.net)
+ [英文社区](http://tex.stackexchange.com)
+ 中文社区 LaTeX工作室

## 组织文档结构
### 文档组成
+ 标题
+ 前言/摘要
+ 目录
+ 正文
	+ 篇、章、节、小节、小段
		+ 文字、公式
		+ 列表：编号的、不编号的、带小标题的
		+ 定理：引理、命题、证明、结论
		+ 诗歌、引文、程序代码、算法伪码
		+ 画图
+ 文献
+ 索引、词汇表

Latex支持结构化的文档编写方式，只有具有良好的结构的文档才适合使用Latex编写

### 编写文档步骤

+ 拟定主题
+ 列出提纲
+ 填写内容
+ 不太在意格式

### 文档基本结构
以 `document` 环境为界， `document`
+ 环境前是导言部分(preamble)
+ 环境内部是正文部分
+ 环境之后的部分被忽略

在导言区进行格式设置，正文部分套用格式

```tex
%%% 简单文档：
% 导言：格式设置
\documentclass[b5paper]{geomtry}
% 正文：填写内容
\begin{document}
使用 \LaTeX
\end{document}
```

## 文档部件
+ 标题：\\title,\\author,\\date ---- \maketitle
+ 摘要/前言：abstract环境 /\\chapter\*
+ 目录：\\tableofcontents
+ 章节：\\chapter,\\section, ...
+ 附录：\\appendix + \\chapter 或 \\section
+ 文献：\\bibliography
+ 索引：\\printindex

## 文档划分
+ 大型文档\\frontmatter、\\mainmatter、\\backmatter
+ 一般文档：\\appendix

| 层次 | 名称         | 命令           | 说明                                    |
| ---- | ------------ | -------------- | --------------------------------------- |
| -1   | part         | \\part         | 可选的最高层                            |
| 0    | chapter      | \\chapter      | report，book类最高层                    |
| 1    | section      | \\section      | article类最高层                         |
| 2    | subsection   | \\subection    |                                         |
| 3    | subsubection | \\subsubection | report，book类</br>默认不编号、不编目录 |
| 4    | paragraph    | \\paragraph    | 默认不编号、不编目录                    |
| 5    | subparagraph | \\subparagraph | 默认不编号、不编目录                    | 

## 磁盘文件组织
小文档将所有内容写在同一个目录中  
对比较大的文档，可以将文档分成多个文件并划分文件目录结构：
+ 主文档，给出文档框架结构
+ 按内容章节划分不同文件
+ 使用单独的类文件和格式文件设置格式
+ 用小文件隔离复杂的图表

### 相关命令
\\documentclass：读入文档类文件(.cls)
\\usepackage：读入一个格式文件——宏包
\\include：分页，并读入章节文件
\\input：读入任意文件


