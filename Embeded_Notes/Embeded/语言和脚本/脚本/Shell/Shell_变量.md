# Shell 变量

## 变量定义

变量定义的时候不加 `$`，例如

```shell
url="www.baidu.com"
```

**变量和等号之间绝对不能有空格**，并且变量名应遵守

- 命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
- 中间不能有空格，可以使用下划线 _。
- 不能使用标点符号。
- 不能使用bash里的关键字（可用help命令查看保留关键字）。

除了上面的 `显示赋值` 还有 `隐式赋值`，用语句给变量赋值

```shell
for file in `ls /etc`
# 或者
for file in $(ls /etc)
```

## 使用变量

使用一个定义过的变量，只要在变量名前面加美元符号即可，如：

```shell
your_name="qinjx" 
echo $your_name
echo ${your_name}
```

加大括号为了解释器能够更好的识别变量边界，最好是加上大括号\
已经定义的变量可以二次赋值，赋值方式仍然和第一次使用一致

### 只读变量

将变量更改为只读，后序脚本不可以再对其进行更改

```shell
readonly 变量名
```

### 删除变量

```shell
unset 变量名
```


## 变量类型

运行 shell 时，会同时存在三种变量类型

- **局部变量**：局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量

- **环境变量**：所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。
  - 必要的时候shell脚本也可以定义环境变量

- **shell变量**：shell变量是由shell程序设置的特殊变量
  - shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行

## Shell 特殊变量
+ $?：上一条命令的执行结果
	+ 0：上一个命令执行正确
	+ 非零：上一个命令执行错误
+ 
## shell 字符串

字符串是 shell 编程中最常用最有用的数据类型（除了数字和字符串，也没啥其它类型好用了）\
字符串可以用单引号，也可以用双引号，也可以不用引号

单引号变量中若存在其他变量，不会对其进行解读，双引号可以对字符串中的其他变量进行解读

```shell
#!/bin/sh
var=1314
strs='${var} 520'
```

这个脚本只会输出 "${var} 520"

```shell
#!/bin/sh
var=1314
strs="${var} 520"
```

这个脚本就会输出 "1314 520"

双引号的优点：

- 双引号里可以有变量
- 双引号里可以出现转义字符

### 获取字符串长度

通过 `${#变量名}` 获取字符串长度

```shell
string="abcd" 
echo ${#string} #输出 4
```

### 提取子字符串

有点像于 [Python](../Python/Python_Source.md) 的切片操作

从字符串第 **2** 个字符开始截取 **4** 个字符

```shell
string="runoob is a great site" 
echo ${string:1:4} # 输出 unoo
```

### 查找字符串

查找字符 **i** 或 **o** 的位置(哪个字母先出现就计算哪个)：

```shell
string="runoob is a great site" 
echo `expr index "$string" io` # 输出 4
```

## shell 数组

bash支持一维数组（不支持多维数组），并且没有限定数组的大小\
类似于 C 语言，数组元素的下标由 0 开始编号

获取数组中的元素要利用下标，下标可以是整数或算术表达式，**其值应大于或等于 0**

### 定义数组

在 shell 中用括号定义数组，用空格将数组元素分割开来

```shell
# 定义格式
数组名=(值1 值2...)
# 实例
array_name1=(value0 value1 value2)
array_name2=(
	value0
	value1
	value2
)
# 另外还可以对单独定义数组的各个分量
array_name[0]=value0
array_name[1]=value1
array_name[2]=value2
```

### 读取数组

读取数组一般格式为

```shell
${数组名[下标]}
```

使用 `@` 可以获取数组中的所有元素，例如

```shell
echo ${arrayname[@]}
```

### 获取数组长度

使用方式与获取字符串长度相同

```shell
# 获取数组元素个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 获取数组单个元素的长度
length=${#array_name[n]}
```

## 注释

### 单行注释

以 `#` 开头的行就是注释，执行时会被解释器忽略

### 多行注释

```shell
# EOF
:<<EOF
注释内容
EOF
# EOF 也可以用其他符号
:<<'
注释内容
'
```

可以用这种方法在 `sh` 脚本中执行其他解释型语言的脚本

```shell
#!/bin/sh
echo $PATH

/usr/bin/python <<EOF
print("hello world")
EOF

```
