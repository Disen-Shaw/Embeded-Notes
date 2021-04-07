## 标准库编程

### 初始化定时器结构体
~~~c
typedef struct{
	uint16_t TIM_Prescaler;			// 分频因子
	uint16_t Tim_CouunterMode;		// 定时模式 向上计时还是向下计时
	uint32_t TIM_Period;			// 自动重装载
	uint16_t TIM_ClockDivsion;		// 外部输入分频因子，基本定时器没有
	uint8_t TIM_RepetitionCounter;	// 重复计数器，基本定时器没有，高级有
}TIM_TimeBaseInitTypeDef；
~~~
在自定义的初始化函数中对以上参数进行初始化并调用Init()函数
初始化后将外设使能调用函数并ENABLE
### 实现延时
#### 初始化函数
~~~c
void BASIC_Tim_Config(void)
{
	TIM_TimeBaseInitTypeDef TIM_TimeBaseStructurel
	// 开时钟
	BASEC_TIM_APBxClock_FUN(BASIC_TIM_CLK,ENABLE);
	// 自动重装载寄存器的值
	TIM_TimeBaseStructure.TIM_Period = BASIC_TIM_Period; // 自定义的值
	TIM_TimeBaseStructure.TIM_Prescaler = BASIC_TIM_Prescaler;
	
	/*
		// 时钟分频因子，基本定时器没有
		TIM_TimeBaseStructure.TIM_ClockDivision = TIM_CKD_DIV1;
		// 计数器计数模式，基本定时器只能向上计时，没有计数模式
		TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;
		// 重复计数器的值，基本定时器没有
		TIM_TimeBaseStructure.TIM_RepetitionCounter = 0;	
	*/
	// 初始化定时器
	TIM_TimeBaseInit(BASIC_TIM,&TIM_TimeBaseStructure);
	// 清除计数器中断标志位
	TIM_ClearFlag(BASIC_TIM,TIM_FLAG_Update);
	// 开启计数器中断
	TIM_ITConfig(BASIC_TIM,TIM_IT_Update,ENABLE);
	// 使能计时器
	TIM_Cmd(BASIC_TIM,ENABLE);
}
~~~
#### 中断优先级配置函数
~~~c
static void BASIC_TIM_NVIC_Config(void)
{
	NVIC_InitTypeDef NVIC_InitStructure;
	// 设置中断组为0
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_);
	// 设置中断来源
	
}
~~~
