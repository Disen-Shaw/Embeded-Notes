# STM32_I2C编程
## I2C初始化结构体
~~~c
typedef struct
{
	uint32_t I2C_ClockSpeed;		// 设置SCL时钟频率，最大400KHz
	uint32_t I2C_Mode;				// 指定工作模式，主从模式
	uint16_t I2C_DutyCycle;			// 指定时钟占空比，可选 low/high = 2:1 及 16:9 模式
	uint16_t I2C_OwnAddress1;		// 指定自身的I2C地址
	uint16_t I2C_Ack;				// 使能或者关闭
	uint16_t I2C_AcknowledgeAddress;// 指定地址的长度，可以设为7位以及10位
} I2C_InitTypeDef;
~~~

## 读写EEPROM实验
### 硬件设计
![[Pasted image 20210309194807.png]]

EEPROM写满一页后要换地址

~~~c
/* 代码宏定义 */
// 引脚定义
#define EEPROM_I2Cx I2C1
#define EEPROM_I2C_APBxClock_FUN RCC_APB1PeriphClockCmd
#define EEPROM_I2C_CLK RCC_APB1Periph_I2C1
#define EEPROM_I2C_GPIO_APBxClock_FUN RCC_APB2PeriphClockCmd
#define EEPROM_I2C_GPIO_CLK RCC_APB2Periph_GPIOB
#define EEPROM_I2C_SCL_PORT GPIOB
#define EEPROM_I2C_SCL_PIN GPIO_Pin_6
#define EEPROM_I2C_SDA_PORT GPIOB
#define EEPROM_I2C_SDA_PIN GPIO_Pin_7

// 工作状态定义

#define I2C_Speed 400000 			// SCL时钟设置 
#define I2Cx_OWN_ADDRESS7 0X0A		// 自身地址 不和总线挂载设备同地址
#define I2C_PageSize 8				// EEPROM每页8个字节


// GPIO 定义
static void I2C_GPIO_Config(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	// 使能与I2C有关的时钟
	EEPROM_I2C_APBxClock_FUN ( EEPROM_I2C_CLK, ENABLE );
	EEPROM_I2C_GPIO_APBxClock_FUN ( EEPROM_I2C_GPIO_CLK, ENABLE );
	// GPIO初始化
	// SCL GPIO初始化
	GPIO_InitStructure.GPIO_Pin = EEPROM_I2C_SCL_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_OD;		// 开漏输出
	GPIO_Init(EEPROM_I2C_SCL_PORT, &GPIO_InitStructure);
	// SDA GPIO初始化
	GPIO_InitStructure.GPIO_Pin = EEPROM_I2C_SDA_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_OD;		// 开漏输出
	GPIO_Init(EEPROM_I2C_SDA_PORT, &GPIO_InitStructure)；
}


// STM32 I2C初始化
static void I2C_Mode_Config(void)
{
	I2C_InitTypeDef I2C_InitStructure;
	/* I2C 配置 */
	I2C_InitStructure.I2C_Mode = I2C_Mode_I2C;
	/* 高电平数据稳定,低电平数据变化 SCL 时钟线的占空比 */
	I2C_InitStructure.I2C_DutyCycle = I2C_DutyCycle_2;
	I2C_InitStructure.I2C_OwnAddress1 =I2Cx_OWN_ADDRESS7;
	I2C_InitStructure.I2C_Ack = I2C_Ack_Enable;
	/* I2C 的寻址模式 */
	I2C_InitStructure.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
	/* 通信速率 */
	I2C_InitStructure.I2C_ClockSpeed = I2C_Speed;
	/* I2C 初始化 */
	I2C_Init(EEPROM_I2Cx, &I2C_InitStructure);
	/* 使能 I2C */
	I2C_Cmd(EEPROM_I2Cx, ENABLE);
}


~~~
~~~c
// EEPROM 函数
void I2C_EEPROM_Init()
{
	I2C_GPIO_Config();
	I2C_Mode_Config();
	/* 选择block0来写入 */ 
	EEPROM_ADDRESS = EEPROM_Block0_ADDRESS;
}


