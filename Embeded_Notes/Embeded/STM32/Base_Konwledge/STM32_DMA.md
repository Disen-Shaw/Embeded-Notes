### DMA 简介

直接存储器访问
可以不用CPU的情况下可以把数据从一个地方搬到另一个地方
### DMA1
有7个通道
+ Memory->Memory
+ Memory->Peripherial
+ Peripherial->Memory

DMA2只存在于大容量的芯片中
### 多个DMA同时使用时优先级划分
1. 软件阶段，看DMA寄存器CRRx的PL[ 1 0 ]位
2. 硬件阶段，通道编号小的优先级大
   低通道的优先级高于高通道的
   DMA1的优先级高于DMA2
   
[[STM32_DMA编程]]