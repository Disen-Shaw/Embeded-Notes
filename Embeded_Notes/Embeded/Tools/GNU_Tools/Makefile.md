# Makefile笔记

### Makefile三要素

目标、依赖、命令

如果依赖没有改动，就不会再执行相应的命令
会输出已是最新

创建一个makefile文件

如果有多个makefile文件可使用

~~~makefile
make -f makefile_test
~~~
### 伪目标
伪目标：可以反复执行，不会有最新的限制

~~~makefile
.PHONY:
clear:
	rm -rf build
~~~

### 多文件构建

~~~makefile
test:maim.o fun.o
	gcc main.o fun.o -o test
main.o:
	gcc -c main.c -o main.o
fun.o:
	gcc -c fun.c -o fun.o
.PHONY:
clean:
	rm -rf build
~~~
### makefile支持条件分支
~~~makefile
ifeq(var1,var2)
...
else
...
endif

ifneq(var1,var2)
...
else
...
endif
~~~

### 第二层 变量

分为以下几类

1. 系统变量

   CC、AS、MAKE

2. 自定义变量


> 运算符

+ = 替换

+ += 追加

+ ?= 空赋值

  变量为空时有效

+ =, 延迟赋值

+ := 立即赋值

3. 自动化变量

+ $^

  所有的依赖文件

+ $@

  所有的目标文件

+ $<

  所有的依赖文件的第一个文件

+ $*

  不包含扩展名的目标文件名称

+ $+

  所有的依赖文件，一空格分开，并已出现的先后为序，可能包含重复的依赖文件

+ $?

  所有时间戳比目标文件晚的依赖文件，并以空格分开
  
+ -
  发生错误继续运行

> 使用

~~~makefile
#使用$(变量名)
TARGET = test
OBJ = main.o fun.o
CC := gcc

$(TARGET):$(OBJ)
	$(CC) $(OBJ) -o $(TARGET)
main.o:
	$(CC) -c main.c -o main.o
fun.o:
	$(CC) -c fun.c -o fun.o
.PHONY:
clean:
	rm -rf build
~~~

### 第三层 隐含规则

> 隐含规则

+ %.c

+ %.o

  任意的.c或.o文件

+ *.c

+ *.o

  所有的.c或者.o文件

~~~makefile
#使用$(变量名)
TARGET = test
OBJ = main.o fun.o
CC := gcc
$(TARGET):$(OBJ)
	$(CC) $(OBJ) -o $(TARGET)
%.c:%.c
	$(CC) -c %.c -o %.o
.PHONY:
clean:
	rm -rf build
~~~

### 第四层 通配符

> 通配符

~~~makefile
#使用$(变量名)
TARGET = test
OBJ = main.o fun.o
CC := gcc
$(TARGET):$(OBJ)
	$(CC) $^ -o $@
%.c:%.c
	$(CC) -c $^ -o $@
.PHONY:
clean:
	rm -rf build
~~~

### 函数

1. patsubst：模式替换函数

~~~makefile
$(patsubst PATTERN,RELACEMENT,TEXT)
# 搜索TEXT中以空格分开的单词，将符合PARTTEN替换为RELACEMENT，参数PARTTERN可以使用通配符%
#示例
$(patsubst %.c,%.o,main.c,fun.c)
~~~

2. notdir：取文件名函数

~~~makefile
$(notdir NAMES...)
#从文件名序列"NAMES"中取出文件名
#如果不包含文件名，则不会改变
~~~

3. wildcard：获取匹配模式文件名函数