/* 检查超时 */
#define I2CT_FLAG_TIMEOUT ((uint32_t)0x1000)
#define I2CT_LONG_TIMEOUT ((uint32_t)(10 * I2CT_FLAG_TIMEOUT))
static uint32_t I2C_Timeouut_UserCallBack(uint8_t errorCode)
{
	/* 使用串口 printf 输出错误信息,方便调试 */
	EEPROM_ERROR("I2C 等待超时!errorCode = %d",errorCode);
	return 0;
}



// 写一个字节到I2C EEPROM中
uint32_t I2C_EEPROM_ByteWrite(uint8_t *pBuffer,uint8_t WriteAddr)
{
	/* 产生 I2C 起始信号 */
	I2C_GenerateSTART(EEPROM_I2Cx, ENABLE); 	// 库函数
	/*设置超时等待时间*/
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV5 事件并清除标志*/
	while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(0);
	}
	/* 发送 EEPROM 设备地址 */
	I2C_Send7bitAddress(EEPROM_I2Cx, EEPROM_ADDRESS,I2C_Direction_Transmitter);
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	while (!I2C_CheckEvent(EEPROM_I2Cx,I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(1);
	}
	/* 发送要写入的 EEPROM 内部地址(即 EEPROM 内部存储器的地址) */
	I2C_SendData(EEPROM_I2Cx, WriteAddr);
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV8 事件并清除标志*/
	while (!I2C_CheckEvent(EEPROM_I2Cx,I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(2);
	}
	/* 发送一字节要写入的数据 */
	I2C_SendData(EEPROM_I2Cx, *pBuffer);
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV8 事件并清除标志*/
	while (!I2C_CheckEvent(EEPROM_I2Cx,I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(3);
	}
	/* 发送停止信号 */
	I2C_GenerateSTOP(EEPROM_I2Cx, ENABLE);
	return 1;
}

// 多字节数据传输
uint8_t I2C_EEPROM_BytesWrite(uint8_t* pBuffer,uint8_t WriteAddr,uint16_t NumByteToWrite)
{
	uint16_t i;
	uint8_t res;
	/*每写一个字节调用一次 I2C_EE_ByteWrite 函数*/
	for (i=0; i<NumByteToWrite; i++)
	{
		/*等待 EEPROM 准备完毕*/
		I2C_EE_WaitEepromStandbyState();
		/*按字节写入数据*/
		res = I2C_EE_ByteWrite(pBuffer++,WriteAddr++);
	}
	return res;
}

// 等待EEPROM到准备状态
/*
	这个函数主要实现是向 EEPROM 发送它设备地址 ,
	检测 EEPROM 的响应, 若EEPROM接收到地址后返回应答信号,
	则表示 EEPROM 已经准备好,可以开始下一次通讯。
*/
void I2C_EEPROM_WaitEEPROMStandbyState(void)
{
	uint16_t SR1_Tmp = 0;
	do{
		/* 发送起始信号 */
		I2C_GenerateSTART(EEPROM_I2Cx, ENABLE);
		/* 读 I2C1 SR1 寄存器 */
		SR1_Tmp = I2C_ReadRegister(EEPROM_I2Cx, I2C_Register_SR1);
		/* 发送 EEPROM 地址 + 写方向 */
		I2C_Send7bitAddress(EEPROM_I2Cx, EEPROM_ADDRESS,I2C_Direction_Transmitter);
	}
	// SR1位1 
	// ADDR：1表示地址发送成功，0表示地址发送没有结束
	// 等待地址发送成功
	while(!(I2C_ReadRegister(EEPROM_I2Cx, I2C_Register_SR1) & 0x0002));
	// 清除AF位
	I2C_ClearFlag(EEPROM_I2Cx, I2C_FLAG_AF);
	// 发送停止信号
	I2C_GenerateSTOP(EEPROM_I2Cx, ENABLE);
}

~~~
### EEPROM页写入

![[Pasted image 20210309203613.png]]
只输入一个地址信号，后面的数据按序输入
~~~c
uint8_t I2C_EE_PageWrite(uint8_t* pBuffer, uint8_t WriteAddr,uint8_t NumByteToWrite)
{
	I2CTimeout = I2CT_LONG_TIMEOUT;
	while (I2C_GetFlagStatus(EEPROM_I2Cx, I2C_FLAG_BUSY))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(4);
	}
	/* 产生 I2C 起始信号 */
	I2C_GenerateSTART(EEPROM_I2Cx, ENABLE);
	
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV5 事件并清除标志 */
	while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(5);
	}
	/* 发送 EEPROM 设备地址 */
	I2C_Send7bitAddress(EEPROM_I2Cx,EEPROM_ADDRESS,I2C_Direction_Transmitter);
	
	/* 检测 EV6 事件并清除标志*/
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(6);
	}
	
	/* 发送要写入的 EEPROM 内部地址(即 EEPROM 内部存储器的地址) */
	I2C_SendData(EEPROM_I2Cx, WriteAddr);
	
	/* 检测 EV8 事件并清除标志*/
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(7);
	}
	
	/* 循环发送 NumByteToWrite 个数据 */
	while (NumByteToWrite--)
	{
		/* 发送缓冲区中的数据 */
		I2C_SendData(EEPROM_I2Cx, *pBuffer);
		/* 指向缓冲区中的下一个数据 */
		pBuffer++;
		
		/* 检测 EV8 事件并清除标志*/
		I2CTimeout = I2CT_FLAG_TIMEOUT;
		while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT))
		{
			if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(8);
		}
	}
	/* 发送停止信号 */
	I2C_GenerateSTOP(EEPROM_I2Cx, ENABLE);
	return 1;
}

