# 插图和表格
## 插图
### 前提条件

进行插图前需要引入插图宏包\
`\usepackage{graphicx}`

#### 支持格式

+ EPS
+ PDF
+ PNG
+ JPEG
+ BMP

### 语法

`\graphicspath{{figures/}}` 图片在当前目录下的 `figures` 目录，可以多路径，大括号内用逗号隔开\
`\includegraphics[<选项>]{<文件名>}`

#### 可选参数
+ [scale=0.3]{xxx}：
+ [height=2cm]{xxx}：高度两厘米
	+ [height=0.1\\textheight]{xxx}：版型文字0.1倍的图片高度
+ [width=2cm]{xxx}：宽度两厘米
	+ [width=0.2\\textwidth]{xxx}：版型文字0.2倍的图片宽度
+ [angle=45]：45度旋转

不同参数可以同时使用，使用逗号分割

## 表格

### 书写格式

```latex
\begin{tabular}{l|c|c|r}
	\hline
	第一列 & 第二列 & 第三列 & 第四列 \\
	\hline
	值1   & 值2   & 值三   & 值四
\end{tabular}
```

其中，`l c c r` 分别表示左对齐，居中对齐，居中对齐，右对齐\
另外 `p` 可以规定表格宽度 `p{1.5cm}`




