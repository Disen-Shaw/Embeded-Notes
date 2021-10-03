# $\LaTeX$ 文本盒子
在 $\TeX$ 排版中，所有内容都会被转换为嵌套的盒子．每个字符是一个盒子，多个字符盒子组成一个行盒子，而多个行盒子组成一个页盒子、

![Pasted image 20210909084233](../../../pictures/Pasted%20image%2020210909084233.png)

每个盒子有三个尺寸：宽度(Width)、高度(height)和深度(depth)


## 左右盒子
左右盒子是最简单的盒子，它包括 `\mbox` 和 `\fbox`
```tex
正文\mbox{盒子}正文\fbox{盒子}正文
```
可以看出两者的区别在于后者带有边框
对应的还有另外两种左右盒子 `\makebox` 和 `\framebox`，它们提供更多的选项，比如可以指定盒子的宽度

用 `\makebox` 和 `\framebox` 生成盒子时还可以指定盒子中文本的对齐方式
```tex
正文\makebox[10em][l]{靠左对齐}正文\\  
正文\framebox[10em][l]{靠左对齐}正文\\  
正文\makebox[10em][c]{居中对齐}正文\\  
正文\framebox[10em][c]{居中对齐}正文\\  
正文\makebox[10em][r]{靠右对齐}正文\\  
正文\framebox[10em][r]{靠右对齐}正文
```

用 `\makebox` 和 `\framebox` 生成盒子时还可以指定盒子中文本的对齐方式
```tex
正文\makebox[10em][s]{分散对齐}正文\\  
正文\framebox[10em][s]{分散对齐}正文\\  
正文\makebox[10em][s]{A Lazy Dog}正文\\  
正文\framebox[10em][s]{A Lazy Dog}正文
```
s 表示分散对齐．使用分散对齐选项时，对中文以汉字为单位分散，而对于西文则以单词为单位分散

在定义 `\makebox` 和 `\framebox` 的宽度时，我们可以用 `\width`、`\height`、`\depth` 和 `\totalheight` 这些长度量
它们分别表示盒子内容的宽度、高度、深度和总高度（即高度和深度之和）．比如下  面例子设定盒子的宽度等于内容宽度的三倍：
```tex
正文\framebox[3\width]{盒子}正文
```

对于带框盒子 `\fbox` 和 `\framebox`，我们可以用 `\fboxsep` 调整边框和内容之间的距离，用 `\fboxrule` 调整框线的宽度  
两者的默认值分别为 3pt 和 0.4pt

## 段落盒子
左右盒子中不能包含多行文本或者段落．此时我们可以改用 `\parbox` 命令或者 `minipage` 环境
```tex
Left\parbox{3em}{One\\ Two\\ Three}Right  
\hfill  
Left\begin{minipage}{6em}  
One\\ Two\\ Three  
\end{minipage}Right
```
其中必须指定盒子宽度．两者的用法和参数都一样，只是在 `\parbox` 中不能包含某些命令或环境，而 `minipage` 中的内容几乎没有限制

![Pasted image 20210909090241](../../../pictures/Pasted%20image%2020210909090241.png)

`\parbox` 和 `minipage` 都不含边框，但我们可以将它们放在 `\fbox`  中得到边框
```tex
Left\fbox{\begin{minipage}{6em}  
One\\ Two\\ Three  
\end{minipage}}Right
```
段落盒子有三个可选参数
+ 第一个设定段落盒子和两边内容的对齐
	+ \[t] 左右文本和盒子最上面的文本对齐
	+ \[c] 左右文本和盒子中间的文本对齐
	+ \[b] 左右文本和盒子最下面的文本对齐 

+ 第二个可选参数用于设定段落盒子的高度
+ 第三个可选参数用于设定段落盒子内部的纵向对齐方式
	+ \[c] 居中对齐
	+ \[t] 顶端对齐
	+ \[b] 底段对齐

## 标尺盒子
$\LaTeX$ 中还提供了 `\rule` 命令，用于生成标尺盒子，即不含内容的 实心矩形盒子

```tex
Left \rule{3pt}{14pt} Right
```

其中 `\rule` 命令的两个参数分别表示宽度和高度

宽度为零的标尺盒子虽然无法看到，但可以起到支撑的作用，称之为支架(struct)

由于小写a和大写A的高度不同，但是加入支架后两个盒子的高度就相同了

