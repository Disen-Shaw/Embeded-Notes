# 任务的定义和切换的实现
从0到1写RTOS的第一步，属于基础中的基础
**必须学会创建任务，并重点掌握任务是如何切换的**

**裸机系统中的两个变量轮流翻转**
```c

uint32_t flag1;
uint32_t flag2;

// 软件延时
void delay(uint32_t count){
	for(;count!=0;count--);
}

int main(void){
	// 无限循环顺序执行
	for(;;){
		flag1 = 1;
		delay(100);
		flag1 = 0;
		delay(100);
		
		flag2 = 1;
		delay(100);
		flag2 = 0;
		delay(100);
	}
}
```
此程序的波形为：
![[Pasted image 20210705160337.png]]

在多人物系统中两个任务不断切换的效果图应该像多人物的波形
![[Pasted image 20210705160400.png]]


## 多任务介绍
在裸机系统中，系统的主体就是main函数里面顺序执行的无限循环，这个无限循环里面CPU按照顺序完成各种事情。在多任务系统中，我们根据功能的不同，把整个系统分割成一个个独立的且无法返回的函数，这个函数我们称为任务。
任务的大体形势如：
```c
void task_entry(void *parg){
	// 任务主题，无法返回
	for(;;){
		/* 任务主体代码 */
	}
}
```

## 创建任务
**创建任务分为四部分**
+ 定义任务栈
+ 定义任务函数
+ 定义任务控制块TCB
+ 实现任务创建函数



### 定义任务栈
在一个裸机系统中，如果有全局变量，有子函数调用，有中断发生，那么系统在运行的时候，全局变量放在哪里，子函数调用时，局部变量放在哪里，中断发生时，函数返回地址发哪里。
如果只是单纯的裸机编程，它们放哪里不用管，但是如果要写一个RTOS，这些种种环境参数，我们必须弄清楚这些变量是如何存储的。

在裸机中，这些变量统统放在一盒叫做栈的地方
栈是单片机RAM里卖弄一段连续的内存空间，栈的大小由启动文件里面的代码配置，最后由C库函数`_main`进行初始化

```asm
Stack_Size 		EQU			0x00000400

				AREA		STACK, NOINIT, READWRITE,ALIGN=3
Stack_Mem		SPACE		Stack_Size
__initial_sp
```

但是在多任务的系统中，每个任务都是独立的，互不干扰所以要为每个任务都分配独立的栈空间，这个栈空间通常是一个预先定义好的`全局数组`。
这些一个个的任务栈也是存在于RAM中，能够使用的最大的栈也是由上面的任务栈`Stack_Size`决定的。

只是多任务系统中任务的栈就是在统一的一个栈空间里面分配好一个个独立的房间，每个任务只能使用各自的房间，而裸机系统中需要使用栈的时候则可以天马行空，随便在栈里面找个空闲的空间使用

要实现之前的两个变量按照一定的频率轮转反转，需要两个任务来实现。
在多任务系统中，有多少个任务就需要定义多少个任务栈

```c
#define	TASK1_STK_SIZE	128
#define	TASK2_STK_SIZE	128

staic CPU_STK Task1Stk[TASK1_STK_SIZE];
staic CPU_STK Task2Stk[TASK2_STK_SIZE];
```
+ 任务栈的大小应该由宏定义控制，在uCOSIII中，空闲任务的栈最小应该大于128
+ 任务栈其实就是一个预先定义好的全局数据，数据类型为CPU_STK
	`在μC/OS-III中，凡是涉及数据类型的地方，μC/OS-II都会将标准的C数据类型用typedef重新取一个类型名，命名方式则采用见名之义的方式命名且统统大写。`
	+ 凡是与CPU类型相关的数据类型则统一在cpu.h中定义
	+ 与OS相关的数据类型则在os_type.h定义


