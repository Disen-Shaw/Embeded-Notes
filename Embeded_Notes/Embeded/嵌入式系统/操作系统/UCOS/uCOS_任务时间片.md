# 任务时间片
## SysTick简介
RTOS需要一个时基来驱动，系统任务调度的频率等于该时基的频率。通常该时基由一个定时器来提供，也可以从其他周期性的信号源获得。

刚好`Cortex-M`内核中有一个系统定时器SysTick，`它内嵌在NVIC中`，是一个24位的递减的计数器，计数器每计数一次的时间为`1/SYSCLK`。当重装载数值寄存器的值递减到0的时候，系统定时器就产生一次中断，以此循环往复。

因为SysTick是嵌套在内核中的，所以使得OS在Cortex-M器件中编写的定时器代码不必修改，使移植工作一下子变得简单很多。所以SysTick是最适合给操作系统提供时基，用于维护系统心跳的定时器。

### SysTick寄存器汇总

| 寄存器名称 | 寄存器描述              |
| ---------- | ----------------------- |
| CTRL       | SysTick控制及状态寄存器 |
| LOAD       | SysTick重装载数值寄存器 |
| VAL        | SysTick当前数值寄存器   |

详细参考STM32的笔记的SysTick章节


## 初始化SysTick
使用SysTick需要一个初始化函数
OS_CPU_SysTickInit函数在os_cpu_c.c中定义
uC/OS-III官方的OS_CPU_SysTickInit函数里面涉及SysTick寄存器都是重新在cpu.h中定义，因此野火的代码没有使用他们的代码，而是使用ARMCM3.h这个固件库文件里定义的寄存器

uCOS自带的 
```c
void OS_CPU_SysTickInit(CPU_INT32U cnts){
	CPU_INT32U prio;
	
	// 填写SysTick的重载计算值
	CPU_REG_NVIC_ST_RELOAD = cnts - 1u;
	
	// 设置SysTick中断优先级
	prio = CPU_REG_NVIC_SHPRI3;
	prio &= DEF_BIT_FIELD(24, 0);
	prio |= DEF_BIT_MASK(OS_CPU_CFG_SYSTICK_PRIO, 24);
	
	CPU_REG_NVIC_SHPRI3 = prio;
	
	// 启用SysTick的时钟源启动计数器
	CPU_REG_NVIC_ST_CTRL |= CPU_REG_NVIC_ST_CTRL_CLKSOURCE | CPU_REG_NVIC_ST_CTRL_ENABLE;
	
	// 启用SysTick的定时中断
	CPU_REG_NVIC_ST_CTRL |= CPU_REG_NVIC_ST_CTRL_TICKINT;
}

```
直接使用头文件ARMCM3.h里面现有的寄存器和函数来实现
```c
void OS_CPU_SysTickInit(CPU_INT32U ms){
	// 设置重装载寄存器
	SysTick->LOAD=ms*SystemCoreClock/1000-1;
	
	// 配置中断优先级为最低
	NVIC_SetPriority (SysTick_IRQn, (1<<__NVIC_PRIO_BITS)-1);
	
	// 复位当前计数器的值
	SysTick->CTRL = SysTick_CTRL_CLKSOURCE_Msk | 
					SysTick_CTRL_TICKINT_Msk |
					SysTick_CTRL_ENABLE_Msk;
}
```

## 编写SysTick中断服务函数
SysTick中断服务函数也是在os_cpu_c.c，具体如下：
```c
void SysTick_Handler(void){
	OSTimeTick();
}
```
SysTick的中断服务函数很简单，里面仅调用函数`OSTimeTick()`

OSTimeTick是与时间相关的函数，在os_time.c文件中定义，具体如下
```c
void OSTimeTick(void){
	// 任务调度
	OSSched();
}
```
OSTimeTick也很简单，里面调用了函数OSSched，作任务调度

任务调度与之前相同
如果1运行，就停止1运行2
如果2运行，就停止2运行1

## main()函数
与没有SysTick的区别不大，只是加入了SysTick的相关内容
```c
/* 包含的头文件 */
#include "os.h"
#include "ARMCM3.h"

/* 宏定义 */

/* 全局变量 */
uint32_t flag1;
uint32_t flag2;

/* TCB & STACK & 任务声明 */

// 栈大小定义
#define TASK1_STK_SIZE	20
#define TASK2_STK_SIZE	20

// 定义任务栈
static CPU_STK Task1Stk[TASK1_STK_SIZE];
static CPU_STK Task2Stk[TASK1_STK_SIZE];

// 定义任务的TCB
static OS_TCB Task1TCB;
static OS_TCB Task2TCB;

// 任务声明
void Task1(void *p_arg);
void Task2(void *p_arg);

/* 函数声明 */
void delay(uint32_t count);

/* main函数 */
// 工程使用软件仿真时需要选择Ude Simulator
// 在target选项卡中将颈枕Xtal(MHz)的值改为25，默认为12
// 改成25是为了和system_ARMCM3.c中定义的__SYSTEM_CLOCK相同，确保到时候仿真的时钟一致

/* main函数 */
int main(void){
	OS_ERR err;
	
///////////////////////////////////////////////////////////////////////////////////////////	
// 	添加了这一段
	/* 关闭中断 */
	CPU_IntDis();
	
	/* 配置SysTick 10ms 一次 */
	OS_CPU_SysTickInit(10);
///////////////////////////////////////////////////////////////////////////////////////////
	
	// 初始化相关的全局变量
	OSInit(&err);
	
	// 创建任务
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
	
	// 将任务加入到就绪列表
	OSRdyList[0].HeadPtr = &Task1TCB;
	OSRdyList[1].HeadPtr = &Task2TCB;
	
	// 启动OS，将不再返回
	OSStartart(&err);
}

/* 软件延时 */
void delay(uint32_t count){
	for(;count!=0;count--);
}

/* 任务1 */
void Task1(void *p_arg){
	for(;;){
		flag1 = 1;
		delay(100);
		flag1 = 0;
		delay(100);
		/* 任务切换，这里是手动切换 */
		OSSched();
	}
}

/* 任务2 */
void Task1(void *p_arg){
	for(;;){
		flag2 = 1;
		delay(100);
		flag2 = 0;
		delay(100);
		/* 任务切换，这里是手动切换 */
		OSSched();
	}
}
```

之前的两个任务也是轮流的占有CPU，也是享有相同的时间片，该时间片是任务单次运行的时间。
与之前不同的是这次任务的时间片等于SysTick的时基，是很多个任务单次运行时间的综合。