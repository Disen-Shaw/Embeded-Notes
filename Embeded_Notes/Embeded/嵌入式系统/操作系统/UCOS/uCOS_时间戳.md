# 时间戳
## 时间戳介绍
用于测量时间
在μC/OS-III中，很多地方的代码都加入了时间测量的功能，比如任务关中断的时间，关调度器的时间等。知道了某段代码的运行时间，就明显地知道该代码的执行效率，如果时间过长就可以优化或者调整代码策略。
如果要测量一段代码A的时间，那么可以在代码段A运行前记录一个时间点TimeStart，在代码段A运行完记录一个时间点TimeEnd，那么代码段A的运行时间TimeUse就等于TimeEnd减去TimeStart。这里面的两个时间点TimeEnd和TimeStart，就叫作时间戳，时间戳实际上就是一个时间点。

## 时间戳实现
通常执行一条代码是需要多个时钟周期的，即是ns级别，而通常单片机中的硬件定时器的精度都是us级别，远达不到测量几条代码运行时间的精度。
在ARM Cortex-M系列内核中，有一个DWT的外设，该外设有一个32位的寄存器叫CYCCNT，它是一个向上的计数器，记录的是内核时钟HCLK运行的个数，当CYCCNT溢出之后，会清零重新开始向上计数。该计数器在μC/OS-III中正好被用来实现时间戳的功能。
在STM32系列单片机中，时钟倍频之后比较高，单个时钟周期为十几纳秒，CYCCNT总共能记录的时间为232x14=60S。
在μC/OS-III中，要测量的时间都是很短的，都是ms级别，因此不需要考虑定时器溢出的问题。

## 时间戳代码实现
### CPU_Init()函数
CPU_Init()函数在cpu_core.c实现，主要做三件事：
+ 初始化时间戳
+ 初始化中断禁用时间测量
+ 初始化CPU名字。

`第2和3个功能目前还没有使用到，只实现了第1个初始化时间戳的代码`
```c
void CPU_Init(void){
#if ((CPU_CFG_TS_EN== DEF_ENABLED) || \
	(CPU_CFG_TS_TMR_EN==DEF_ENABLED))
	CPU_TS_Init();
}
#endif
```
CPU_CFG_TS_EN和CPU_CFG_TS_TMR_EN这两个宏在cpu_core.h中定义，用于控制时间戳相关的功能代码
具体如下：
```c
#if ((CPU_CFG_TS_32_EN == DEF_ENABLED) || \
		(CPU_CFG_TS_64_EN==DEF_ENABLED))
#define CPU_CFG_TS_EN DEF_ENABLED
#else
#define CPU_CFG_TS_EN DEF_DISABLED
#endif
#if ((CPU_CFG_TS_EN == DEF_ENABLED) || \
		(defined(CPU_CFG_INT_DIS_MEAS_EN)))
#define CPU_CFG_TS_TMR_ENDEF_ENABLED
#else
#define CPU_CFG_TS_TMR_EN DEF_DISABLED
#endif
```

CPU_CFG_TS_32_EN和CPU_CFG_TS_64_EN这两个宏在cpu_cfg.h文件中定义，用于控制时间戳是32位还是64位的，默认启用32位
定义如下：
```c
#ifndef CPU_CFG_MODULE_PRESENT
#define CPU_CFG_MODULE_PRESENT


#define CPU_CFG_TS_32_ENDEF_ENABLED
#define CPU_CFG_TS_64_ENDEF_DISABLED

#define CPU_CFG_TS_TMR_SIZECPU_WORD_SIZE_32

#endif
```

