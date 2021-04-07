## STM32_DMA编程
### 标准库
~~~c
/* 初始化结构体 */
typedef struct
{
    uint32_t DMA_PeripheralBaseAddr;		// 外设地址
    uint32_t DMA_MemoryBaseAddr;			// 存储器地址
    uint32_t DMA_DIR;						// 传输方向
    uint32_t DMA_BufferSize;				// 传输数目
    uint32_t DMA_PeripheralInc;				// 外设地址增量模式
    uint32_t DMA_MemoryInc;					// 存储器地址增量模式
    uint32_t DMA_PeripheralDataSize;		// 外设数据宽度
    uint32_t DMA_MemoryDataSize;			// 存储器数据宽度
    uint32_t DMA_Mode;						// 模式选择
    uint32_t DMA_Priority;					// 通道优先级
    uint32_t DMA_M2M;						// 存储器到存储器模式
} DMA_InitTypeDef;
~~~
### 编程思想
1. 数据从哪里来，要到哪里去

~~~c
uint32_t DMA_PeripheralBaseAddr;			// 外设地址			DMA_CPAR
uint32_t DMA_MemoryBaseAddr;				// 存储器地址		DMA_CMAR
uint32_t DMA_DIR;							// 传输方向			DMA_CCR:DIR
~~~
2. 数据传输多少，传输的单位是什么

~~~c
uint32_t DMA_BufferSize;					// 传输数目				DMA_CNDTR
uint32_t DMA_PeripheralInc;					// 外设地址增量模式	     DMA_CRRx:PINC
uint32_t DMA_MemoryInc;						// 存储器地址增量模式	DMA_CRRx:MINC
uint32_t DMA_PeripheralDataSize;			// 外设数据宽度		 DMA_CRRx:PSIZE
uint32_t DMA_MemoryDataSize;				// 存储器数据宽度		DMA_CRRx:MSIZE
~~~
3. 什么时候传输结束

~~~c
uint32_t DMA_Mode;							
~~~

### 编程示例

~~~c
Memory->Memory
Flash->SRAM
*/
/* 编程要点
 * 1. 在flash内部定义好数据，在SRAM中定义好接收flash数据的变量
 * 2. 初始化DMA
 * 3. 编写比较函数
 * 4. 编写main函数
*/
/*

#define DMA_CHANNEL DMA1_Channel6
#define DMA_CLOCK RCC_AHBPeriph_DMA1 	// 传输完成标志
#define DMA_FLAG_TC DMA1_FLAG_TC6 		// 要发送的数据大小
#define BUFFER_SIZE 32

/* 定义 aSRC_Const_Buffer 数组作为 DMA 传输数据源
* const 关键字将 aSRC_Const_Buffer 数组变量定义为常量类型
* 表示数据存储在内部的 FLASH 中
*/
const uint32_t aSRC_Const_Buffer[BUFFER_SIZE]=
{
	0x01020304,0x05060708,0x090A0B0C,0x0D0E0F10,
	0x11121314,0x15161718,0x191A1B1C,0x1D1E1F20,
	0x21222324,0x25262728,0x292A2B2C,0x2D2E2F30,
	0x31323334,0x35363738,0x393A3B3C,0x3D3E3F40,
	0x41424344,0x45464748,0x494A4B4C,0x4D4E4F50,
	0x51525354,0x55565758,0x595A5B5C,0x5D5E5F60,
	0x61626364,0x65666768,0x696A6B6C,0x6D6E6F70,
	0x71727374,0x75767778,0x797A7B7C,0x7D7E7F80
};

/* 定义 DMA 传输目标存储器 存储在内部的 SRAM 中 */
uint32_t aDST_Buffer[BUFFER_SIZE];		

