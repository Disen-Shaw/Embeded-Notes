## STM32_SPI编程
### SPI初始化结构体
~~~c
typedef struct
{
	uint16_t SPI_Direction;					/*设置 SPI 的单双向模式 */
	uint16_t SPI_Mode;						/*设置 SPI 的主/从机端模式 */	
	uint16_t SPI_DataSize;					/*设置 SPI 的数据帧长度,可选 8/16 位 */
	uint16_t SPI_CPOL;						/*设置时钟极性 CPOL,可选高/低电平*/
	uint16_t SPI_CPHA;						/*设置时钟相位,可选奇/偶数边沿采样 */
	uint16_t SPI_NSS;						/*设置 NSS 引脚由 SPI 硬件控制还是软件控制*/
	uint16_t SPI_BaudRatePrescaler;			/*设置时钟分频因子,fpclk/分频数=fSCK */
	uint16_t SPI_FirstBit;					/*设置 MSB/LSB 先行 */
	uint16_t SPI_CRCPolynomial;				/*设置 CRC 校验的表达式 */
}SPI_InitTypeDef;
~~~

配置后用SPI_Init()函数初始化，然后用SPI_Cmd()来使能外设

SPI 读写串行flash芯片
FLSAH 存储器又称闪存,它与 EEPROM 都是掉电后数据不丢失的存储器
FLASH存储器容量普遍大于 EEPROM

### 硬件设计
![[Pasted image 20210310131912.png]]

本实验板中的 FLASH 芯片(型号:W25Q64)是一种使用 SPI 通讯协议的 NOR FLASH存 储 器
它的 CS/CLK/DIO/DO 引 脚 分 别 连 接 到 了 STM32 对 应 的 SPI 引 脚NSS/SCK/MOSI/MISO 上
其中 STM32 的 NSS 引脚是一个普通的 GPIO
程序中使用软件控制的方式

### 编程要点
+ 初始化通讯使用的目标引脚及端口时钟;
+ 使能 SPI 外设的时钟;
+ 配置 SPI 外设的模式、地址、速率等参数并使能 SPI 外设;
+ 编写基本 SPI 按字节收发的函数;
+ 编写对 FLASH 擦除及读写操作的的函数;
+ 编写测试程序,对读写数据进行校验。

宏定义
~~~c
/*SPI 接口定义-开头****************************/
#define FLASH_SPIx SPI1
#define FLASH_SPI_APBxClock_FUN RCC_APB2PeriphClockCmd
#define FLASH_SPI_CLK RCC_APB2Periph_SPI1

//CS(NSS)引脚 片选选普通 GPIO 即可
#define FLASH_SPI_CS_APBxClock_FUN RCC_APB2PeriphClockCmd
#define FLASH_SPI_CS_CLK RCC_APB2Periph_GPIOC
#define FLASH_SPI_CS_PORT GPIOC

//SCK 引脚
#define FLASH_SPI_SCK_APBxClock_FUN RCC_APB2PeriphClockCmd
#define FLASH_SPI_SCK_CLK RCC_APB2Periph_GPIOA
#define FLASH_SPI_SCK_PORT GPIOA
#define FLASH_SPI_SCK_PIN GPIO_Pin_5

//MISO 引脚
#define FLASH_SPI_MISO_APBxClock_FUN RCC_APB2PeriphClockCmd
#define FLASH_SPI_MISO_CLK RCC_APB2Periph_GPIOA
#define FLASH_SPI_MISO_PORT GPIOA
#define FLASH_SPI_MISO_PIN GPIO_Pin_6

//MOSI 引脚
#define FLASH_SPI_MOSI_APBxClock_FUN RCC_APB2PeriphClockCmd
#define FLASH_SPI_MOSI_CLK RCC_APB2Periph_GPIOA
#define FLASH_SPI_MOSI_PORT GPIOA
#define FLASH_SPI_MOSI_PIN GPIO_Pin_7

#define FLASH_SPI_CS_LOW() GPIO_ResetBits( FLASH_SPI_CS_PORT, FLASH_SPI_CS_PIN )
#define FLASH_SPI_CS_HIGH() GPIO_SetBits( FLASH_SPI_CS_PORT, FLASH_SPI_CS_PIN )

/*SPI 接口定义-结尾****************************/
~~~