~~~

### 快速写入多字节
~~~c
#define I2C_PageSize 8
void I2C_EE_BufferWrite(u8* pBuffer, u8 WriteAddr,u16 NumByteToWrite)
{
	u8 NumOfPage=0,NumOfSingle=0,Addr =0,count=0,temp =0;
	/*mod 运算求余,若 writeAddr 是 I2C_PageSize 整数倍,运算结果 Addr 值为 0*/
	Addr = WriteAddr % I2C_PageSize;
	/*差 count 个数据值,刚好可以对齐到页地址*/
	count = I2C_PageSize - Addr;
	/*计算出要写多少整数页*/
	NumOfPage = NumByteToWrite / I2C_PageSize;
	/*mod 运算求余,计算出剩余不满一页的字节数*/
	NumOfSingle = NumByteToWrite % I2C_PageSize;
	// Addr=0,则 WriteAddr 刚好按页对齐 aligned
	// 这样就很简单了,直接写就可以,写完整页后
	// 把剩下的不满一页的写完即可
	if (Addr == 0) 
	{
		/* 如果 NumByteToWrite < I2C_PageSize */
		if (NumOfPage == 0)
		{
			I2C_EE_PageWrite(pBuffer, WriteAddr, NumOfSingle);
			I2C_EE_WaitEepromStandbyState();
		}
		/* 如果 NumByteToWrite > I2C_PageSize */
		else 
		{
			/*先把整数页都写了*/
			while (NumOfPage--)
			{
				I2C_EE_PageWrite(pBuffer, WriteAddr, I2C_PageSize);
				I2C_EE_WaitEepromStandbyState();
				WriteAddr += I2C_PageSize;
				pBuffer += I2C_PageSize;
			}
			/*若有多余的不满一页的数据,把它写完*/
			if (NumOfSingle!=0) 
			{
				I2C_EE_PageWrite(pBuffer, WriteAddr, NumOfSingle);
				I2C_EE_WaitEepromStandbyState();
			}
		}
	}
	// 如果 WriteAddr 不是按 I2C_PageSize 对齐
	// 那就算出对齐到页地址还需要多少个数据,然后
	// 先把这几个数据写完,剩下开始的地址就已经对齐
	// 到页地址了,代码重复上面的即可
	else
	{
		/* 如果 NumByteToWrite < I2C_PageSize */
		if (NumOfPage== 0) 
		{
			/*若 NumOfSingle>count,当前面写不完,要写到下一页*/
			if (NumOfSingle > count) 
			{
				// temp 的数据要写到写一页
				temp = NumOfSingle - count;
				I2C_EE_PageWrite(pBuffer, WriteAddr, count);
				I2C_EE_WaitEepromStandbyState();
				WriteAddr += count;
				pBuffer += count;
				
				I2C_EE_PageWrite(pBuffer, WriteAddr, temp);
				I2C_EE_WaitEepromStandbyState();
			} 
			else 
			{ 
				/*若 count 比 NumOfSingle 大*/
				I2C_EE_PageWrite(pBuffer, WriteAddr, NumByteToWrite);
				I2C_EE_WaitEepromStandbyState();
			}
		}
		/* 如果 NumByteToWrite > I2C_PageSize */
		else
		{
			/*地址不对齐多出的 count 分开处理,不加入这个运算*/
			NumByteToWrite -= count;
			NumOfPage = NumByteToWrite / I2C_PageSize;
			NumOfSingle = NumByteToWrite % I2C_PageSize;
			/*先把 WriteAddr 所在页的剩余字节写了*/
			if (count != 0)
			{
				I2C_EE_PageWrite(pBuffer, WriteAddr, count);
				I2C_EE_WaitEepromStandbyState();
				/*WriteAddr 加上 count 后,地址就对齐到页了*/
				WriteAddr += count;
				pBuffer += count;
			}
			/*把整数页都写了*/
			while (NumOfPage--) 
			{
				I2C_EE_PageWrite(pBuffer, WriteAddr, I2C_PageSize);
				I2C_EE_WaitEepromStandbyState();
				WriteAddr += I2C_PageSize;
				pBuffer += I2C_PageSize;
			}
			/*若有多余的不满一页的数据,把它写完*/
			if (NumOfSingle != 0)
			{
				I2C_EE_PageWrite(pBuffer, WriteAddr, NumOfSingle);
				I2C_EE_WaitEepromStandbyState();
			}
		}
	}	
}
~~~
### 从EEPROM中读取数据
~~~c
uint8_t I2C_EE_BufferRead(uint8_t* pBuffer, uint8_t ReadAddr,u16 NumByteToRead)
{
	I2CTimeout = I2CT_LONG_TIMEOUT;
	while (I2C_GetFlagStatus(EEPROM_I2Cx, I2C_FLAG_BUSY))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(9);
	}
	
	
	/* 产生 I2C 起始信号 */
	I2C_GenerateSTART(EEPROM_I2Cx, ENABLE);
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV5 事件并清除标志*/
	while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(10);
	}
	/* 发送 EEPROM 设备地址 */
	I2C_Send7bitAddress(EEPROM_I2Cx,EEPROM_ADDRESS,I2C_Direction_Transmitter);
	
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV6 事件并清除标志*/
	while (!I2C_CheckEvent(EEPROM_I2Cx,I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(11);
	}
	/*通过重新设置 PE 位清除 EV6 事件 */
	I2C_Cmd(EEPROM_I2Cx, ENABLE);
	/* 发送要读取的 EEPROM 内部地址(即 EEPROM 内部存储器的地址) */
	I2C_SendData(EEPROM_I2Cx, ReadAddr);
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV8 事件并清除标志*/
	while (!I2C_CheckEvent(EEPROM_I2Cx,I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(12);
	}
	
	/* 产生第二次 I2C 起始信号 */
	I2C_GenerateSTART(EEPROM_I2Cx, ENABLE);
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV5 事件并清除标志*/
	while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(13);
	}
	
	/* 发送 EEPROM 设备地址 */
	I2C_Send7bitAddress(EEPROM_I2Cx, EEPROM_ADDRESS, I2C_Direction_Receiver);
	I2CTimeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV6 事件并清除标志*/
	while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(14);
	}
	while(NumByteToRead == 1)
	{
		/* 发送非应答信号 */
		I2C_AcknowledgeConfig(EEPROM_I2Cx, DISABLE);
		/* 发送停止信号 */
		I2C_GenerateSTOP(EEPROM_I2Cx, ENABLE);
	}
	I2CTimeout = I2CT_LONG_TIMEOUT;
	while (I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_BYTE_RECEIVED)==0)
	{
		if ((I2CTimeout--) == 0) return I2C_TIMEOUT_UserCallback(3);
	}
	{
		{
		/*通过 I2C,从设备中读取一个字节的数据 */
		*pBuffer = I2C_ReceiveData(EEPROM_I2Cx);
		/* 存储数据的指针指向下一个地址 */
		pBuffer++;
		/* 接收数据自减 */
		NumByteToRead--;
		}
	}
	
	/* 使能应答,方便下一次 I2C 传输 */
	I2C_AcknowledgeConfig(EEPROM_I2Cx, ENABLE);
	return 1;
}	
~~~