### CPU_TS_Init()
时间戳初始化函数，在cpu_core.c中实现
```c
#if ((CPU_CFG_TS_EN== DEF_ENABLED) || \
	(CPU_CFG_TS_TMR_EN == DEF_ENABLED))
static void CPU_TS_Init(void){
#if (CPU_CFG_TS_TMR_EN == DEF_ENABLED)
	CPU_TS_TmrFreq_Hz=0u;
	CPU_TS_TmrInit();
#endif
}
#endif
```
CPU_TS_TmrFreq_Hz是一个在cpu_core.h中定义的全局变量，表示CPU的系统时钟，具体大小跟硬件相关，如果使用STM32F103系列，那就等于72000000HZ。
CPU_TS_TmrFreq_Hz变量的定义和时间戳相关的数据类型的定义具体如下：
```c
// externs，在cpu_core.h中定义
#ifdef CPU_CORE_MODULE	/* CPU_CORE_MODULE只在cpu_core.c文件的开头定义*/
#define CPU_CORE_EXT
#else
#define CPU_CORE_EXT extern
#endif

// 时间戳数据类型，在cpu_core.h文件定义
typedef CPU_INT32U CPU_TS32;
typedef CPU_INT32U CPU_TS_TMR_FREQ;
typedef CPU_TS32 CPU_TS;
typedef CPU_INT32U CPU_TS_TMR;

// 全局变量在cpu_core.h中定义
#if (CPU_CFG_TS_TMR_EN == DEF_ENABLED)
CPU_CORE_EXT CPU_TS_TMR_FREQ CPU_TS_TmrFreq_Hz;、
#endif
```

### CPU_TS_TmrInit()函数
时间戳定时器初始化函数CPU_TS_TmrInit()在cpu_core.c，具体如下：
```c
/*时间戳定时器初始化*/
void CPU_TS_TmrInit(void){
	CPU_INT32U fclk_freq;
	fclk_freq = BSP_CPU_ClkFreq();
	
	/*启用DWT外设*/
	BSP_REG_DEM_CR|=(CPU_INT32U)BSP_BIT_DEM_CR_TRCENA;
	/* DWT CYCCNT寄存器计数清零*/
	BSP_REG_DWT_CYCCNT = (CPU_INT32U)0u;
	
	/*启用Cortex-M3 DWT CYCCNT寄存器*/
	BSP_REG_DWT_CR |= (CPU_INT32U)BSP_BIT_DWT_CR_CYCCNTENA;
	CPU_TS_TmrFreqSet((CPU_TS_TMR_FREQ)fclk_freq);
}
#endif
```
#### 初始化时间戳计数器CYCCNT，启用CYCCNT计数器的操作步骤
+ 先启用DWT外设，这个由另外内核调试寄存器DEMCR的位24控制，写1启用。
+ 启用CYCCNT寄存器之前，先清零。
+ 启用CYCCNT寄存器，这个由DWT_CTRL(代码上宏定义为DWT_CR)的位0控制，写1启用。

时间戳DWT外设相关寄存器定义如下
```c
// 寄存器定义
#define BSP_REG_DEM_CR(*(CPU_REG32 *)0xE000EDFC)
#define BSP_REG_DWT_CR(*(CPU_REG32 *)0xE0001000)
#define BSP_REG_DWT_CYCCNT(*(CPU_REG32 *)0xE0001004)
#define BSP_REG_DBGMCU_CR(*(CPU_REG32 *)0xE0042004)

// 寄存器位定义
#define BSP_DBGMCU_CR_TRACE_IOEN_MASK 0x10
#define BSP_DBGMCU_CR_TRACE_MODE_ASYNC 0x00
#define BSP_DBGMCU_CR_TRACE_MODE_SYNC_01 0x40
#define BSP_DBGMCU_CR_TRACE_MODE_SYNC_02 0x80 
#define BSP_DBGMCU_CR_TRACE_MODE_SYNC_04 0xC0 
#define BSP_DBGMCU_CR_TRACE_MODE_MASK 0xC0 
#define BSP_BIT_DEM_CR_TRCENA (1<<24) 
#define BSP_BIT_DWT_CR_CYCCNTENA (1<<0)
```

