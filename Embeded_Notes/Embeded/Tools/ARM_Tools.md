# ARM-NONE-EABI-GCC使用
arm-none-eabi-gcc基本和[GCC](GCC.md)一致
## 第一步 建立文档
建立文档用来存放整个工程

1. stratup_stm32f10x_hd.s

   从固件库拷贝，

2. stm32f10x.h 空文件

3. main.c

~~~c
#include "stm32f10x.h"
int main()
{
    /* 开启GPIOB时钟 */
    *(unsigned int*)(0x40021000+0x18) |= 1&lt;&lt;3;
 
    /* 配置PB0为推挽输出 */
    *(unsigned int*)(0x40010c00+0x00) |= 1&lt;&lt;(4*0);
 
    /* PB0输出低电平，点亮绿色LED */
    *(unsigned int*)(0x40010c00+0x0c) &amp;= ~(1&lt;&lt;0);
 
    while(1);
}
void SystemInit(void)
{
 
}
~~~

## 第二步 编译

编译时候有两种文件

一种是汇编启动文件
一种是c源文件

| 参数            | 说明               |
| --------------- | ------------------ |
| -mthumb         | 使用的指令集(必需) |
| -mcpu=cortex-m3 | 表明芯片内核(必需) |
| -g              | 产生调试信息       |

### 启动文件编译

启动文件由汇编文件写成，格式为.s和.S

+ 小写s；文件不需要处理，直接编译
+ 大写S：文件中含有预处理指令(例如#define)
  需要先进行处理

如果使用的是.S文件，需要带上参数

| 参数                 | 说明                      |
| -------------------- | ------------------------- |
| -x assmbler-with-cpp | 现对文件进行预处理        |
| -Wa,option           | 向汇编起Assembler传递参数 |

可以向编译器传递的参数：

| 参数            | 说明                 |
| --------------- | -------------------- |
| -W或者--no-warn | 关闭所有警报         |
| -fatal-warnings | 将所有警报提示为错误 |
| --warn          | 正常提示警告信息     |

### 编译启动文件

~~~shell
arm-none-eabi-gcc -c mthumb -mcpu=cortex-m3 -g -Wa,--warn -o startup_stm32f10x_hd.o  startup_stm32f10x_hd.s
~~~

### C文件编译

~~~shell
arm-none-eabi-gcc -c mthumb -mcpu=cortex-m3 -g -wall -o main.o main.c
~~~

## 链接

连接重要的部分有两点：

+ 链接文件
+ 传递给链接器的参数

其中 ``tm32_flash.ld``是针对STM32F103ZE的链接文件
如果是别的芯片，则需要修改，将它复制到工程中

### 根据链接文件对.o文件进行链接，生成包含了调试信息的elf文件，同时需要给链接器传递参数：

| 参数 | 描述         |
| ---- | ------------ |
| -T   | 指定链接文件 |


~~~shell
arm-none-eabi-gcc -o test.elf main.o startup_stm32f10x_hd.o -mthumb -mcpu=cortex-m3 -T stm32_flash.ld -specs=nosys.specs -static -Wl,-cref,-u,Reset_Handler -Wl,-Map=test.map -Wl,--gc-sections -Wl,--defsym=malloc_getpagesize_P=0x80 -Wl,--start-group -lc -lm -Wl,--end-group
~~~



## 生成bin文件或者hex文件

利用arm-none-eabi-objcopy 工具可以讲elf文件转化为适用于单片机的bin或者hex文件，其中 参数 -O 用于指定使出文件的格式(默认是bin文件)

~~~shell
arm-none-eabi-objcopy test.elf test.bin
arm-none-eabi-objcopy test.elf -Oihex test.hex
~~~



## 编写Makefile文件

编写简易[[Makefile]]

~~~makefile
TARGET=test
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
RM=rm -f
CORE=3
CPUFLAGS=-mthumb -mcpu=cortex-m$(CORE)
LDFLAGS = -T stm32_flash.ld -Wl,-cref,-u,Reset_Handler -Wl,-Map=$(TARGET).map -Wl,--gc-sections -Wl,--defsym=malloc_getpagesize_P=0x80 -Wl,--start-group -lc -lm -Wl,--end-group
CFLAGS=-g -o
$(TARGET):startup_stm32f10x_hd.o main.o
    $(CC) $^ $(CPUFLAGS) $(LDFLAGS) $(CFLAGS) $(TARGET).elf
startup_stm32f10x_hd.o:startup_stm32f10x_hd.s
    $(CC) -c $^ $(CPUFLAGS) $(CFLAGS) $@
main.o:main.c
    $(CC) -c $^ $(CPUFLAGS) $(CFLAGS) $@
 
bin:
    $(OBJCOPY) $(TARGET).elf $(TARGET).bin
hex:
    $(OBJCOPY) $(TARGET).elf -Oihex $(TARGET).hex
clean:
    $(RM) *.o $(TARGET).*
~~~

最后可以通过openOCD工具来对开发板进行烧录[[openOCD]]，并进行调试。

# objdump反汇编用法
objdump是用查看目标文件或者可执行的目标文件的构成的GCC工具
objdump -x obj 
以某种分类信息的形式把目标文件的数据组织（被分为几大块）输出 <可查到该文件的所有动态库>
objdump -t obj 输出目标文件的符号表()
objdump -h obj 输出目标文件的所有段概括()
objdump -S obj C语言与汇编语言同时显示

