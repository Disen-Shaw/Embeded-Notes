---
date updated: '2021-10-03T09:28:31+08:00'

---

## STM32启动文件

启动文件由汇编编写,是系统上电复位后第一个执行的程序。
主要做了以下工作:

1. 初始化堆栈指针 SP=_initial_sp
2. 初始化 PC 指针=Reset_Handler
3. 初始化中断向量表
4. 配置系统时钟
5. 调用 C 库函数_main 初始化用户堆栈,从而最终调用 main 函数去到 C 的世界

| 指令名称      | 作用                                                                                   |
| --------- | ------------------------------------------------------------------------------------ |
| EQU       | 给数字常量取一个符号名,相当于 C 语言中的 define                                                        |
| AREA      | 汇编一个新的代码段或者数据段                                                                       |
| SPACE     | 分配内存空间                                                                               |
| PRESERVE8 | 当前文件堆栈需按照 8 字节对齐                                                                     |
| EXPORT    | 声明一个标号具有全局属性,可被外部的文件使用                                                               |
| DCD       | 以字为单位分配内存,要求 4 字节对齐,并要求初始化这些内存                                                       |
| PROC      | 定义子程序,与 ENDP 成对使用,表示子程序结束                                                            |
| WEAK      | 弱定义,如果外部文件声明了一个标号,则优先使用外部文件定义的标号,如果外部文件没有定义也不出错要注意的是:这个不是 ARM的指令,是编译器的,这里放在一起只是为了方便。 |
| IMPORT    | 声明标号来自外部文件,跟 C 语言中的 EXTERN 关键字类似                                                     |
| B         | 跳转到一个标号                                                                              |
| ALIGN     | 编译器对指令或者数据的存放地址进行对齐,一般需要跟一个立即数,缺省表示 4 字节对齐。要注意的是:这个不是 ARM 的指令,是编译器的,这里放在一起只是为了方便。    |
| LDR       | 从存储器中加载字到一个寄存器中                                                                      |
| BL        | 跳转到由寄存器/标号给出的地址,并把跳转前的下条指令地址保存到LR                                                    |
| BLX       | 跳转到由寄存器给出的地址,并根据寄存器的 LSE 确定处理器的状态,还要把跳转前的下条指令地址保存到LR                                 |
| BX        | 跳转到由寄存器/标号给出的地址,不用返回                                                                 |
| END       | 文件结尾                                                                                 |

## 启动文件详解

### Stack栈

```asm
Stack_Size		EQU				0x00000400
				AREA			STACK, NOINIT, READWRITE, ALIGN=3
Stack_Men		SPACE			Stack_Size
__initial_sp
```

开辟栈的大小为 0X00000400(1KB)的空间
名字为 STACK,NOINIT 即不初始化,可读可写,8(2^3)字节对齐。
栈的作用是用于局部变量,函数调用,函数形参等的开销
栈的大小不能超过内部SRAM 的大小。
如果编写的程序比较大,定义的局部变量很多,那么就需要修改栈的大小。
标号__initial_sp 紧挨着 SPACE 语句放置
表示栈的结束地址,即栈顶地址,栈是由高向低生长的。

### Heap堆

```asm
Heap_Size EQU 0x00000200
		 AREA HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem SPACE Heap_Size
__heap_limit
```

开辟堆的大小为 0X00000200(512 字节)
名字为 HEAP,NOINIT 即不初始化,可读可写,8(2^3)字节对齐。
__heap_base表示对的起始地址
__heap_limit 表示堆的结束地址
堆是由低向高生长的,跟栈的生长方向相反。
堆主要用来动态内存的分配,像 malloc()函数申请的内存就在堆上面。

- PRESERVE8:指定当前文件的堆栈按照 8 字节对齐。
- THUMB:表示后面指令兼容 THUMB 指令。THUBM 是 ARM 以前的指令集,16bit,现在 Cortex-M 系列的都使用 THUMB-2 指令集,THUMB-2 是 32 位的,兼容 16 和 32 位的指令,是 THUMB 的超集。

### 向量表

```asm
AREA RESET, DATA, READONLY
EXPORT __Vectors
EXPORT __Vectors_End
EXPORT __Vectors_Size
```

定义一个数据段 , 名字为 RESET , 可读 。
并声明

- __Vectors
- __Vectors_End 和
- __Vectors_Size 这三个标号具有全局属性,可供外部的文件调用。

EXPORT:声明一个标号可被外部的文件使用,使标号具有全局属性。
如果是 IAR 编译器,则使用的是 GLOBAL 这个指令。
![Pasted image 20210308200510](../../../../../pictures/Pasted%20image%2020210308200510.png)

__Vectors 为向量表起始地址
__Vectors_End 为向量表结束地址
两个相减即可算出向量表大小

向量表从 FLASH 的 0 地址开始放置
以 4 个字节为一个单位,地址 0 存放的是栈顶地址
0X04 存放的是复位程序的地址
从代码上看,向量表中存放的都是中断服务函数的函数名
C 语言中的函数名就是一个地址

DCD：分配一个或者多个以字为单位的内存,以四字节对齐,并要求初始化这些内存。
在向量表中,DCD 分配了一堆内存,并且以 ESR 的入口地址初始化它们。

### 复位程序

定一个名称为.text 的代码段,可读。

```asm
AREA |.text|, CODE, READONLY
```

```asm
Reset_Handler 	PROC
				EXPORT Reset_Handler [WEAK]
   			IMPORT SystemInit
   			IMPORT __main
   			
   			LDR R0,=SystemInit
   			BLX R0
   			LDR R0,=__main
   			BX	R0
   			ENDP
```

### 中断服务程序

![Pasted image 20210308201251](../../../../../pictures/Pasted%20image%2020210308201251.png)

### 用户堆栈初始化

![Pasted image 20210308201337](../../../../../pictures/Pasted%20image%2020210308201337.png)

首先判断是否定义了__MICROLIB ,如果定义了这个宏则赋予标号\
__initial_sp(栈顶地址)\
__heap_base(堆起始地址)\
__heap_limit(堆结束地址)全局属性,可供外部文件调用。

如果没有定义__MICROLIB,则才用双段存储器模式,且声明标号__user_initial_stackheap 具有全局属性,让用户自己来初始化堆栈。
