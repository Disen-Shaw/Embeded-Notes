# i.MX系列处理器介绍
## i.MX系列处理器
### 在日常开发工作中了解和挑选芯片
在[网站](https://www.nxp.com)上可以找一些芯片的推荐
关键参数
+ 性能稳定性
+ 资料齐全
+ 芯片内部资源
+ 开发工具
+ 供货周期
+ 性价比
+ 运行环境

### i.MX系列处理器
可以在上面的网站中找到系列的芯片
[火哥](https://www.bilibili.com/video/BV1JK4y1t7io?p=4&spm_id_from=pageDriver)介绍

## ARM体系架构
### 指令集
CPU硬件与软件之间的接口描述
+ RISC：8051、x86
+ CISC：ARM/MIPS/PISC-V
	+ ARM发展:ARMV1-ARM-V8
	+ ARMV7指令集:A/R/M

+ MIPS
+ PISC-V

### 架构
主要指某一个处理器所使用的具体指令集
例如iMX6ULL是ARMV7架构的


### 处理器/内核
指令集是实物化

### 芯片
多指SOC，由内核+其他模块封装在一起组成


## Cortex A7内核简介
支持1-4核，常用于 big.LITTLE架构
性能与功耗平衡
### iMX RT简介
功能丰富
实时性强
功耗低
跨界处理器
与iMX 6ULL外设高度相似，适合学习裸机开发

