# 特殊字符
## 特殊字符规则
+ 空行分段，多个空行等同为一个
+ 自动缩进不能代替空格使用
+ 英文中有多个空格处理为一个空格，在中文中空格将会被忽略
+ 汉字与其他字符之间的间距会自动由 `xelatex` 处理
+ 禁止使用中文全角空格

## 文本中的特殊字符

### 定长空格

+ `\quad` ：1em(当前字体M总的宽度)
+ `\qquad`：2em
+ `\thinspace`：约 $\cfrac{1}{6}$ 个 em
+ `\enspace`：0.5em空白
+ `、 `：反斜杠加空格产生一个空格
+ `a~b`：硬空格

### 自定长空格

+ `a\kern 1pc b`：1pc=12pt=4.128mm
+ `a\kern -1em b`
+ `a\hsskip 1em b`
+ `a\hspace{35pt}b`

#### 占位宽度

+ `a\hphantom{xyz}b`

#### 弹性长度

+ `a\hfill b`

## 其他
在 $\LaTeX$ 中 `#，￥，%，&，{}` 不能直接打出，需要使用反斜杠

另外排版字符
+ `\S`
+ `\P`
+ `\dag`
+ `\ddag`
+ `\copyright`
+ `\pounds`

$\LaTeX$ 中的标志符号

+ $\TeX$：`\TeX`
+ $\LaTeX$：`\LaTeX`
+ `$\LaTeXe$`

### 引号
+ \`：表示左单引号
+ \'：表示右单引号
+ \`\`：表示左双引号
+ \'\'：表示右双引号

### 连字符

+ `-`：短连字符
+ `--`：中连字符
+ `---`：长连字符

### 非英文字符

`\oe \OE \ae \AE \aa \AA \o \O \l \L \ss \SS ! ?`

### 重音符号

```latex
\`o \'o \^o \``o \~o \u{o} \v{o} \H{o} \r{o} \t{o} \b{o} \c{o} \d{o}
```

## 其他特殊字符的宏包
+ `\usepackage{xltxtra}`
+ `\usepackage{texname}`
+ `usepackage{mflogo}`
