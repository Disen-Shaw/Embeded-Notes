---
date updated: '2021-10-11T21:38:51+08:00'

---

# Markdown文字格式

## 公式编辑

一般公式分为两种形式：行内公式和行间公式

- 行内公式用$包围
- 行间公式用\$\$包围

### 希腊字母

| 名称      | 大写 | code     | 小写 | code     |
| ------- | -- | -------- | -- | -------- |
| alpha   | A  | A        | α  | \alpha   |
| beta    | B  | B        | β  | \beta    |
| gamma   | Γ  | \Gamma   | γ  | \gamma   |
| delta   | Δ  | \Delta   | δ  | \delta   |
| epsilon | E  | E        | ϵ  | \epsilon |
| zeta    | Z  | Z        | ζ  | \zeta    |
| eta     | H  | H        | η  | \eta     |
| theta   | Θ  | \Theta   | θ  | \theta   |
| iota    | I  | I        | ι  | \iota    |
| kappa   | K  | K        | κ  | \kappa   |
| lambda  | Λ  | \Lambda  | λ  | \lambda  |
| mu      | M  | M        | μ  | \mu      |
| nu      | N  | N        | ν  | \nu      |
| xi      | Ξ  | \Xi      | ξ  | \xi      |
| omicron | O  | O        | ο  | \omicron |
| pi      | Π  | \Pi      | π  | \pi      |
| rho     | P  | P        | ρ  | \rho     |
| sigma   | Σ  | \Sigma   | σ  | \sigma   |
| tau     | T  | T        | τ  | \tau     |
| upsilon | Υ  | \Upsilon | υ  | \upsilon |
| phi     | Φ  | \Phi     | ϕ  | \phi     |
| chi     | X  | X        | χ  | \chi     |
| psi     | Ψ  | \Psi     | ψ  | \psi     |
| omega   | Ω  | \Omega   | ω  | \omega   |

°C\
`\partial`-> $\partial$

### 上标与下标

- 上标使用`^`
- 下标使用`_`

例如$X_i^2$表示为$X_i^2$

如果商标或者下标有多个字符，需要使用大括号`{}`框起来使用</br>
并且大括号可以消除**二义性**</br>
比如 `$X^5^6$` 正常表现是出错的，但是使用大括号${X^5}^6$皆可以成功表示</br>
但是要表达大括号需要添加`\{`和`\}`

### 公式内文本

`\text` 例如\
$\frac{1}{3}\text{一段文本}$

### 括号

小括号与方括号大小与邻近的公式相适应

#### 尖括号

区分于小于号和大于号，使用`\langle` 和`\rangle` 表示左尖括号和右尖括号。如`$\langle x \rangle$` 表示 $\langle x \rangle$

### 取整

使用`\lceil` 和 `\rceil` 表示。 如，`$\lceil x \rceil$`：$\lceil x \rceil$</br>
使用`\lfloor` 和 `\rfloor` 表示。如，`$\lfloor x \rfloor$`：$\lfloor x \rfloor$

### 求和

`\sum` 用来表示求和符号，其下标表示求和下限，上标表示上限

例如：

行间表达：$\sum_{i=0}^n$

整行表达
$\sum_{i=0}^n$

### 积分

`\int` 用来表示积分符号，同样地，其上下标表示积分的上下限</br>
例如`\int_{r=0}^\infty`表示$\int_{r=0}^\infty$

多重积分可以也可以使用int，通过i的数量表示积分导数
$\iiint_{xyz}^\infty d(x)$

### 连乘

`$\prod {a+b}$`，输出$\prod {a+b}$

`$\prod_{i=1}^{K}$`，输出$\prod_{i=1}^{K}$

`$$\prod_{i=1}^{K}$$`，输出$\prod_{i=1}^{K}$

### 其他符号

`$\bigcup$`：$\bigcup$

`$\bigcap$`：$\bigcap$

### 分式

使用`\frac ab`，`\frac`作用于其后的两个组`a` ，`b` ，结果为$\frac ab$</br>
如果需要复杂的分式，需要使用大括号进行分组

或者使用`\over`来分隔一个组的前后两部分，如`{a+1\over b+1}`：${a+1\over b+1}$

#### 连分式

书写连分数表达式时，使用`\cfrac`代替`\frac`或`\over`
$x=a_0 + \frac {1^2}{a_1 + \frac {2^2}{a_2 + \frac {3^2}{a_3 + \frac {4^2}{a_4 + ...}}}}$
`\cfrac`表示如下

$x=a_0 + \cfrac {1^2}{a_1 + \cfrac {2^2}{a_2 + \cfrac {3^2}{a_3 + \cfrac {4^2}{a_4 + ...}}}}$

### 根式