### 定义任务函数
任务是一个独立的函数，函数主体无限循环不能返回
```c
uint32_t flag1;
uint32_t flag2;

/* 任务1 */
void Task1(void *p_arg){
	for(;;){
		flag1 = 1;
		delay(100);
		flag1 = 0;
		delay(100);
	}
	
}

/* 任务2 */
void Task2(void *p_arg){
	for(;;){
		flag2 = 1;
		delay(100);
		flag2 = 0;
		delay(100);
	}
}

```

### 定义任务控制块**TCB**
在裸机系统中，程序的主体是CPU按照顺序执行的。而在多任务系统中，任务的执行是由系统调度的。系统为了顺利的调度任务，为每个任务都额外定义了一个任务控制块TCB（Task Con-trolBlock）

这个任务控制块就相当于任务的身份证，里面存有任务的所有信息，比如任务的栈，任务名称，任务的形参等。

有了这个任务控制块之后，以后系统对任务的全部操作都可以通过这TCB来实现
`TCB是一个新的数据类型，在os.h中声明`

```c
/* 任务控制块TCB重定义 */
typedef struct os_tcb OS_TCB;
struct os_tcb{
	CPU_STK		*StkPtr;
	CPU_STK_SIZE StkSize;
};
```
目前TCB里面的成员还比较少，只有栈指针和栈大小。其中为了以后操作方便，我们把栈指针作为TCB的第一个成员

在**app.c**中定义TCB
```c
static OS_TCB Task1TCN;
static OS_TCB Task2TCN;
```

### 实现**任务创建**函数
任务的栈，任务的函数实体，任务的TCB最终需要联系起来才能由系统进行统一调度。
在中这个联系就有任务创建函数OSTaskCreate来实现
该函数在os_task.c（os_task.c第一次使用需要自行在文件夹μC/OS-IIISource中新建并添加到工程的μC/OS-III Source组）中定义，所有跟任务相关的函数都在这里定义

```c
/* OSTaskCreate函数 */
void OSTaskCreate(	OS_TCB 			*p_tcb,
					OS_TASK_PTR 	p_task,
					void 			*p_arg,
					CPU_STK 		*p_stk_base,
					CPU_STK_SIZE	stk_size,
					OS_ERR			*p_err)
{
	CPU_STK		*p_sp;
	p_sp = OSTaskStkInit(p_task,
						 p_arg,
						 p_stk_base,
						 stk_size);
	p_tcb->StkPtr = p_sp;
	p_tcb->Stk_Size = stk_size;
	*p_err = OS_ERR_NONE;
}
```


+ p_tcb是任务控制块指针
+ p_task是任务函数名，类型为OS_TASK_PTR,原型在os.h中
```c
typedef void (*OS_TASK_PTR)(void *p_arg);
```
+ p_arg是任务形参，用于传递任务参数。
+ p_stk_base用于指向任务栈的起始地址。
+ stk_size表示任务栈的大小
+ p_err用于存错误码

`μC/OS-III中为函数的返回值预先定义了很多错误码，通过这些错误码我们可以知道函数是因为什么出错。`

+ OSTaskStkInit()是**任务栈初始化**函数。当任务第一次运行的时候，加载到CPU寄存器的参数就放在任务栈里面，在任务创建的时候，预先初始化好栈
	`OS-TaskStkInit()函数在os_cpu_c.c（os_cpu_c.c第一次使用需要自行在文件夹μC-CPU中新建并添加到工程的μC/CPU组）中定义`

