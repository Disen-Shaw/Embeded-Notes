# STM32串口知识
### 引脚
TX：数据发送
RX：数据接受
SCLK：时钟
nRTS：请求发送
nCTS：允许发送
### 数据寄存器
USART_DR
9位有效，包含一个发送数据寄存器TDR和一个接受数据寄存器RDR，一个地址对用两个物理内存
这点和51类似

![[Pasted image 20210308223721.png]]

一些重要寄存器
USART_CR1：M
+ 0：8位
+ 1：9位
USART_CR2：STOP
USART_CR1：PCE、PS、PEIE
USART_SR：PE

数据发送和接收的具体流程

一些重要的寄存器
USART_CR1：
+ UE：串口使能，打开USART模块
  0：禁止
  1：使能
+ TE：发送使能
  0：禁止发送
  1：发送功能使能
+ RE：接收使能
  0：禁止接收
  1：接收使能
  
  
[[STM32_串口编程]]
  