/* DMA初始化 */
void DMA_Config(void)
{
	DMA_InitTypeDef DMA_InitStructure;
	// 开启DMA时钟
	RCC_AHBPeriphClockCmd(DMA_CLOCK,ENABLE);
	// 源数据地址
	DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)aSRC_Const_Buffer；
	// 目标地址
	DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)aDST_Buffer;
	// 方向:外设到存储器(这里的外设是内部的 FLASH)
	DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralSRC;
	// 传输大小
	DMA_InitStructure.DMA_BufferSize = BUFFER_SIZE;
	// 外设(内部的 FLASH)地址递增
	DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Enable;
	// 内存地址递增
	DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
	// 外设数据单位
	DMA_InitStructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_Word;
	// 内存数据单位
	DMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_Word;
	// DMA 模式,一次或者循环模式
	DMA_InitStructure.DMA_Mode = DMA_Mode_Normal ;
	//DMA_InitStructure.DMA_Mode = DMA_Mode_Circular;
	// 优先级:高
	DMA_InitStructure.DMA_Priority = DMA_Priority_High;
	// 使能内存到内存的传输
	DMA_InitStructure.DMA_M2M = DMA_M2M_Enable;
	// 配置 DMA 通道
	DMA_Init(DMA_CHANNEL, &DMA_InitStructure);
	// 使能 DMA
	DMA_Cmd(DMA_CHANNEL,ENABLE);
}

/* Flash数据移动向SRAM */
uint8_t Buffercmp(const uint32_t* pBuffer,uint32_t* pBuffer1, uint16_t BufferLength)
{
	/* 数据长度递减 */
	while (BufferLength--) 
	{
		if (*pBuffer != *pBuffer1) 
		{
			/* 对应数据源不相等马上退出函数,并返回 0 */
			return 0;
		}	
		/* 递增两个数据源的地址指针 */
		pBuffer++;
		pBuffer1++;
	}
	/* 完成判断并且对应数据相对 */
	return 1;
}

/* 内存数据移动向外设 */

// 串口工作参数宏定义
#define DEBUG_USARTx USART1
#define DEBUG_USART_CLK RCC_APB2Periph_USART1
#define DEBUG_USART_APBxClkCmd RCC_APB2PeriphClockCmd
#define DEBUG_USART_BAUDRATE 115200

// GPIO引脚定义
#define DEBUG_USART_GPIO_CLK (RCC_APB2Periph_GPIOA)
#define DEBUG_USART_GPIO_APBxClkCmd RCC_APB2PeriphClockCmd

#define DEBUG_USART_TX_GPIO_PORT GPIOA
#define DEBUG_USART_TX_GPIO_PIN GPIO_Pin_9
#define DEBUG_USART_RX_GPIO_PORT GPIOA
#define DEBUG_USART_RX_GPIO_PIN GPIO_Pin_10

// 串口对应的 DMA 请求通道
#define USART_TX_DMA_CHANNEL DMA1_Channel4
// 外设寄存器地址
#define USART_DR_ADDRESS (USART1_BASE+0x04)
#define SENDBUFF_SIZE 5000

void USARTx_DMA_Config(void)
{
	DMA_InitTypeDef DMA_InitStructure;
	// 开启DMA时钟
	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1,ENABLE);
	// 源数据地址
	DMA_InitStructure.DMA_PeripheralBaseAddr = USART_DR_ADDRESS；
	// 目标地址
	DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)SendBuff;
	// 方向:外设到存储器
	DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralDST;
	// 传输大小
	DMA_InitStructure.DMA_BufferSize = SENDBUFF_SIZE;;
	// 外设(内部的 FLASH)地址递增
	DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
	// 内存地址递增
	DMA_InitStructure.DMA_MemoryInc = DMA_PeripheralDataSize_Byte;
	// 外设数据单位
	DMA_InitStructure.DMA_PeripheralDataSize = DMA_MemoryDataSize_Byte;
	// 内存数据单位
	DMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_Word;
	// DMA 模式,一次或者循环模式
	DMA_InitStructure.DMA_Mode = DMA_Mode_Normal ;
	//DMA_InitStructure.DMA_Mode = DMA_Mode_Circular;
	// 优先级:高
	DMA_InitStructure.DMA_Priority = DMA_InitStructure.DMA_Priority = DMA_Priority_Medium;
	// 使能内存到内存的传输
	DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;
	// 配置 DMA 通道
	DMA_Init(USART_TX_DMA_CHANNEL, &DMA_InitStructure);
	// 使能 DMA
	DMA_Cmd(USART_TX_DMA_CHANNEL,ENABLE);
}


~~~