标尺盒子默认与该行的基线平行，通过设定 \rule 命令的可选参数，可以升高或降低其水平位置


## 幻影盒子
$\LaTeX$中还有一种幻影盒子，他们的内容看不到，但是内容所占据的空间保持不变，幻影盒子可以用 `\phantom` 命令得到

```tex
正文\phantom{幻影}正文
```

类似地还有 `\hphantom` 和 `\vphantom` 命令．`\hphantom` 用于生成 水平幻影，其宽度等于内容的宽度，而高度和深度为零．`\vphantom` 用于生成竖直幻影，其高度和深度分别等于内容的高度和深度，而宽度为零

```tex
正文正文\\  
正文\hphantom{水平幻影}正文\\  
正文\vphantom{\Huge 竖直幻影}正文
```
这个例子中，竖直幻影的高度较大，撑开了第二行和第三行的间距

## 盒子变换
利用 `\raisebox` 可以升高或者降低盒子的位置

```tex
正文 \raisebox{6pt}{上升} 正文\\  
正文 \raisebox{-6pt}{\fbox{下降}} 正文

L\raisebox{1pt}{\tiny A}%  
T\raisebox{-2pt}{E}X
```

也可以在 `\raisebox` 命令中直接指定盒子的最终高度和深度
```tex
正文正文正文\\  
正文  
\raisebox{6pt}[30pt][9pt]{\fbox{上升}}  
正文
```
其中两个可选参数分别表示所需的高度和深度，深度也可以不指定．

利用 `\smash` 命令，可以将已有的盒子拍扁，即保持宽度不变，但将高度和深度变为零

```tex
正文正文\\  
正文{\huge 盒子}正文\\  
正文\smash{\huge 盒子}正文
```

其中第三行的“盒子”的高度已经变为零，所以 $\TeX$ 排版时不会自动增加第二行和第三行的间距，使得两行部分重叠

若载入 `graphics` 或 `graphicx` 宏包，还可以使用这些盒子变换命令：`\resizebox`、`\scalebox`、`\reflectbox` 和 `\rotatebox`． 利用 `\resizebox` 命令，可以对盒子进行伸缩变换

两个参数分别表示给该盒子指定的宽度和总高度．如果其中一个参数取为 !，则表示保持宽高比例不变且按照另一参数进行伸缩

利用 `\scalebox` 命令，同样可以对盒子进行伸缩变换
```tex
正常\scalebox{1.6}[0.7]{矮胖}正常\\  
正常\scalebox{0.7}[1.6]{瘦高}正常\\  
正常\scalebox{1.6}{胖高}正常
```
该命令的两个参数分别表示水平和竖直伸缩因子．如果省略竖直伸缩  
因子，则表示它和水平伸缩因子相同

`scalebox` 命令的伸缩因子也可以是负数，水平伸缩因子为负数表  
示伸缩后作水平翻转，而竖直伸缩因子为负数表示伸缩后作竖直翻转

利用 `\rotatebox` 命令，可以对盒子进行旋转变换
```tex
正常\rotatebox{45}{逆时针}正常\\  
正常\rotatebox{-30}{顺时针}正常
```
参数指明旋转角度，大于零表示逆时针旋转，小于零表示顺时针旋转

## 盒子变量
要将某些复杂内容保存起来，以后多次使用，可以定义一个盒子变量
```tex
newsavebox{\myboxa}  
\sbox{\myboxa}{TEXT}  
\usebox{\myboxa} or \fbox{\usebox{\myboxa}}
```
+ `\newsavebox` 将 `\myboxa` 定义为一个盒子变量
+ `\sbox` 将内容存入 `\myboxa` 盒子里
+ `\usebox` 从 `\myboxa` 盒子取出内容

若要设定盒子的宽度及盒子内部的对齐方式，可以将 `\sbox` 命令换成 `\savebox` 命令
```tex
\newsavebox{\myboxb}  
\savebox{\myboxb}[6em][c]{TEXT}  
A\fbox{\usebox{\myboxb}}B
```
要在盒子中存放抄录文本，可以将 `\sbox` 命令换成 `lrbox` 环境

```tex
\newsavebox{\myboxc}  
\begin{lrbox}{\myboxc}  
\verb!\box255!  
\end{lrbox}  
\fbox{\usebox{\myboxc}}
```
