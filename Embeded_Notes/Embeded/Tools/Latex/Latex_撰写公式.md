# $\LaTeX$撰写公式
## 数学阵列
在数学公式中有一个和 `tabular` 用法类似的 `array` 环境  
比如可以制作下面的数学阵列
```tex
$\begin{array}{|l|rrrrr|}
\hline
n & 1 & 2 & 3 & 4 & 5 \\
\hline
n^2 & 1 & 4 & 9 & 16 & 25 \\
\hline
\end{array}$
```
显示如
$\begin{array}{|l|rrrrr|}
\hline
n & 1 & 2 & 3 & 4 & 5 \\
\hline
n^2 & 1 & 4 & 9 & 16 & 25 \\
\hline
\end{array}$

利用 `array` 环境，很容易写出矩阵和行列式等多行多列的公式
```tex
$\left(\begin{array}{ccc}
1 & 2 & 3
4 & 5 & 6
7 & 8 & 9
\end{array}\right)$
```
显示如
$\left(\begin{array}{ccc}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9 
\end{array}\right)$

其中的 `\left` 和 `\right` 用于表示一对定界符  
定界符会依据内容的高度自动调整大小

如果定界符一边有空缺，则必须用 `.` 表示  
```tex
$|x|=\left\{\begin{array}{ll}
x, & \text{if}\ x \ge 0;  \\
-x, & \text{if}\ x < 0;
\end{array}\right.$
```
显示如
$|x|=\left\{\begin{array}{ll}
x, & \text{if}\ x \ge 0;  \\
-x, & \text{if}\ x < 0;
\end{array}\right.$

## 多行公式
利用 `align*` 环境，很容易写出多行的对齐公式
```tex
$\begin{align*}
(x+y)^2 &= (x+y)(x+y)\\
		&= x^2 +xy +yx +y^2 \\
		&= x^2 +2xy + y^2
\end{align*}
```
其中 `&` 表示各行中对齐的位置，将 `align*` 改为 `align` 将得到带编号的公式

显示如下
$$\begin{align*}
(x+y)^2 &= (x+y)(x+y)\\
		&= x^2 +xy +yx +y^2 \\
		&= x^2 +2xy + y^2
\end{align*}$$