### BSP_CPU_ClkFreq()函数
BSP_CPU_ClkFreq()是一个用于获取CPU的HCLK时钟的BSP函数，具体跟硬件相关，如果软件仿真，则把硬件相关的代码注释掉，直接手动设置CPU的HCLK的时钟等于软件仿真的时钟25000000HZ。
BSP_CPU_ClkFreq()在cpu_core.c实现，具体代码如下
```c
CPU_INT32UBSP_CPU_ClkFreq(void){
#if 0
	RCC_ClocksTypeDef rcc_clocks;
	RCC_GetClockFreq(&rcc_clocks);
	
	return ((CPU_INT32U)rcc_clocks.HCLK_Frequency);
#else
	CPU_INT32U CPU_HCLK;
	/*目前软件仿真我们使用25M的系统时钟*/
	CPU_HCLK=25000000;
	return CPU_HCLK;
#endif
}
```

### CPU_TS_TmrFreqSet()函数
函数在cpu_core.c中定义，具体的作用是把函数BSP_CPU_ClkFreq()获取到的CPU的HCLK时钟赋值给全局变量CPU_TS_TmrFreq_Hz
代码实现如下：
```c
void CPU_TS_TmrFreqSet(CPU_TS_TMR_FREQ freq_hz){
	CPU_TS_TmrFreq_Hz=freq_hz;
}
```

### CPU_TS_TmrRd()函数
用于获取CYCNNT计数器的值，在cpu_core.c中定义
```c
#if (CPU_CFG_TS_TMR_EN == DEF_ENABLED)
CPU_TS_TMR CPU_TS_TmrRd(void){
	CPU_TS_TMR ts_tmr_cnts;
	ts_tmr_cnts=(CPU_TS_TMR)BSP_REG_DWT_CYCCNT;
	return (ts_tmr_cnts);
}
#endif
```


### OS_TS_GET()函数
OS_TS_GET()函数用于获取CYCNNT计数器的值，实际上是一个宏定义，将CPU底层的函数CPU_TS_TmrRd()重新取个名字封装，供内核和用户函数使用，在os_cpu.h头文件定义
具体实现如下：
```c
#define OS_CFG_TS_EN 1u
#if OS_CFG_TS_EN == 1u
#define OS_TS_GET() (CPU_TS)CPU_TS_TmrRd()
#else
#define OS_TS_GET() (CPU_TS)0u
#endif
```


### 主程序
**声明以及主函数**
```c
/* 定义三个全局变量*/
uint32_t TimeStart;
uint32_t TimeEnd;
uint32_t TimeUse;

/* main函数 */
int main(){
	OS_ERR err;
	
	/* CPU初始化：1、初始化时间戳 */
	CPU_Init();
	
	/* 关闭中断 */
	CPU_IntDis();
	
	/* 配置SysTick 10ms中断1次 */
	OS_CPU_SysTickInit(10);
	
	/* 初始化相关的全局变量 */
	OS_Init(&err);
	
	/* 创建任务 */
	OSTaskCreate(	(OS_TCB *) &Task1TCB
					(OS_TASK_PTR) Task1,
					(void *) 0,
					(CPU_STK *) &Task1Stk[0],
					(CPU_STK_SIZE) TASK1_STK_SIZE,
					(OS_ERR *) &err);
	OSTaskCreate(	(OS_TCB *) &Task2TCB
					(OS_TASK_PTR) Task1,
					(void *) 0,
					(CPU_STK *) &Task2Stk[0],
					(CPU_STK_SIZE) TASK2_STK_SIZE,
					(OS_ERR *) &err);
	
	/* 将任务加入到就绪表 */
	OSRdyList[0].HeadPtr=&Task1TCB;
	OSRdyList[1].HeadPtr=&Task2TCB;
	
	/* 启动OS，将不再返回 */
}
```
**任务函数**
```c
/* 任务1 */
void Task1(void *p_arg){
	for(;;){
		flag1 = 1;
		TimeStart = OS_TS_GET();
		OSTimeDly(20);
		TimeEnd = OS_TS_GET();
		TimeUse = TimeEnd - TimeStart;
		
		flag1 = 0;
		OSTimeDly(2);
	}
}
```