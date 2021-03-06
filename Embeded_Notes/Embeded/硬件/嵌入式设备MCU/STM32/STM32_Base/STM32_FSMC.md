---
date updated: '2021-10-03T09:31:55+08:00'

---

# STM32外设FSMC

## FSMC简介

STM32F1系列及F407芯片使用FSMC外设来管理扩展的存储器，FSMC是`flexible Static Memory Controller`的缩写，译为灵活的静态存储控制器。它可以用于驱动包括SRAm、Nor-Flash以及Nand-Flash类型的存储器，不能驱动SDRAM这种的动态的存储器。
在STM32F429以及7系列的控制器中，它具有FMC外设，支持控制SDRAM控制器

### FSMC与FMC区别

FSMC用于控制静态器件(SRAM)，不可以控制动态器件(SDRAM)
FMC都可以

## FSMC框图

![Pasted image 20210613023118](../../../../../pictures/Pasted%20image%2020210613023118.png)
主要分为三个部分：

- 通讯引脚
- 存储器控制器
- 时钟控制逻辑

### 通讯引脚

由于控制不同类型存储器的时候会有一些不同的引脚，看起来有非常多，其中
地址线`FSMC_A`
数据线`FSMC_D`
是所有控制器都共用的

| FSMC引脚名称      | 对应SRAM引脚  | 说明        |
| ------------- | --------- | --------- |
| FSMC_NBL[1:0] | LB#、UB#   | 数据掩码信号    |
| FSMC_A[18:0]  | A[18:0]   | 行地址线      |
| FSMC_D[15:0]  | I/O[15:0] | 数据线       |
| FSMC_NWE      | WE#       | 写入使能      |
| FSMC_NOE      | OE#       | 输出使能(读使能) |
| FSMC_NE[1:4]  | CE#       | 片选信号      |

其中比较特殊的FSMC_NE是用于控制SRAM芯片的控制信号线，STM32具有FSMC_NE1/2/3/4号引脚，不同的引脚对应STM32内部不同的地址区域

例如当STM32访问0x68000000-0x6bFFFFFFF地址空间时，FSMC_NE3引脚会自动设置为低电平，由于它连接到SRAM的CE#引脚，所以SRAM的片选被使能，而访问0x60000000-0x63FFFFFF地址时，FSMC_NE1会输出低电平。当使用不同的FSMC_NC引脚连接外部存储器时，STM32访问SRAM的地址不一样，从而达到控制多块SRAM芯片的目的。

## FSMC的地址映射

FSMC连接好外部的粗初期并初始化后，就可以直接通过**访问地址(C语言指针)来读写数据**
FSMC访问存储器的方式与I2C->EEPROM、SPI->Flash不一样，后两种方式都需要控制I2C或者SPI总线给存储器发送地址，然后读取数据。在程序里，这个地址和数据都需要分开使用不同的变量存储，并且访问时还需要使用代码控制发送命令
而使用FSMC外界存储器时，其存储单元是映射到STM32的内部寻址空间的在程序里，定义一个指向这些地址的指针，然后就可以通过指针直接修改存储单元的内容，**FSMC外设会自动完成数据访问的过程**，读写命令之类的不需要程序控制

FSMC把整个External RAM存储区域分成了四个Bank区域，并分配了地址范围及适用的存储器类型，如Nor-Flash及SRAM存储器只能使用Bank1的地址

![Pasted image 20210613031418](../../../../../pictures/Pasted%20image%2020210613031418.png)
在Nor-Flash及SRAank的内部又分成了四个小块，每个小块有对应的控制引脚用于连接片选信号，如FSMC_NE[4:1]信号线可用于选择Bank1内部的4小块区域
当STM32访问0x68000000-0x6BFFFFFF地址空间时，会访问到Bank1的第三小块区域，相应的FSMC_NE3信号线会输出控制信号

## FSMC使用

- 初始化FSMC外设
  - 配置好FSMC控制器中的Nor/PSRAM控制寄存器即可

- 访问拓展出来的内存
  - 使用指针操作访问拓展处理的内存