```c
OS_STK *OSTaskStkInit(	OS_TASK_PTR 	p_task
						void 			*p_arg
						CPU_STK			*p_stk_base
						CPU_STK_SIZE	stk_size)
{
	CPU_STK *p_stk;
	p_stk = &p_stk_base[stk_size];
	*--p_stk = (CPU_STK)0x01000000U;	/* xPSR的bit24必须置1 */
	*--p_stk = (CPU_STK)p_task;			/* R15(PC)任务的入口地址 */
	*--p_stk = (CPU_STK)0x14141414U;	/* R14(LR) */
	*--p_stk = (CPU_STK)0x12121212U;	/* R12 */
	*--p_stk = (CPU_STK)0x03030303U;	/* R3 */
	*--p_stk = (CPU_STK)0x02020202U;	/* R2 */
	*--p_stk = (CPU_STK)0x01010101U;	/* R1 */
	*--p_stk = (CPU_STK)p_arg;			/* R0 任务形参 */
	
	/* 异常发生时需要手动保存的寄存器 */
	*--p_stk = (CPU_STK)0x11111111U;	/* R11 */
	*--p_stk = (CPU_STK)0x10101010U;	/* R10 */
	*--p_stk = (CPU_STK)0x09090909U;	/* R9 */
	*--p_stk = (CPU_STK)0x03030303U;	/* R8 */
	*--p_stk = (CPU_STK)0x07070707U;	/* R7 */
	*--p_stk = (CPU_STK)0x06060606U;	/* R6 */
	*--p_stk = (CPU_STK)0x05050505U;	/* R5 */
	*--p_stk = (CPU_STK)0x04040404U;	/* R4 */
	return (p_stk);
}
```
+ ：p_task是任务名，指示着任务的入口地址，在任务切换的时候，需要加载到R15，即PC寄存器，这样CPU就可以找到要运行的任务
+ p_arg是任务的形参，用于传递参数，在任务切换的时候，需要加载到寄存器R0。R0寄存器通常用来传递参数
+ p_stk_base表示任务栈的起始地址
+ stk_size表示任务栈的大小，数据类型为CPU_STK_SIZE，在Cortex-M3内核的处理器中等于4个字节，即一个字。
+ ：获取任务栈的栈顶地址，ARMCM3处理器的栈是由高地址向低地址生长的。所以初始化栈之前，要获取到栈顶地址，然后栈地址逐一递减即可
+ 任务第一次运行的时候，加载到CPU寄存器的环境参数我们要预先初始化好。初始化的顺序固定，首先是异常发生时自动保存的8个寄存器，即xPSR、R15、R14、R12、R3、R2、R1和R0。其中xPSR寄存器的位24必须是1，R15PC指针必须存的是任务的入口地址，R0必须是任务形参，剩下的R14、R12、R3、R2和R1为了调试方便，填入与寄存器号相对应的16进制数。
+ 剩下的是8个需要手动加载到CPU寄存器的参数，为了调试方便填入与寄存器号相对应的16进制数
+ 返回栈指针p_stk，这个时候p_stk指向剩余栈的栈顶
+ 将剩余栈的栈顶指针p_sp保存到任务控制块TCB的第一个成员StkPtr中
+ 将任务栈的大小保存到任务控制块TCB的成员StkSize中
+ 函数执行到这里表示没有错误，即OS_ERR_NONE

**任务创建好之后，我们需要把任务添加到一个叫就绪列表的数组里面，表示任务已经就绪，系统随时可以调度。**

把任务TCB指针放到OSRDYList数组里面。
```c
OSRdyList[0].HeadPtr = &Task1TCB;
OSRdyList[1].HeadPtr = &Task2TCB;
```
OSRDYList是一个类型为OS_RDY_LIST的全局变量，在os.h中定义
```c
// OSRDYList的定义
OS_EXT OS_RDY_LIST OSRdyList[OS_CFG_PRIO_MAX];
```
+ OS_CFG_PRIO_MAX是一个定义，表示这个系统支持多少个优先级，目前这里仅用来表示这个就绪列表可以存多少个任务的TCB指针。具体的宏在os_cfg.h中定义

OS_RDY_LIST是就绪列表的数据类型，在os.h中声明
```c
/* OSRDY列表 */
typedef struct os_rdy_list	OS_RDY_LIST;
struct os_rdy_list{
	OS_TCB		*HeadPtr;
	OS_TCB		*TailPtr;
};
```
+ OS_RDY_LIST里面目前暂时只有两个TCB类型的指针</br>一个是头指针，一个是尾指针。</br>本章实验只用到头指针，用来指向任务的TCB。</br>只有当后面讲到同一个优先级支持多个任务的时候才需要使用头尾指针来将TCB串成一个双向链表。


