---
date updated: '2021-10-01T07:37:58+08:00'

---

### EXTI中断编程

```c
// 引脚配置
#define KEY1_INT_GPIO_PORT 			GPIOA
#define KEY1_INT_GPIO_CLK 			RCC_APB2Periph_GPIOA\
									|RCC_APB2Periph_AFIO)
#define KEY1_INT_GPIO_PIN 			GPIO_Pin_0
#define KEY1_INT_EXTI_PORTSOURCE 	GPIO_PortSourceGPIOA
#define KEY1_INT_EXTI_PINSOURCE 	GPIO_PinSource0
#define KEY1_INT_EXTI_LINE 			EXTI_Line0
#define KEY1_INT_EXTI_IRQ			EXTI0_IRQn

#define KEY1_IRQHandler				EXTI0_IRQHandler



#define KEY2_INT_GPIO_PORT 			GPIOC
#define KEY2_INT_GPIO_CLK			(RCC_APB2Periph_GPIOC\
									|RCC_APB2Periph_AFIO)

#define KEY2_INT_GPIO_PIN			GPIO_Pin_13
#define KEY2_INT_EXTI_PORTSOURCE	GPIO_PortSourceGPIO
#define KEY2_INT_EXTI_PINSOURCE		GPIO_PinSource13
#define KEY2_INT_EXTI_LINE			EXTI_Line13
#define KEY2_INT_EXTI_IRQ			EXTI15_10_IRQn

// NVIC配置
static void NVIC_Configuration(void)
{
	NVIC_InitTypeDef NVIC_InitStructure;
	/* 配置 NVIC 为优先级组 1 */
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);
	/* 配置中断源:按键 1 */
	NVIC_InitStructure.NVIC_IRQChannel = KEY1_INT_EXTI_IRQ;
	/* 配置抢占优先级:1 */
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;
	/* 配置子优先级:1 */
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
	/* 使能中断通道 */
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_Init(&NVIC_InitStructure);
}


// 中断配置
void EXTI_Key_Config(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	EXTI_InitTypeDef EXTI_InitStructure;
	/*开启按键 GPIO 口的时钟*/
	RCC_APB2PeriphClockCmd(KEY1_INT_GPIO_CLK,ENABLE);
	/* 配置 NVIC 中断*/
	NVIC_Configuration();
	/*--------------------------KEY1 配置---------------------*/
	/* 选择按键用到的 GPIO */
	GPIO_InitStructure.GPIO_Pin = KEY1_INT_GPIO_PIN;
	/* 配置为浮空输入 */
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(KEY1_INT_GPIO_PORT, &GPIO_InitStructure);
	/* 选择 EXTI 的信号源 */
	GPIO_EXTILineConfig(KEY1_INT_EXTI_PORTSOURCE, \
	KEY1_INT_EXTI_PINSOURCE);
	EXTI_InitStructure.EXTI_Line = KEY1_INT_EXTI_LINE;
	/* EXTI 为中断模式 */
	EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
	/* 上升沿中断 */
	EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising;
	/* 使能中断 */
	EXTI_InitStructure.EXTI_LineCmd = ENABLE;
	EXTI_Init(&EXTI_InitStructure);
	/*--------------------------KEY2 配置------------------*/
	/* 选择按键用到的 GPIO */
	GPIO_InitStructure.GPIO_Pin = KEY2_INT_GPIO_PIN;
	/* 配置为浮空输入 */
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(KEY2_INT_GPIO_PORT, &GPIO_InitStructure);
	/* 选择 EXTI 的信号源 */
	GPIO_EXTILineConfig(KEY2_INT_EXTI_PORTSOURCE, \
	KEY2_INT_EXTI_PINSOURCE);
	EXTI_InitStructure.EXTI_Line = KEY2_INT_EXTI_LINE;
	/* EXTI 为中断模式 */
	EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
	/* 下降沿中断 */
	EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Falling;
	/* 使能中断 */
	EXTI_InitStructure.EXTI_LineCmd = ENABLE;
	EXTI_Init(&EXTI_InitStructure);
}
```

```c
// EXTI 中断服务函数
void KEY1_IRQHandler(void)
{
	//确保是否产生了 EXTI Line 中断
	if (EXTI_GetITStatus(KEY1_INT_EXTI_LINE) != RESET) 
	{
		// LED1 取反
		LED1_TOGGLE;
		//清除中断标志位
		EXTI_ClearITPendingBit(KEY1_INT_EXTI_LINE);
	}
}

void KEY2_IRQHandler(void)
{
	//确保是否产生了 EXTI Line 中断
	if (EXTI_GetITStatus(KEY2_INT_EXTI_LINE) != RESET) 
	{
		// LED2 取反
		LED2_TOGGLE;
		//清除中断标志位
		EXTI_ClearITPendingBit(KEY2_INT_EXTI_LINE);
	}
}

```

```c
// 主函数
int main(void)
{
	/* LED 端口初始化 */
	LED_GPIO_Config();
	/* 初始化 EXTI 中断,按下按键会触发中断,
	* 触发中断会进入 stm32f4xx_it.c 文件中的函数
	* KEY1_IRQHandler 和 KEY2_IRQHandler,处理中断,反转 LED 灯。
	*/
	EXTI_Key_Config();
	/* 等待中断,由于使用中断方式,CPU 不用轮询按键 */
	while (1) 
	{
	}
}
```

### 使用HAL库编程

使用hal库时对EXTI中断进行操作，需要重构EXTI的回调函数