SPI_FLASH初始化
~~~c
void SPI_FLASH_Init(void)
{
	SPI_InitTypeDef SPI_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;
	/* 使能 SPI 时钟 */
	FLASH_SPI_APBxClock_FUN ( FLASH_SPI_CLK, ENABLE );
	/* 使能 SPI 引脚相关的时钟 */
	FLASH_SPI_CS_APBxClock_FUN ( FLASH_SPI_CS_CLK|FLASH_SPI_SCK_CLK|FLASH_SPI_MISO_PIN|FLASH_SPI_MOSI_PIN, ENABLE );
	/* 配置 SPI 的 CS 引脚,普通 IO 即可 */
	GPIO_InitStructure.GPIO_Pin = FLASH_SPI_CS_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(FLASH_SPI_CS_PORT, &GPIO_InitStructure);
	
	/* 配置 SPI 的 SCK 引脚*/
	GPIO_InitStructure.GPIO_Pin = FLASH_SPI_SCK_PIN;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_Init(FLASH_SPI_SCK_PORT, &GPIO_InitStructure);
	
	/* 配置 SPI 的 MOSI 引脚*/
	GPIO_InitStructure.GPIO_Pin = FLASH_SPI_MOSI_PIN;
	GPIO_Init(FLASH_SPI_MOSI_PORT, &GPIO_InitStructure);
	/* 停止信号 FLASH: CS 引脚高电平*/
	FLASH_SPI_CS_HIGH();
	
	// FLASH 芯片 支持 SPI 模式 0 及模式 3,据此设置 CPOL CPHA
	SPI_InitStructure.SPI_Direction = SPI_Direction_2Lines_FullDuplex;
	SPI_InitStructure.SPI_Mode = SPI_Mode_Master;
	SPI_InitStructure.SPI_DataSize = SPI_DataSize_8b;
	SPI_InitStructure.SPI_CPOL = SPI_CPOL_High;
	SPI_InitStructure.SPI_CPHA = SPI_CPHA_2Edge;
	SPI_InitStructure.SPI_NSS = SPI_NSS_Soft;
	SPI_InitStructure.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_4;
	SPI_InitStructure.SPI_FirstBit = SPI_FirstBit_MSB;
	SPI_InitStructure.SPI_CRCPolynomial = 7;
	SPI_Init(FLASH_SPIx, &SPI_InitStructure);
	/* 使能 SPI */
	SPI_Cmd(FLASH_SPIx, ENABLE);
}
~~~
向flash中发送一个字节数据
~~~c
uint8_t SPI_FLASH_SendByte(uint8_t byte)
{
	SPITimeout = SPIT_FLAG_TIMEOUT;
	/* 等待发送缓冲区为空,TXE 事件 */
	while (SPI_I2S_GetFlagStatus(FLASH_SPIx, SPI_I2S_FLAG_TXE) == RESET)
	{
		if ((SPITimeout--) == 0) return SPI_TIMEOUT_UserCallback(0);
	}
	/* 写入数据寄存器,把要写入的数据写入发送缓冲区 */
	SPI_I2S_SendData(FLASH_SPIx, byte);
	
	
	SPITimeout = SPIT_FLAG_TIMEOUT;
	/* 等待接收缓冲区非空,RXNE 事件 */
	while (SPI_I2S_GetFlagStatus(FLASH_SPIx, SPI_I2S_FLAG_RXNE) == RESET)
	{
		if ((SPITimeout--) == 0) return SPI_TIMEOUT_UserCallback(1);
	}
	
	
	/* 读取数据寄存器,获取接收缓冲区数据 */
	return SPI_I2S_ReceiveData(FLASH_SPIx);
}
~~~
读取发送字节后Flash返回的数据
~~~c
u8 SPI_FLASH_ReadByte(void)
{
	return (SPI_FLASH_SendByte(Dummy_Byte));
}
~~~
Flash常用指令
![[Pasted image 20210310134059.png]]
配合指令完成时序
![[Pasted image 20210310134147.png]]
flash 常用指令定义
~~~c
/*FLASH 常用命令*/	
#define W25X_WriteEnable			0x06
#define W25X_WriteDisable			0x04
#define W25X_ReadStatusReg			0x05
#define W25X_WriteStatusReg			0x01
#define W25X_ReadData				0x03
#define W25X_FastReadData			0x0B
#define W25X_FastReadDual			0x3B
#define W25X_PageProgram			0x02
#define W25X_BlockErase				0xDB
#define W25X_SectorErase			0x20
#define W25X_ChipErase				0xC7
#define W25X_PowerDown				0xB9
#define W25X_ReleasePowerDown		0xAB
#define W25X_DeviceID				0xAB
#define W25X_ManufactDeviceID		0x90
#define W25X_JedecDeviceID			0x9F
/*其它*/
#define sFLASH_ID					0XEF4017
#define Dummy_Byte					0xFF
~~~
读取flash 的 ID
~~~c
uint32_t SPI_FLASH_ReadID(void)
{
	uint32_t Temp = 0, Temp0 = 0, Temp1 = 0, Temp2 = 0;
	/* 开始通讯:CS 低电平 */
	SPI_FLASH_CS_LOW();
	/* 发送 JEDEC 指令,读取 ID */
	SPI_FLASH_SendByte(W25X_JedecDeviceID);
	/* 读取一个字节数据 */
	Temp0 = SPI_FLASH_SendByte(Dummy_Byte);
	/* 读取一个字节数据 */
	Temp1 = SPI_FLASH_SendByte(Dummy_Byte);
	/* 读取一个字节数据 */
	Temp2 = SPI_FLASH_SendByte(Dummy_Byte);
	/* 停止通讯:CS 高电平 */
	SPI_FLASH_CS_HIGH();
	/*把数据组合起来,作为函数的返回值*/
	Temp = (Temp0 << 16) | (Temp1 << 8) | Temp2;
	return Temp;
}
~~~
向flash发送写使能命令
~~~c
void SPI_FLASH_WriteEnable(void)
{
	/* 通讯开始:CS 低 */
	SPI_FLASH_CS_LOW();
	/* 发送写使能命令*/
	SPI_FLASH_SendByte(W25X_WriteEnable);
	/*通讯结束:CS 高 */
	SPI_FLASH_CS_HIGH();
}
~~~
通过读取Flash的状态信息位来等待flash空闲
~~~c
void SPI_FLASH_WaitForWriteEnd(void)
{
	uint8_t FLASH_Status = 0;
	/* 选择 FLASH: CS 低 */
	SPI_FLASH_CS_LOW();
	/* 发送 读状态寄存器 命令 */
	SPI_FLASH_SendByte(W25X_ReadStatusReg);
	/* 若 FLASH 忙碌,则等待 */
	do
	{
		/* 读取 FLASH 芯片的状态寄存器 */
		FLASH_Status = SPI_FLASH_SendByte(Dummy_Byte);
	}
	while ((FLASH_Status & WIP_Flag) == SET); /* 正在写入标志 */
	/* 停止信号 FLASH: CS 高 */
	SPI_FLASH_CS_HIGH();
~~~

#### FLASH扇区擦除
![[Pasted image 20210310135138.png]]

FLASH 芯片的最小擦除单位为扇区(Sector),而一个块(Block)包含16个扇区
![[Pasted image 20210310135213.png]]

flash擦除扇区
~~~c
void SPI_FLASH_SectorErase(u32 SectorAddr)
{
	/* 发送 FLASH 写使能命令 */
	SPI_FLASH_WriteEnable();
	SPI_FLASH_WaitForWriteEnd();
	/* 擦除扇区 */
	/* 选择 FLASH: CS 低电平 */
	SPI_FLASH_CS_LOW();
	/* 发送扇区擦除指令*/
	SPI_FLASH_SendByte(W25X_SectorErase);
	
	/*发送擦除扇区地址的高位*/
	SPI_FLASH_SendByte((SectorAddr & 0xFF0000) >> 16);
	/* 发送擦除扇区地址的中位 */
	SPI_FLASH_SendByte((SectorAddr & 0xFF00) >> 8);
	/* 发送擦除扇区地址的低位 */
	SPI_FLASH_SendByte(SectorAddr & 0xFF);
	/* 停止信号 FLASH: CS 高电平 */
	
	SPI_FLASH_CS_HIGH();
	/* 等待擦除完毕*/
	SPI_FLASH_WaitForWriteEnd();
}
~~~

flash 页写入
~~~c
void SPI_FLASH_PageWrite(u8 *pBuffer, u32_t WriteAddr, u16 NumByteToWrite)
{
	/* 发送 FLASH 写使能命令 */
	SPI_FLASH_WriteEnable();
	/* 选择 FLASH: CS 低电平 */
	SPI_FLASH_CS_LOW();
	/* 写送写指令*/
	SPI_FLASH_SendByte(W25X_PageProgram);
	/*发送写地址的高位*/
	SPI_FLASH_SendByte((WriteAddr & 0xFF0000) >> 16);
	/*发送写地址的中位*/
	SPI_FLASH_SendByte((WriteAddr & 0xFF00) >> 8);
	/*发送写地址的低位*/
	SPI_FLASH_SendByte(WriteAddr & 0xFF);
	if (NumByteToWrite > SPI_FLASH_PerWritePageSize)
	{
		NumByteToWrite = SPI_FLASH_PerWritePageSize;
		FLASH_ERROR("SPI_FLASH_PageWrite too large!");
	}
	/* 写入数据*/
	while (NumByteToWrite--)
	{
		/* 发送当前要写入的字节数据 */
		SPI_FLASH_SendByte(*pBuffer);
		/* 指向下一字节数据 */
		pBuffer++;
	}
	/* 停止信号 FLASH: CS 高电平 */
	SPI_FLASH_CS_HIGH();
	/* 等待写入完毕*/
	SPI_FLASH_WaitForWriteEnd();
	}
~~~
不定量数据写入
~~~c
void SPI_FLASH_BufferWrite(u8* pBuffer, u32 WriteAddr, u16 NumByteToWrite)
{
	u8 NumOfPage = 0, NumOfSingle = 0, Addr = 0, count = 0, temp = 0;
	/*mod 运算求余,若 writeAddr 是 SPI_FLASH_PageSize 整数倍,运算结果 Addr 值为 0*/
	Addr = WriteAddr % SPI_FLASH_PageSize;
	/*差 count 个数据值,刚好可以对齐到页地址*/
	count = SPI_FLASH_PageSize - Addr;
	/*计算出要写多少整数页*/
	NumOfPage = NumByteToWrite / SPI_FLASH_PageSize;
	/*mod 运算求余,计算出剩余不满一页的字节数*/
	NumOfSingle = NumByteToWrite % SPI_FLASH_PageSize;
	/* Addr=0,则 WriteAddr 刚好按页对齐 aligned */
	if (Addr == 0)
	{
		/* NumByteToWrite < SPI_FLASH_PageSize */
		if (NumOfPage == 0)
		{
			SPI_FLASH_PageWrite(pBuffer, WriteAddr,NumByteToWrite);
		}
		else /* NumByteToWrite > SPI_FLASH_PageSize */
		{
			/*先把整数页都写了*/
			while (NumOfPage--)
			{
				SPI_FLASH_PageWrite(pBuffer, WriteAddr,SPI_FLASH_PageSize);
				WriteAddr += SPI_FLASH_PageSize;
				pBuffer += SPI_FLASH_PageSize;
			}
			SPI_FLASH_PageWrite(pBuffer, WriteAddr,NumOfSingle);
		}
	}
	/* 若地址与 SPI_FLASH_PageSize 不对齐 */
	else
	{
		/* NumByteToWrite < SPI_FLASH_PageSize */
		if (NumOfPage == 0)
		{
			/*当前页剩余的 count 个位置比 NumOfSingle 小,一页写不完*/
			if (NumOfSingle > count)
			{
				temp = NumOfSingle - count;
				/*先写满当前页*/
				SPI_FLASH_PageWrite(pBuffer, WriteAddr, count);
				WriteAddr += count;
				pBuffer += count;
				/*再写剩余的数据*/
				SPI_FLASH_PageWrite(pBuffer, WriteAddr, temp);
			}
			else /*当前页剩余的 count 个位置能写完 NumOfSingle 个数据*/
			{
				SPI_FLASH_PageWrite(pBuffer, WriteAddr,
				NumByteToWrite);
			}	
		}
		else /* NumByteToWrite > SPI_FLASH_PageSize */
		{
			/*地址不对齐多出的 count 分开处理,不加入这个运算*/
			NumByteToWrite -= count;
			NumOfPage = NumByteToWrite / SPI_FLASH_PageSize;
			NumOfSingle = NumByteToWrite % SPI_FLASH_PageSize;
			/* 先写完 count 个数据,为的是让下一次要写的地址对齐 */
			SPI_FLASH_PageWrite(pBuffer, WriteAddr, count);
			/* 接下来就重复地址对齐的情况 */
			WriteAddr += count;
			pBuffer += count;
			/*把整数页都写了*/
			while (NumOfPage--)
			{
				SPI_FLASH_PageWrite(pBuffer, WriteAddr,
				SPI_FLASH_PageSize);
				WriteAddr += SPI_FLASH_PageSize;
				pBuffer += SPI_FLASH_PageSize;
			}
			if (NumOfSingle != 0)
			{
				SPI_FLASH_PageWrite(pBuffer, WriteAddr,
				NumOfSingle);
			}
		}
	}
}
~~~
从flash中读数据
~~~c
void SPI_FLASH_BufferRead(u8* pBuffer, u32 ReadAddr, u16 NumByteToRead)
{
	/* 选择 FLASH: CS 低电平 */
	SPI_FLASH_CS_LOW();
	/* 发送 读 指令 */
	SPI_FLASH_SendByte(W25X_ReadData);
	/* 发送 读 地址高位 */
	SPI_FLASH_SendByte((ReadAddr & 0xFF0000) >> 16);
	/* 发送 读 地址中位 */
	SPI_FLASH_SendByte((ReadAddr& 0xFF00) >> 8);
	/* 发送 读 地址低位 */
	SPI_FLASH_SendByte(ReadAddr & 0xFF);
	/* 读取数据 */
	while (NumByteToRead--)
	{
	/* 读取一个字节*/
	*pBuffer = SPI_FLASH_SendByte(Dummy_Byte);
	/* 指向下一个字节缓冲区 */
	pBuffer++;
	}
	/* 停止信号 FLASH: CS 高电平 */
	SPI_FLASH_CS_HIGH();
}
~~~
由于读取的数据量没有限制,所以发送读命令后一直接收 NumByteToRead 个数据到结束即可。