~~~makefile
$(wildcard PATTERN)
#列出当前目录下所有符合模式PATTERN格式的文件名
#示例：
$(wildcard dir/*.c)
~~~

4. foreach：循环函数，类似于shell中的for语句

~~~makefile
$(foreach VAR,LIST,TEXT)
#首先展开变量VAR和LIST的引用，执行时把LIST中使用空格分到的词取出，复制给VAR，然后执行TEXT表达式，重复直到LIST最后一个单词
#示例：
dirs:=a b c d
files:=$(foreach dir,$(dirs),$(wildcard $(dir)/*.c))
~~~


## 补充
### 命令出错
如果make命令运行过程中出错，会终止make命令
如果要忽略命令，则需要添加一些参数

|操作|效果|
|--|--|
|make -i|所有命令的错误都会被忽略|
|make -k|即使有出错命令，也会继续运行|
|在命令前加-符号</br>例如 -rm -rf \*|即使该命令出错也会继续运行|

### 嵌套make
编译大型文件，可能需要每个目录有每个目录的make文件
例如：
~~~makefile
subsystem:
	cd subdir && $(MAKE)
~~~
等价于
~~~makefile
$(MAKE) -C ubdir
~~~
这样的makefile文件叫做Makefile的总控文件

### 定义命令包
以define开头，endef结尾
**命令包的名字不可以与变量重名**
~~~makefile
define run-yacc
yacc $(firstword $^)
mv y.tab.c $@
endef
~~~
run-ycc为命令包的名字
中间两行是命令序列
使用时需要加$()


### 高级变量用法
#### 替换
替换变量中的共有部分，能够更改变量的值
~~~makefile
$(var:a=b) #或者
${var:a=b}
#把变量var中所有以“a”字符串结尾的替换为以“b”结尾
~~~
##### 把变量值当成变量
用法相当于$()的递归
例如
~~~makefile
x = y
y = z
a := $($(x))
~~~

##### 在变量定义中使用变量
类似于STM32的makefile文件中的用法

##### 追加变量值
类似于STM32的makefile文件中的用法

##### override指令
在命令行中定义的变量会优先赋值

~~~makefile
override define test
echo "test"
endef
~~~
如果test的值在命令行中被定义，则直接略过
#### 局部变量
~~~makefile
prog:CFLAGS = -g
prog:prog.o foo.o bar.o
#编译并链接
~~~
不论全局变量CFLAGS定义的是什么，在prog目标以及生成过程中
CFLAGS都只是 -g
****
****
### 函数
#### 字符串处理函数
**subst**
$(subst \<from\>,\<to\>,\<text\>)
字符串替换函数
把字符串text中的from字符串换成to

**patsubst**
$(patsubst \<pattern\>,\<replacement\>,\<text\>)
模式字符替换函数
可以使用通配符
****
**strip**
$(strip \<string\>)
去空格函数
去掉string中的空格的函数
****
**findstring**
$(findstring \<find\>,\<in\>)
查找字符串函数
在in中查找find字符串
如果找到就返回find，如果没找到就返回空字符串
****
**filter**
$(filter \<pattern...\>,\<text\>)
过滤函数
以pattern模式过滤text字符串中的单词，保留复合模式的单词
可以有多个模式

**filter-out**
$(filter-out \<pattern...\>,\<text\>)
反过滤函数
****
**sort**
$(sort \<list\>)
排序函数
给list中的单词**升序**排序
****
**word**
$(word \<n\>,\<text\>)
取单词函数
抓去text中的第n个单词

**wordlist**
$(wordlist \<ss>,\<e>,\<text>)
取单词串函数
在text中取ss到e的单词串
ss和e是数字

**words**
$(words \<text>)
单词格式统计函数

**fiestword**
$(firstword \<text>)
返回text中的第一个单词
****
#### 文件名操作函数
**dir**
$(dir <names...>)
取文件目录函数
从文件名序列中取出目录部分(一般就用于一个文件)

**notdir**
$(notdir <names...>)
取出非目录部分

**suffix**
$(suffix <names...>)
取后缀函数

**basename**
$(basenaem <names...>)
取前缀函数

**addsuffix**
$(addsuffix \<siffix><names...>)
加前缀函数
把后缀 \<suffix> 加到 \<names> 中的每个单词后面
****
**join函数**
$(join \<list1>,\<list2>)
连接函数
把list2连接到list1的后面

****
**foreach**
$(foreach \<var>,\<list>,\<text>)
把list中的单词逐一取出放到参数var所指的变量中，在执行text所包含的表达式
循环过程

****
**shell函数**
和反引号具有相同的功能
$(shell xxx)
****


### make的运行
指定makefile文件
make -f makefile_test

-t, --touch 这个参数的意思就是把目标文件的时间更新,但不更改目标文件。也就是说,make 假装编译目标,但不是真正的编译目标,只是把目标变成已编译过的状态。
-q, --question 这个参数的行为是找目标的意思,也就是说,如果目标存在,那么其什么也不会输出,当然也不会执行编译,如果目标不存在,其会打印出一条出错信息。
-W \<file>, --what-if=\<file>, --assume-new=\<file>, --new-file=\<file> 这个参数需要指定一个文件。一般是是源文件(或依赖文件),Make 会根据规则推导来运行依赖于这个文件的命令,一般来说,可以和“-n”参数一同使用,来查看这个依赖文件所发生的规则命令

****
### 隐含规则
如果要使用隐含规则生成你需要的目标,你所需要做的就是不要写出这个目标的规则。

#### 编译规则
1. 编译 C 程序的隐含规则。
\<n>.o 的目标的依赖目标会自动推导为 \<n>.c ,并且其生成命令是
`$(CC) –c $(CPPFLAGS) $(CFLAGS)`
2. 编译 C++ 程序的隐含规则。
\<n>.o 的目标的依赖目标会自动推导为 \<n>.cpp 或是 \<n>.C ,并且其生成命令是 
`$(CXX) –c $(CPPFLAGS) $(CFLAGS)`


#### 关于命令的变量
• AR : 函数库打包程序。默认命令是 ar
• AS : 汇编语言编译程序。默认命令是 as
• CC : C 语言编译程序。默认命令是 cc
• CXX : C++ 语言编译程序。默认命令是 g++
• CO : 从 RCS 文件中扩展文件程序。默认命令是 co
• CPP : C 程序的预处理器(输出是标准输出设备)。默认命令是 $(CC) –E
• FC : Fortran 和 Ratfor 的编译器和预处理程序。默认命令是 f77
• GET : 从 SCCS 文件中扩展文件的程序。默认命令是 get
• LEX : Lex 方法分析器程序(针对于 C 或 Ratfor)。默认命令是 lex
• PC : Pascal 语言编译程序。默认命令是 pc
• YACC : Yacc 文法分析器(针对于 C 程序)。默认命令是 yacc
• YACCR : Yacc 文法分析器(针对于 Ratfor 程序)。默认命令是 yacc –r
• MAKEINFO : 转换 Texinfo 源文件(.texi)到 Info 文件程序。默认命令是 makeinfo
• TEX : 从 TeX 源文件创建 TeX DVI 文件的程序。默认命令是 tex
• TEXI2DVI : 从 Texinfo 源文件创建军 TeX DVI 文件的程序。默认命令是 texi2dvi
• WEAVE : 转换 Web 到 TeX 的程序。默认命令是 weave
• CWEAVE : 转换 C Web 到 TeX 的程序。默认命令是 cweave
• TANGLE : 转换 Web 到 Pascal 语言的程序。默认命令是 tangle
• CTANGLE : 转换 C Web 到 C。默认命令是 ctangle
• RM : 删除文件命令。默认命令是 rm –f
#### 关于命令参数的变量
• ARFLAGS : 函数库打包程序 AR 命令的参数。默认值是 rv
• ASFLAGS : 汇编语言编译器参数。(当明显地调用 .s 或 .S 文件时)
• CFLAGS : C 语言编译器参数。
• CXXFLAGS : C++ 语言编译器参数。
• COFLAGS : RCS 命令参数。
• CPPFLAGS : C 预处理器参数。(C 和 Fortran 编译器也会用到)。
• FFLAGS : Fortran 语言编译器参数。
• GFLAGS : SCCS “get”程序参数。
• LDFLAGS : 链接器参数。(如:ld )
• LFLAGS : Lex 文法分析器参数。
• PFLAGS : Pascal 语言编译器参数。
• RFLAGS : Ratfor 程序的 Fortran 编译器参数。
• YFLAGS : Yacc 文法分析器参数。

## 经典makefile文件
~~~makefile
TARGET\=target

  

\# 环境

CC = g++

\# 文件夹定义

BUILD\_DIR = build

SRC\_DIR = src

INC\_DIR = inc

CFLAGS = $(patsubst %,-I%,$(INC\_DIR))

\# 文件定义

VPATH = $(SRC\_DIR)

SOURCES = $(foreach dir,$(SRC\_DIR),$(wildcard $(dir)/\*.cpp))

INCLUDES = $(foreach dir,$(INC\_DIR),$(wildcard $(dir)/\*.h))

OBJS = $(patsubst %.cpp,$(BUILD\_DIR)/%.o,$(notdir $(SOURCES)))

  
  

$(BUILD\_DIR)/$(TARGET):$(OBJS)

$(CC) $^ -o $@

  

$(BUILD\_DIR)/%.o:%.cpp | BUILD

$(CC) -c $< -o $@ $(CFLAGS)

  

.PHONY:test BUILD clean run

test:

echo $(SOURCES)

BUILD:

mkdir -p $(BUILD\_DIR)

  

clean:

rm -rf $(BUILD\_DIR)

  

run:

./$(BUILD\_DIR)/$(TARGET)
~~~

# 再记Makefile
## 命令行参数定义
1. 下列命令在makefile文件运行时只显示命令，不会运行
	+ -n
	+ -just-print
	+ --dry-run
	+ --recon

2. 下列命令会全面禁止命令的显示
	+ -s
	+ -slience
	+ --quiet

3. 将系统中的环境变量覆盖到makefile中
	+ -e
	+ --environment-overrides

4. 指定其他的makefile文件
	+ -f
	+ --file

5. 将目标文件的时间更新，假装编译目标，但不是真正的编译目标，只是把目标编程已编译的状态
	+ -t
	+ -touch

6. 找目标，如果目标存在，什么也不会输出，如果不存在，则会显示错误
	+ q
	+ --question

7. 忽略其他版本make的兼容性
	+ -b
	+ -m

8. 认为所有目标都需要重新编译(重编译)
	+ -B
	+ --always-make