## OS系统初始化
一般是在硬件初始化完成之后做的，主要做的工作就是初始化μC/OS-III中定义的全局变量。
OSInit()函数在文件os_core.c中定义，具体如下：
```c
void OSInit(OS_ERR *p_err){
	OSRunning = OS_START_OS_STOPPED;
	
	OSTCBCurPtr=(OS_TCB*)0;
	OSTCBHighRdyPtr=(OS_TCB*)0;
	
	OS_RdyListInit();
	
	*p_err=OS_ERR_NONE;
	// 代码运行到这里表示没有错误，即OS_ERR_NONE
}
```
+ 系统用一个全局变量OSRunning来指示系统的运行状态，刚开始系统初始化的时候，默认为停止状态，即OS_STATE_OS_STOPPED。
+ 全局变量OSTCBCurPtr是系统用于指向当前正在运行的任务的TCB指针，在任务切换的时候用得到
+ 全局变量OSTCBHighRdyPtr用于指向就绪任务中优先级最高的任务的TCB，在**任务切换**的时候用得到。
+ OS_RdyListInit()用于初始化全局变量OSRdyList[]，即初始化就绪列表。
+ OS_STATE_OS_STOPPED这个表示系统运行状态的宏也在os.h中定义

OS_RdyListInit()在os_core.c文件中定义,具体如下
```c
void OS_RdyListInit(void){
	OS_PRIO i;
	OS_RDY_LIST *p_rdy_list;
	
	for(i=oU;i<OS_CFG_PRIO_MAX;i++){
		p_rdy_list = &OSRdyList[i];
		p_rdy_list->HeadPtr = (OS_TCB *)0;
		p_rdy_list->TailPtr = (OS_TCB *)0;
	}
}
```

## 启动系统
任务创建好，系统初始化完毕之后，就可以开始启动系统了。
通过OSStart()在os_core.c中定义
```c
void OSStart(OS_ERR *p_err){
	if(OSRunning == OS_STATE_OS_STOPPED){
		// 系统是第一次启动的话，if肯定为真，则继续往下运行
		
		// 手动配置任务1先运行
		// STCBHIghRdyPtr指向第一个要运行的任务的TCB。因为暂时不支持优先级，所以系统启动时先手动指定第一个要运行的任务
		OSTCBHignRdyPtr = OSRdyList[0].HeadPtr;
		
		// 启动任务切换，不会返回
		
		OSStartHighRdy(); // 用于任务切换
		
		// 不会运行到这里，如果运行到了这里，表示发生了致命的错误
		*p_err = OS_ERR_FATAL_RETURN;
	}
	else{
		*p_err = OS_STATE_OS_RUNNING;
	}
}
```

OSStartHighRdy()用于启动任务切换，即配置PendSV的优先级为最低，然后触发PendSV异常，在PendSV异常服务函数中进行任务切换。
该函数不再返回，在文件os_cpu_a.s中定义，由汇编语言编写。
**常用的汇编指令**

| 指令名称        | 作用                                                                               |
| --------------- | ---------------------------------------------------------------------------------- |
| EQU             | 给数字常量取一个符号名，相当于C语言的define                                        |
| AREA            | 汇编一个新的代码段或者数据段                                                       |
| SPACE           | 分配内存空间                                                                       |
| PRESERVE8       | 按照8个字节对齐                                                                    |
| EXPORT          | 声明一个标号具有全局属性，可被外部的文件使用                                       |
| DCD             | 以字为单位分配内存，要求四字节对其，并要求初始化这些内存                           |
| PROC            | 定义子程序，与ENDP成对使用，表示子程序结束                                         |
| WEAK            | 弱定义                                                                             |
| IMPORT          | 声明标号来自外部文件，跟C语言的EXTERN关键字类似                                    |
| B               | 跳转到一个标号                                                                     |
| ALIGN           | 编译器对指令或者数据的存放地址进行对齐</br>一般需要跟一个立即数，缺省表示4字节对齐 |
| END             | 到达文件的末尾，文件结束                                                           |
| IF，ELSE，ENDIF | 汇编条件分支，跟C语言的if else类似                                                 |

