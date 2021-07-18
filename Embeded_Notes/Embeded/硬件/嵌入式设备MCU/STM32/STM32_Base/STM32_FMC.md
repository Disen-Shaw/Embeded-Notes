# STM32的FMC
## FMC简介
一些高级的芯片采用FMC外设来管理扩展的存储器(主要是SDRAM)
FMC是Flexible Memory Controller的缩写，以为可变存储控制器
他可以用于驱动包括SRAM、SDRAM、Nor-Flash以及Nand-Flash类型的存储器

## 框图剖析
![[Pasted image 20210614033411.png]]
+ 通讯引脚
+ 存储器控制器
+ 时钟控制逻辑

### 通讯引脚
由于不同类型存储器有的时候会有一些不同的引脚，看起来有非常多，其中地址线FMC_A和数据线FMC_D是所有控制器共用的

| FMC引脚名称     | 对应SDRAM引脚名 | 说明                                                            |
| --------------- | --------------- | --------------------------------------------------------------- |
| FMC_NBL\[3:0]   | DQM\[3:0]       | 数据掩码信号                                                    |
| FMC_A\[12:0]    | A\[12:0]        | 行、列地址                                                      |
| FMC_A\[15:14]   | BA\[1:0]        | Bank地址线                                                      |
| FMC_D\[31:0]    | DQ\[31:0]       | 数据线                                                          |
| FMC_SDCLK       | CLK             | 同步时钟信号                                                    |
| FMC_DSNWE       | WE#             | 写入使能                                                        |
| FMC_SDCKE\[1:0] | CKE             | SDCKE0:SDRAM存储区域1时钟使能</br>SDCKE1:SDRAM存储区域2时钟使能 |
| FMC_SDNE\[1:0]  | ...             | SDNE0:SDRM存储区域1芯片使能</br>SDNE1:SDRM存储区域1芯片使能     |
| FMC_NRAS        | RAS#            | 行地址选通信号                                                  |
| FMC_NCAS        | CAS#            | 列地址选通信号                                                                |

具体要使用多少根线与实际硬件有关

## 存储器控制器
Nor-Flash、PSRAM、SRAM设备使用相同的控制器
Nand-Flash、PC卡设备使用相同的控制器
SDRAM控制器使用独立的控制器
不同的控制器有专门的寄存器用于配置工作模式

## FMC的地址映射
和FSMC类似
使用FMC外接存储器时，其存储单元是映射到STM32的内部寻址空间的
在程序里，定义一个指向这些地址的指针，然后就可以通过指针直接修改存储单元的内容，FMC外设会自动完成数据访问过程，读写命令之类的操作不需要程序控制

当程序里控制内核访问这些地址空间时，FMC外设会产生对应的时序，对它外接SDRAM芯片进行读写

## External RAM与External Device的区别
STM32 FMC外设的地址映射，可以看到FMC的Nor-Flash、PSRAM、SRAM、Nand—Flash以及PC卡的地址都在External RAM地址空间内，而SDRAM的地址是分配到External device区域的

External RAM区：这个区域可以直接执行代码，支持XIP
Externam Device区：不支持XIP功能

通过配置"SYSCFG_MEMRMP"寄存器的"SWP_FMC"寄存器位可以用于交换SDRAM与Nand-Flash、PC卡的地址映射，使得存储在SDRAM中的代码能被执行，只是犹豫SDRAM的最高同步时钟会受到限制，代码在SDRAM中执行的速度会受到影响

![[Pasted image 20210614210355.png]]

**主要还是查手册**
SDRAM主要配置控制的参数配置和时钟的参数配置

