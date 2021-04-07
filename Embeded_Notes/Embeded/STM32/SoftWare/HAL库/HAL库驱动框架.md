# HAL库驱动框架
## HAL库驱动框架
### 对外设的封装
xx_HandleTypeDef(xx外设句柄结构体，xx表示任意外设，GPIO、USART等)
#### Instance成员
xx_Typedef
对应的是具体外设的基地址
`如GPIO、I2C，DMA的通道等`
#### Init成员
xx_InitTypeDef
外设对象的工作参数，用于配置外设如何工作
对应xx_Init()函数
#### Hdma\*成员
DMA_HandleTypeDef类型，可能一个句柄结构体有多个
如果外设支持DMA功能，此成员链接至一个具体的DMA通道
#### 其他资源
##### LOCK锁
防止资源竞争，在对外设进行操作时，有些操作室不可以重入的，保证操作的完整性
##### STATUS状态
HAL_xx_StateTypeDef类型，指示外设的状态

### 外设初始化的使用方法
#### HAL_xx_Init
参数一般为xx外设的句柄结构体
将对应外设的相关寄存器配置好
在配置寄存器前，先调用hal_xx_mspinit函数，将底层的相关资源初始化完成
`如时钟、使用到的引脚、中断使能、DMA开启等`

#### HAL_xx_MspInit()
参数一般为外设的句柄结构体
用于初始化底层硬件
#### 其他init方法...
看How to use this driver，了解具体外设库如何使用

![[Pasted image 20210312192637.png]]

### 外设的使用逻辑
#### 阻塞轮询(询问是否已准备)
xx_start
xx_read\\write
等等函数，传入参数需要一个Timeout参数
#### 中断
如果外设已经准备，或者状态改变，可以发送一个中断，从而不用查询
xx_start_it	-> HAL_XX_IRQHandler ---- 各种HAL_xx_xxCallback
xx_read\\write_it
xx_xx_it等等中断启动函数

#### DMA
xx_start_dma DMA功能
xx_read\\write_DMA
xx_xx_DMA等等DMA启动函数

#### 其他功能
标志查询、清除
中断功能的使能和失能，时钟的使能和失能
+ \__HAL_xxENABLE_IT
+ \__HAL_xx_GET_FLAG
+ 等等

### 对HAL库驱动全面了解
**看How to use this driver**


## 总结:
1. 定义并填充xxx外设句柄结构体
2. 如果遵循HAL库规范，通过HAL_xx_MspInit函数，实现外设底层硬件资源的初始化
3. 调用HALu的对应外设初始化函数
4. 使用外设