根式使用`\sqrt` 来表示</br>
如开4次方：`$\sqrt[4]{\frac xy}$` ：$\sqrt[4]{\frac xy}$</br>
开平方：`$\sqrt {x+y}$`:$\sqrt {x+y}$

### 多行表达式

#### 分类表达式

定义函数的时候经常需要分情况给出表达式，使用`\begin{cases}…\end{cases}`，其中：

- 使用`\\`来分类
- 使用`&`制定需要对其的位置
- 使用`\`+`space`表示空格

例如：

```ruby
$$
f(n)
\begin{cases}
\cfrac n2, &if\ n\ is\ even\\
3n + 1, &if\  n\ is\ odd
\end{cases}
$$
```

表示

$$
f(n)
\begin{cases}
\cfrac n2, &if\ n\ is\ even\\
3n + 1, &if\  n\ is\ odd
\end{cases}
$$

```ruby
$$
L(Y,f(X)) =
\begin{cases}
0, & \text{Y = f(X)}  \\
1, & \text{Y $\neq$ f(X)}
\end{cases}
$$
```

表示

$$
L(Y,f(X)) =
\begin{cases}
0, & \text{Y = f(X)}  \\
1, & \text{Y $\neq$ f(X)}
\end{cases}
$$

如果想分类之间的垂直间隔变大，可以使用`\\[2ex]` 代替`\\` 来分隔不同的情况。(`3ex,4ex` 也可以用，`1ex` 相当于原始距离）

```ruby
$$
L(Y,f(X)) =
\begin{cases}
0, & \text{Y = f(X)} \\[5ex]
1, & \text{Y $\neq$ f(X)}
\end{cases}
$$
```

表示

$$
L(Y,f(X)) =
\begin{cases}
0, & \text{Y = f(X)} \\[5ex]
1, & \text{Y $\neq$ f(X)}
\end{cases}
$$

### 特殊符号

#### 比较运算符

- 小于(`\lt` )：$\lt$
- 大于(`\gt` )：$\gt$
- 小于等于(`\le` )：$\le$
- 大于等于(`\ge` )：$\ge$
- 不等于(`\ne` )：$\ne$

也可以在这些运算符上面加上`\not`，如`\not\lt`：$\not\lt$

#### 集合关系与运算

- 并集(`\cup` ): $\cup$
- 交集(`\cap` ): $\cap$
- 差集(`\setminus` ):$\setminus$
- 子集(`\subset` ): $\subset$
- 子集(`\subseteq` ):$\subseteq$
- 非子集(`\subsetneq` ):$\subsetneq$
- 父集(`\supset` ):$\supset$
- 属于(`\in` ):$\in$
- 不属于(`\notin` ):$\notin$
- 空集(`\emptyset` ):$\emptyset$
- 空(`\varnothing` ):$\varnothing$

#### 排列

- `\binom{n+1}{2k}`：$\binom{n+1}{2k}$
- `{n+1 \choose 2k}`:${n+1 \choose 2k}$

#### 箭头

- (`\to` ): $\to$
- (`\rightarrow` ): $\rightarrow$
- (`\leftarrow` ): $\leftarrow$
- (`\Rightarrow` ): $\Rightarrow$
- (`\Leftarrow` ): $\Leftarrow$
- (`\mapsto` ): $\mapsto$

#### 逻辑运算符

- (`\land` ): $\land$
- (`\lor` ): $\lor$
- (`\lnot` ): $\lnot$
- (`\forall` ): $\forall$
- (`\exists` ): $\exists$
- (`\top` ): $\top$
- (`\bot` ): $\bot$
- (`\vdash` ): $\vdash$
- (`\vDash` ): $\vDash$

#### 操作服

- (`\star` ): $\star$
- (`\ast` ): $\ast$
- (`\oplus` ): $\oplus$
- (`\circ` ): $\circ$
- (`\bullet` ): $\bullet$

#### 等于

- (`\approx` ): $\approx$
- (`\sim` ): $\sim$
- (`\equiv` ): $\equiv$
- (`\prec` ): $\prec$

#### 范围

- (`\infty` ): $\infty$
- (`\aleph_o` ): $\aleph_o$
- (`\nabla` ): $\nabla$
- (`\Im` ): $\Im$
- (`\Re` ): $\Re$

#### 点

- (`\ldots` ): $\ldots$
- (`\cdots` ): $\cdots$
- (`\cdot` ): $\cdot$

`\ldots` 位置稍低，`\cdots` 位置居中。

$$
\begin{equation}
a_1+a_2+\ldots+a_n \\
a_1+a_2+\cdots+a_n
\end{equation}
$$

#### 顶部符号

- 对于单字符，`\hat x` ：$\hat x$
- 多字符可以使用`\widehat {xy}` ：$\widehat {xy}$
- 类似的还有:
- (`\overline x` ): $\overline x$
- 矢量(`\vec` ): $\vec x$
- 向量(`\overrightarrow {xy}` ): $\overrightarrow {xy}$
- (`\dot x` ): $\dot x$
- (`\ddot x` ): $\ddot x$
- (`\dot {\dot x}` ): $\dot {\dot x}$

### 表格

使用`\begin{array}{列样式}…\end{array}` 这样的形式来创建表格，列样式可以是`clr` 表示居中，左，右对齐，还可以使用`|` 表示一条竖线。表格中各行使用`\\` 分隔，各列使用`&` 分隔。使用`\hline` 在本行前加入一条直线。

```ruby
$$
\begin{array}{c|lcr}
n & \text{Left} & \text{Center} & \text{Right} \\
\hline
1 & 0.24 & 1 & 125 \\
2 & -1 & 189 & -8 \\
3 & -20 & 2000 & 1+10i \\
\end{array}
$$
```

得到

$$
\begin{array}{c|lcr}
n & \text{Left} & \text{Center} & \text{Right} \\
\hline
1 & 0.24 & 1 & 125 \\
2 & -1 & 189 & -8 \\
3 & -20 & 2000 & 1+10i \\
\end{array}
$$

### 矩阵

使用`\begin{matrix}…\end{matrix}` 这样的形式来表示矩阵，在`\begin` 与`\end` 之间加入矩阵中的元素即可。矩阵的行之间使用`\\` 分隔，列之间使用`&` 分隔

```ruby
$$
\begin{matrix}
1 & x & x^2 \\
1 & y & y^2 \\
1 & z & z^2 \\
\end{matrix}
$$
```

得到

$$
\begin{matrix}
1 & x & x^2 \\
1 & y & y^2 \\
1 & z & z^2 \\
\end{matrix}
$$

### 括号

如果要对矩阵加括号，可以像上文中提到的一样，使用`\left` 与`\right` 配合表示括号符号。也可以使用特殊的`matrix` 。即替换`\begin{matrix}…\end{matrix}` 中`matrix` 为`pmatrix` ，`bmatrix` ，`Bmatrix` ，`vmatrix` , `Vmatrix` 。

- pmatrix`$\begin{pmatrix}1 & 2 \\ 3 & 4\\ \end{pmatrix}$` : $\begin{pmatrix}1 & 2 \\ 3 & 4\\ \end{pmatrix}$
- bmatrix`$\begin{bmatrix}1 & 2 \\ 3 & 4\\ \end{bmatrix}$` : $\begin{bmatrix}1 & 2 \\ 3 & 4\\ \end{bmatrix}$
- Bmatrix`$\begin{Bmatrix}1 & 2 \\ 3 & 4\\ \end{Bmatrix}$` : $\begin{Bmatrix}1 & 2 \\ 3 & 4\\ \end{Bmatrix}$
- vmatrix`$\begin{vmatrix}1 & 2 \\ 3 & 4\\ \end{vmatrix}$` : $\begin{vmatrix}1 & 2 \\ 3 & 4\\ \end{vmatrix}$
- Vmatrix`$\begin{Vmatrix}1 & 2 \\ 3 & 4\\ \end{Vmatrix}$` : $\begin{Vmatrix}1 & 2 \\ 3 & 4\\ \end{Vmatrix}$

### 元素省略

可以使用`\cdots` ：⋯，`\ddots`：⋱ ，`\vdots`：⋮ 来省略矩阵中的元素

```ruby
$$
\begin{pmatrix}
1&a_1&a_1^2&\cdots&a_1^n\\
1&a_2&a_2^2&\cdots&a_2^n\\
\vdots&\vdots&\vdots&\ddots&\vdots\\
1&a_m&a_m^2&\cdots&a_m^n\\
\end{pmatrix}
$$
```

表示

$$
\begin{pmatrix}
1&a_1&a_1^2&\cdots&a_1^n\\
1&a_2&a_2^2&\cdots&a_2^n\\
\vdots&\vdots&\vdots&\ddots&\vdots\\
1&a_m&a_m^2&\cdots&a_m^n\\
\end{pmatrix}
$$

### 增广矩阵

增广矩阵需要使用前面的表格中使用到的`\begin{array} ... \end{array}`

```swift
$$
\left[  \begin{array}  {c c | c} %这里的c表示数组中元素对其方式：c居中、r右对齐、l左对齐，竖线表示2、3列间插入竖线
1 & 2 & 3 \\
\hline %插入横线，如果去掉\hline就是增广矩阵
4 & 5 & 6
\end{array}  \right]
$$
```

表示为

$$
\left[  \begin{array}  {c c | c} %这里的c表示数组中元素对其方式：c居中、r右对齐、l左对齐，竖线表示2、3列间插入竖线
1 & 2 & 3 \\
\hline %插入横线，如果去掉\hline就是增广矩阵
4 & 5 & 6
\end{array}  \right]
$$
