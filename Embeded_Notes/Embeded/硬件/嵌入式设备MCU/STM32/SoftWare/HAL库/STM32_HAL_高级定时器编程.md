# HAL_高级定时器编程
## 高级控制定时器的相关结构体
### 定时器基本设置初始化结构体
~~~c
typedef struct{
	uint32_t Perscaler;
	uint32_t CounterMode;
	uint32_t Period;
	uint32_t ClockDivision;
	uint32_t RepetitionCounter;
}TIM_Base_InitTypeDef;
~~~
Perscaler：定时器预分频设置，时钟源经过分频器才是定时器时钟 0~65535实现1到65536分频
CounterMode：定时器计数模式，基本定时器只能向上计数
Period：定时器周期，可以设置成0~65535
ClockDivision：时钟分频功能，主要针对外部触发信号的分频
RepetitionCounter：重复计数器，属于高级控制寄存器专用寄存器，可以控制PWM的输出个数

### 句柄结构体
~~~c
typedef struct{
	TIM_TypeDef *Instance	
	TIM_Base_InitTypeDef Init;
	HAL_TIM_ActiveChannel Channel;
	DMA_HandleTypeDef *hdma[7];
	HAL_LockTypeDef Lock;
	__IO HAL_TIM_StateTypeDef State;
}TIM_HandleTypedef;
~~~
Instance:TIM外设基址
Init：基本定时器相关函数
Channel：定时器通道选择，有四个通道，基本定时器没有
hdma[7]：定时器DMA相关，后面的7表示只能由TIM DMA Handle Index这个定时器的DMA处理标志访问
Lock：锁定机制
State：定时器操作状态

### 定时器时钟源配置结构体
~~~c
typedef struct{
	uint32_t ClockSource;		// 时钟源
	uint32_t ClockPolarity;		// 时钟极性 ETP不反相(高电平或者上升沿有效)、ETP反相、TIx上升沿、TIx下降沿、TIx双边沿
	uint32_t ClockPrescaler;	// 时钟预分频 1、2、4、8分频
	uint32_t ClockFilter;		// 时钟滤波器 只用于ETP信号
}TIM_ClockConfigTypeDef;
~~~

时钟源一般选用内部时钟

### 定时器输出比较初始化结构体
~~~c
typedef struct{
	uint32_t OCMode;			// 比较输出模式
	uint32_t Pulse;				// 脉冲(通道比较值)
	uint32_t OCPolarity;		// 比较输出通道极性
	uint32_t OCNPolarity;		// 比较输出互补通道极性
	uint32_t OCFastMode;		// 比较输出快速模式
	uint32_t OCIdleState;		// 比较输出通道空闲状态
	uint32_t OCNIdleState;		// 比较输出互补通道空闲状态
}TIM_OC_InitTypeDef;
~~~
Pulse：脉冲数，设置捕获比较TIMx_CCxR寄存器值，0-0xFFFF
OCPolarity：比较输出通道引脚电平：高电平或者低电平
OCNPolarity：比较输出互补通道电平，高电平或者低电平
OCFastMode：快速模式，加快输出比较对**触发输入事件的响应**，只能用于PWM模式
OCIdleState：空闲状态时比较输出通道状态：设置或者复位
OCNIdleState：空闲状态时比较输出互补通道状态：设置或者复位

比较模式和PWM模式具体配置的选择在.c文件的注释中有


### 定时器输入捕获初始化结构体
~~~c
typedef struct{
	uint32_t ICPolarity;		// 输入极性
	uint32_t ICSelection;		// 捕获输入选择
	uint32_t ICPrescaler;		// 输入捕获分频器
	uint32_t ICFilter;			// 输入捕获滤波器
}TIM_IC_InitTypeDef;
~~~
ICPolarity：输入捕获极性，上升沿、下降沿、双边沿
ICSelection：输入捕获信号源的选择：TIx、TRC
ICPrescaler：输入捕获分频器1、2、4、8
ICFilter：输入捕获滤波器：0-0xf

### 定时器主模式配置结构体
~~~c
typedef struct{
	uint32_t MasterIOutputTrigger;	// 触发输出信号(TRGO)选择
	uint32_t MasterSlaveMode;		// 主从模式,多定时器合作时使用
}TIM_MasterConfigTypeDef;
~~~

### 定时器刹车死区时间配置
~~~c
typedef struct{
	uint32_t OffStateRunMode;		// 运行模式下"关闭状态"选择
	uint32_t OffStateIDLEMode;		// 空闲模式下"关闭状态"选择
	uint32_t LockLevel;				// 参数锁保护等级
	uint32_t DeadTime;				// 死区时间
	uint32_t BreakState;			// 刹车输入使能
	uint32_t BreakPolarity;			// 刹车输入有效电平
	uint32_t AutomaticOutput;		// 自动设置输出
}TIM_BreakDeadTimeConfigTypeDef;
~~~
OffStateRunMode：运行模式下"关闭状态"选择：使能或者不使能
OffStateIELDMode：空闲模式下"关闭状态"选择：使能或者不使能
LockLevel：参数锁保护等级：关闭、等级1、等级2或等级3
DeadTime：死区时间：0-0xFF
BreakState：刹车输入：使能或者不使能
BreakPoarity：刹车输入有效极性：低电平或者高电平
AutomaticOutput：自动输出使能：使能或者不使能












