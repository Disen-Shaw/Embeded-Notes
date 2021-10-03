---
date updated: '2021-10-03T09:37:23+08:00'

---

# HAL基本定时器编程

## 基本定时器

### 定时器基本设置初始化结构体

```c
typedef struct{
	uint32_t Prescaler;
	uint32_t CounterMode;
	uint32_t Prescaler;
	uint32_t ClockDivision;
	uint32_t RepetitionCounter;
}TIM_Base_InitTypedef;
```

Prescaler:定时器预分频设置
CounterMode:定时器计数模式 基本定时器只能向上计数
Peroid:定时器周期，为0~65535
`在定时器预分频已经得到时钟为1MHz`
`Peroid的值设置为1000,可以产生1ms的定时周期`
ClockDivision:时钟分频，设置定时器时钟CK_INT频率与数字滤波采样时钟频率分频比
`基本定时器没有这个功能`
RepetitionCounter：重复计数器，属于高级控制寄存器专用寄存器位
可以控制输出PWM的个数，基本定时器不用设置

### 定时器句柄结构体

```c
typedef struct{
	TIM_TypeDef *Instance	
	TIM_Base_InitTypeDef Init;
	HAL_TIM_ActiveChannel Channel;
	DMA_HandleTypeDef *hdma[7];
	HAL_LockTypeDef Lock;
	__IO HAL_TIM_StateTypeDef State;
}TIM_HandleTypedef;
```

Instance:TIM外设基址
Init：基本定时器相关函数
Channel：定时器通道选择，有四个通道，基本定时器没有
hdma[7]：定时器DMA相关，后面的7表示只能由TIM DMA Handle Index这个定时器的DMA处理标志访问
Lock：锁定机制
State：定时器操作状态

### 基本定时器代码实现

1. bsp_BasicTIM.h

```c
#define USE_TIM6	// 使用基本定时器6
#ifdef USE_TIM6
	#define BASIC_TIMx			TIM6
	#define BASIC_TIM_RCC_CLK_ENABLE() __HAL_RCC_TIM6_CLK_ENABLE()
	#define BASIC_TIM_RCC_CLK_DISABLE() __HAL_RCC_TIM6_CLK_DISABLE()
	#define BASIC_TIM_IRQ		TIM6_IRQ
	#deinfe BASIC_TIM_INT_FUN	TIM6_IRQHandler
#else
	#define BASIC_TIMx			TIM7
	#define BASIC_TIM_RCC_CLK_ENABLE() __HAL_RCC_TIM7_CLK_ENABLE()
	#define BASIC_TIM_RCC_CLK_DISABLE() __HAL_RCC_TIM7_CLK_DISABLE()
	#define BASIC_TIM_IRQ		TIM7_IRQ
	#deinfe BASIC_TIM_INT_FUN	TIM7_IRQHandler
#endif

#define BAISC_TIMx_PRESCALER	71		// 实际时钟为1MHz
#define BASIC_TIMx_PERIOD		1000  	// 1ms定时周期

// 扩展变量
extern TIM_HandleTypeDef htimx;
// 函数声明
void BASIC_TIMx_Init(void);
```

2. bsp_BasicTIM.c

```c
void BASIC_TIMx_Init(void)
{
	TIM_MasterConfigTypeDef sMasterConfig;
	htimx.Instance = BASIC_TIMx;
	htimx.Init.Prescaler = BASIC_TIMx_PRESCALER;
	htimx.Init.CounterMode = TIM_COUNTERMODE_UP;
	htimx.Init.Period = BASIC_TIMx_PERIOD;
	HAL_TIM_Base_Init(&htimx);
	
	sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
	sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
	HAL_TIMEx_MasterConfigSynchronization(&htimx,&sMasterConfig);
}

void HAL_TIM_Base_MspInit(TIM_HandleTypeDef *htim_base)
{
	if(hmit_base->Instance == BASIC_TIMx)
	{
		// 基本定时器始终是能
		BASIC_TIM_RCC_CLK_ENABLE();
		// 外设中断配置
		HAL_NVIC_SetPriority(BASIC_TIM_IRQ,1,0);
		HAL_NVIC_EnableIRQ(BASIC_TIM_IRQ);
		
	}
}


```

3. stm32f1xx_it.c

```c
void BASIC_TIM_INT_FUN(void)
{
	HAL_TIM_IRQHandler(&htim);
}
```

5. main.c

```c
int main(void)
{
	//复位所有外设，初始化flash接口和系统嘀嗒定时器
	HAL_Init();
	// 配置系统时钟
	SystemClock_config();
	/* 初始化 */
	//LED外设初始化函数();
	BASIC_TIMx_Init();
	/* 在中断模式下启动定时器 */
	HAL_TIM_Base_Start_IT(&htim);
	LED(ON);
	while(1)
	{
		if(timer_count == 1000)
		{
			timer_count = 0;
			LED1_TOGGLE;
			LED2_TOGGLE;
			LED3_TOGGLE；
		}
	}
}

void HAL_TIM_PeroidElapsedCallbace(TIM_HandleTypeDef *htim)
{
	timer_count++;
}

```

可以更改头文件里的两个值来更改周期

## 强调

一定要算好时间周期的参数
另外HAL-TIM常用的函数：

```c
// 句柄初始化函数
HAL_StatusTypeDef HAL_TIM_Base_Init(TIM_HandleTypeDef *htim);
// 句柄复位函数
HAL_StatusTypeDef HAL_TIM_Base_DeInit(TIM_HandleTypeDef *htim);
// 底层初始化,一般用这个函数开时钟或者引脚
void HAL_TIM_Base_MspInit(TIM_HandleTypeDef *htim);
// 底层复位函数
void HAL_TIM_Base_MspDeInit(TIM_HandleTypeDef *htim);
// 定时器开始函数
HAL_StatusTypeDef HAL_TIM_Base_Start(TIM_HandleTypeDef *htim);
// 关闭定时器函数
HAL_StatusTypeDef HAL_TIM_Base_Stop(TIM_HandleTypeDef *htim);
// 开启定时器并开启定时中断功能
HAL_StatusTypeDef HAL_TIM_Base_Start_IT(TIM_HandleTypeDef *htim);
// 关闭定时器并且关闭定时器中断功能函数
HAL_StatusTypeDef HAL_TIM_Base_Stop_IT(TIM_HandleTypeDef *htim);
```