OSStartHighRdy()函数
```asm
;*********************************************
; 开始第一次上下文切换
; 1. 配置PendSV异常优先级为最低
; 2. 在开始第一次上下文切换之前设置 psp=0
; 3. 出发PendSV异常，开始上下文切换
;*********************************************
OSStartHighRdy
LDR		R0,	=NVIC_SYSPRI14 		;设置PendSV异常优先级最低[1]
LDR 	R1，=NVIC_PENDSV_PRI
STRB 	R1，[R0]

MOVS	R0,#0 					;设置psp的值为0,开始第一次上下文切换[2]
MDR		PSP,R0

LDR		R0,=NVIC_INT_CTRL		;出发PendSV异常[3]
LDR 	R1,=NVIC_PENDSVSET
STR		R1,[R0]

CPSIE							;启用总中断，NMI和HardFault除外[4]

OSStartHang
B		OSStartHang				;程序应永远不会运行到这里
```
涉及的NVIC_INT_CTRL、NVIC_SYSPRI14、NVIC_PENDSV_PRI和NVIC_PENDSVSET这四个常量在os_cpu_a.s的开头定义
![[Pasted image 20210705202550.png]]

+ \[1]配置PendSV的优先级为0XFF，即最低。在μC/OS-III中，上下文切换是在PendSV异常服务程序中执行的，配置PendSV的优先级为最低，从而消灭了在中断服务程序中执行上下文切换的可能。
+ \[2]设置PSP的值为0，开始第一个任务切换。在任务中，使用的栈指针都是PSP，后面如果判断出PSP为0，则表示第一次任务切换。
+ \[3]触发PendSV异常，如果中断启用且有编写PendSV异常服务函数的话，则内核会响应PendSV异常，去执行PendSV异常服务函数。
+ \[4]开中断，因为有些用户在main()函数开始会先关掉中断，等全部初始化完成后，在启动OS的时候才开中断。

CM3专门设置了一条CPS指令，有四种用法：
```asm
CPSID I ;PRIMASK=1	;关中断
CPSIE I ;PRMASK=0	;开中断
CPSID F ;FAULTMASK=1;关异常
COSIE F ;FAULTMASK=0;开异常
```

上述寄存器的详细

| 名字      | 功能描述                                                                                                                                                                                                                   |     |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| PRIMASK   | 这是个只有单一比特的寄存器。</br>在它被置1后，就关掉所有可屏蔽的异常，只剩下NMI和硬FAULT可以响应。</br>它的缺省值是0，表示没有关中断。                                                                                     |     |
| FAULTMASK | 这是个只有1个位的寄存器。</br>当它置1时，只有NMI才能响应，所有其他的异常，甚至是硬FAULT，也通通闭嘴。</br>它的缺省值也是0，表示没有关异常。                                                                                |     |
| BASEPRI   | 这个寄存器最多有9位（由表达优先级的位数决定）。</br>它定义了被屏蔽优先级的阈值。</br>当它被设成某个值后，所有优先级号大于等于此值的中断都被关（优先级号越大，优先级越低）</br>但若被设成0，则不关闭任何中断，0也是缺省值。 |     |


## 任务切换
当调用OSStartHighRdy()函数，出发PendSV异常后，就需要编写PendSV异常服务函数，然后在里面进行任务切换。
PendSV_Handler由汇编编写

**PendSV异常服务函数名称必须与启动文件里中断向量表中的PendSV保持一致如果不一致则内核是响应不了用户编写的PendSV异常服务函数的，只响应启动文件里面默认的PendSV异常服务函数**

