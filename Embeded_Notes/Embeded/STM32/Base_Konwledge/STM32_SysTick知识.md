### SysTick简介

SysTick：SysTick—系统定时器是属于 Cortex-M 内核中的一个外设,内嵌在 NVIC 中
系统定时器，24位只能递减，存在于内核，嵌套在NVIC中，所有的Cortex-M内核的单片机都具有这个定时器

![[Pasted image 20210308220806.png]]

COUNTER在时钟的驱动下，从reload初值开始往下递减计数到0，产生中断和置位COUNTFLAG标志，然后从reload值开始重新递减计数，如此循环

### SysTick定时时间计算

1. 定时事件t：

   一个计数循环的时间，跟reload和CLK有关

   t = reload值*(1/CLK)

   当CLK = 72MHz时，t = (72)*(1/72MHz) = 1US

   当CLK = 72MHz时，t = (72000)*(1/72MHz) = 1MS

2. CLK：

   由CTRL寄存器配置

3. RELOAD：

   24位，用户自己设置
   
### SysTick寄存器

SysTick寄存器结构体，在core_cm3.h中定义

~~~c
/* SysTick结构体 */
typedef struct{
    __IO uint32_t CTRL;				// 控制及状态寄存器
    __IO uint32_t LOAD;				// 重装载数值寄存器
    __IO uint32_t VAL;				// 当前数值寄存器
    __I uint32_t CALIB;				// 校准寄存器
} SysTick_Type;
~~~
SysTick 属 于 内 核 的 外 设 , 有 关 的 寄 存 器 定 义 和 库 函 数 都 在 内 核 相 关 的 库 文 件core_cm3.h 中

~~~c
/* 系统定时器配置函数 */
static __INLINE uint32_t SysTick_Config(uint32_t ticks)
{
    // 判断参数是否大于SysTick计数最大值，那么参数不符合规则，直接返回1
    if(tick>SysTick_LOAD_RELOAD_Msk) return 1;
    // 初始化reload的值
    SysTick->LOAD = (tick & SysTick_LOAD_RELOAD_Msk) - 1 ;
    // 配置中断优先级 配置为15,默认为最低优先级
    NVIC_SetPriority(SysTick_IRQn,(1<<__NVIC_PRIO_BITS) - 1);
    // 初始化COUNTER的值为0
    SysTick->VAL = 0;
    // 配置SysTick的时钟为72MHz
    // 使能中断
    // 使能SysTick开始计数8
    SysTick->CTRL = SysTick_CTRL_CLKSOURCE_Msk 	|
        			SysTick_CTRL_TICKINT_Msk	|
        			SysTick_CTRL_ENABLE_Msk;
    return (0);
}
~~~

### SysTick中断优先级

1. STM32里面无论是内核还是外设，都是使用4个二进制位来表示中断优先级。
2. 中断优先级的分组对内核和外设同样适用。
   当比较的时候，只需要吧内核外设的中断优先级的四个位按照外设的中断优先级来分组来解析即可
   即人为的分出抢占优先级和子优先级
   
HAL库中的HAL_Delay()函数是基于SysTick的

[[SysTick_基本编程]]