PendSV异常服务函数：
```asm
PendSV_Handler
;关中断，NMI和HardFault除外，防止上下文切换被中断

CPSID I; 

;将psp的值加载到R0
MRS R0,PSP

;判断R0,如果值为0则跳转到OS_CPU_PendSVHandler_nosave
;进行第一次任务切换的时候，R0肯定位0

CBZ R0,OS_CPU_PendSVHandler_nosave


;保存上文
;任务的切换，即把下一个要运行的任务的栈内容加载到CPU寄存器中
;在进入PendSV异常的时候，当前CPU的xPSR，PC(任务入口地址)
;R14,R12,R3,R2,R1,R0会自动存储到当前的任务栈
;同时递减PSP的值，随便通过代码：MRS R0, PSP把PSP的值传给R0


;手动存储CPU寄存器R4-R11的值到当前任务的栈
STMDB R0!,{R4-R11}

;加载OSTCBCurPtr指针的地址到R1，这里LDR属于伪指令
LDR R1,=OSTCBCurPtr
;加载OSTCBCurPtr指针到R1，这里LDR属于ARM指令
LDR R1,[R1]
;存储R0的值到OSTCBCurPtr->OSTCBStkPtr，这个时候R0存的是任务空闲栈的栈顶
STR R0,[R1]

; 切换下文
; 实现OSTCBCurPtr=OSTCBHighRdyPtr
; 把下一个要运行的任务的栈内容加载到CPU寄存器中


OS_CPU_PendSVHandler_nosave
;加载OSTCBCurPtr指针的地址到R0，这里LDR属于伪指令
LDR R0,=OSTCBCurPtr
;加载OSTCBHighRdyPtr指针的地址到R1，这里LDR属于伪指令
LDR R1,=OSTCBHighRdyPtr
;加载OSTCBHighRdyPtr指针到R2，这里LDR属于ARM指令
LDR R2,[R1]
;存储OSTCBHighRdyPtr到OSTCBCurPtr
STR R2,[R0]

;加载OSTCBHighRdyPtr到R0
LDR R0,[R2]
;加载需要手动保存的信息到CPU寄存器R4-R11
LDMIA R0!,{R4-R11}

;更新PSP的值，这个时候PSP指向下一个要执行的任务的栈的栈底
;（这个栈底已经加上刚刚手动加载到CPU寄存器R4-R11的偏移）
MSR PSP, R0

;确保异常返回使用的栈指针是PSP，即LR寄存器的位2要为1
ORR LR, LR,#0x04


;开中断
CPSIE I
;异常返回，这个时候任务栈中的剩下内容将会自动加载到xPSR，
;PC（任务入口地址），R14，R12，R3，R2，R1，R0（任务的形参）
;同时PSP的值也将更新，即指向任务栈的栈顶。
;在STM32中，栈是由高地址向低地址生长的。

BX LR
```

PendSV异常服务中主要完成两个工作
一是保存上文，即保存当前正在运行的任务的环境参数
二是切换下文，即把下一个需要运行的任务的环境参数从任务栈中加载到CPU寄存器，从而实现任务的切换

PendSV异常服务中用到了`OSTCBCurPtr`和`OSTCBHighRdyPtr`这两个全局变量，这两个全局变量在os.h中定义，要想在汇编文件os_cpu_a.s中使用，必须将这两个全局变量导入到os_cpu_a.s中

## main函数
在app.c中编写
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
任务切换实际上就是出发pendSV异常，然后在PendSV异常中进行上下文切换
```c
void OSSched(void){
	if(OSTCBCurPtr == OSRdyList[0].HeadPtr){
	
		OSTCBHighRdyPtr = OSRdyList[1].HeadPtr;
	}
	else{
	
		OSTCBHighRdyPtr=OSRdyList[0].HeadPtr;
	}
	OS_TASK_SW();
}
```
此OSSched()函数的调度算法，如果当前任务是1,那么下一个任务就是任务2，如果当前任务是2,那么下一个任务就是1
然后再调用OS_TASK_SW()函数触发PendSV异常，然后在PendSV异常里面实现任务的切换。

OS_TASK_SW()函数其实是一个宏定义，具体是往中断及状态控制寄存器SCB_ICSR的位28（PendSV异常启用位）写入1，从而触发PendSV异常。
OS_TASK_SW()函数在os_cpu.h文件中实现。
