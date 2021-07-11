# 任务的创建
## uCOSIII任务堆栈
### 任务堆栈的创建
任务堆栈是任务的重要部分，堆栈是RAN中按照“先进先出(FIFO)”的原则组织的一块连续的存储空间。为了满足人物切换和响应中断时保存CPU寄存器中的内容和调用其他函数时需要，每个任务都有自己的堆栈。
`理解成队列，堆栈是先进后出的`

```c
#define START_STK_SIZE 512 				// 堆栈大小
CPU_STK START_TASK_STK[START_STK_SIZE];	// 定义一个数组来作为任务的堆栈
```
CPU_STK是任务堆栈的数据结构，于cpu.h中定义，为CPU_INT32U类型，也就是unsigned int类型，为4个字节，那么任务堆栈大小就是512\*4=2048字节

### 任务堆栈初始化
任务通过恢复现场换回上一个任务并且还能接着从上次被中断的地方开始运行。在创建新任务时，必须把系统启动这个任务时所需要的CPU各个寄存器初始值事先存放在任务堆栈中
这样当获得CPU使用权时，就会吧任务堆栈的内容复制到CPU的各个寄存器，从而让任务顺利的启动并运行。

吧任务初始数据存放到任务堆栈的工作就叫做任务堆栈的初始化，uCOSIII提供了完成堆栈初始化的函数：
OStaskStkInit(),定义如下：
```c
CPU_STK *OSTaskStkInit(
						OS_TASK_PTR		p_task,
						void 			*parg
						CPU_STK			*p_stk_limmit,
						CPU_STK_SIZE	stk_size,
						OS_OPT			opt);
```
用户一般不会直接操作堆栈初始化函数，任务堆栈初始化函数由任务创建函数OSTaskCreate()调用
不同的CPU对于寄存器和堆栈的操作方式不同，因此在一直uCOSIII的时候要根据所选的CPU编写任务堆栈初始化函数。

### CPU任务堆栈的使用方式
作为任务创建函数OSTaskCreate()的参数，函数OSTaskCreate()如下
```c
voidOSTaskCreate(
					OS_TCB			*p_tcb,			// 任务控制块
					CPU_CHAR		*p_name,		// 任务名字
					OS_TASK_PTR		p_task,			// 任务函数
					void 			*p_arg,			// 传递给任务函数的参数
					OS_PRIO			prio,			// 任务的优先级
					CPU_STK			*p_stk_base, 	// 任务堆栈基地址
					CPU_STK_SIZE	stk_limit,		// 任务堆栈深
					CPU_STK_SIZE	stk_size,		// 任务堆栈大小
					OS_TICK			time_quanta,	// 任务内部消息队列能够接收到的最大消息数目，为0时禁止接受消息
					void			*p_ext,			// 用户补充的存储区
					OS_OPT			opt,			// 任务选项
					OS_ERR			*p_err)			// 存放该函数错误时的返回值
```

## 任务控制块
### 任务控制块
任务控制块用来记录与任务相关的信息的数据结构，每个任务都要有自己的任务控制块，任务控制块由用户`自行创建`，例如
```c
OS_TCB	StartTaskTCB;	// 创建一个任务控制块
```
OS_TCB为一个结构体，描述了任务控制夸，`任务控制块中的成员变量用户不能直接访问`，更不可能改变他们
OS_TCB为一个结构体，其中有些成员才用了条件编译的方式来确定。
任务控制块定义如下：
```c
struct os_tcb {
	CPU_STK *StkPtr;							//指向当前任务堆栈的栈顶
	void *ExtPtr; 								//指向用户可定义的数据区
	CPU_STK *StkLimitPtr;						//可指向任务堆栈中的某个位置
	OS_TCB *NextPtr; 							//NexPtr和PrevPtr用于在任务就绪表建立
	OS_TCBOS_TCB *PrevPtr; 						//双向链表
	OS_TCB *TickNextPtr;						// TickNextPtr和TickPrevPtr可把正在延时或在指定时
	OS_TCB *TickPrevPtr;						//间内等待某个事件的任务的OS_TCB构成双向链表
	
	OS_TICK_SPOKE *TickSpokePtr; 				//通过该指针可知道该任务在时钟节拍轮的那个spoke上
	CPU_CHAR *NamePtr; 							//任务名
	CPU_STK *StkBasePtr; 						//任务堆栈基地址
	OS_TASK_PTR TaskEntryAddr;					//任务代码入口地址
	void *TaskEntryArg; 						//传递给任务的参数
	OS_PEND_DATA *PendDataTblPtr;				//指向一个表，包含有任务等待的所有事件对象的信息
	OS_STATE PendOn; 							//任务正在等待的事件的类型
	OS_STATUS PendStatus; 						//任务等待的结果
	OS_STATE TaskState; 						//任务的当前状态
	OS_PRIO Prio; 								//任务优先级
	CPU_STK_SIZE StkSize; 						//任务堆栈大小
	OS_OPT Opt; 								//保存调用OSTaskCreat()创建任务时的可选参数options的值
	OS_OBJ_QTY PendDataTblEntries; 				//任务同时等待的事件对象的数目
	CPU_TS TS; 									//存储事件发生时的时间戳
	OS_SEM_CTR SemCtr;							//任务内建的计数型信号量的计数值
	OS_TICK TickCtrPrev; 						//存储OSTickCtr之前的数值
	OS_TICK TickCtrMatch; 						//任务等待延时结束时，当TickCtrMatch和OSTickCtr的数值相匹配时，任务延时结束
	OS_TICK TickRemain; 						//任务还要等待延时的节拍数
	OS_TICK TimeQuanta;							// TimeQuanta和TimeQuantaCtr与时间片有关	
	OS_TICK TimeQuantaCtr;
	void *MsgPtr; 指向任务接收到的消息
	OS_MSG_SIZE MsgSize;						//任务接收到消息的长度
	OS_MSG_Q MsgQ; 								//UCOSIII允许任务或ISR向任务直接发送消息，MsgQ就为这个消息队列
	CPU_TS MsgQPendTime;						//记录一条消息到达所花费的时间
	CPU_TS MsgQPendTimeMax; 					//记录一条消息到达所花费的最长时间
	OS_REG RegTbl[OS_CFG_TASK_REG_TBL_SIZE]; 	//寄存器表，和CPU寄存器不同	
	OS_FLAGS FlagsPend; 						//任务正在等待的事件的标志位
	OS_FLAGS FlagsRdy; 							//任务在等待的事件标志中有哪些已经就绪
	OS_OPTFlagsOpt; 							//任务等待事件标志组时的等待类型
	OS_NESTING_CTR SuspendCtr; 					//任务被挂起的次数
	OS_CPU_USAGE CPUUsage; 						//CPU使用率
	OS_CPU_USAGE CPUUsageMax;					//CPU使用率峰值
	OS_CTX_SW_CTR CtxSwCtr; 					//任务执行的频繁程度
	CPU_TS CyclesDelta; 						//改成员被调试器或运行监视器利用
	CPU_TS CyclesStart; 						//任务已经占用CPU多长时间
	OS_CYCLES CyclesTotal; 						//表示一个任务总的执行时间
	OS_CYCLES CyclesTotalPrev; 
	CPU_TS SemPendTime; 						//记录信号量发送所花费的时间
	CPU_TS SemPendTimeMax; 						//记录信号量发送到一个任务所花费的最长时间
	CPU_STK_SIZE StkUsed; 						//任务堆栈使用量
	CPU_STK_SIZE StkFree; 						//任务堆栈剩余量
	CPU_TS IntDisTimeMax; 						//该成员记录任务的最大中断关闭时间
	CPU_TS SchedLockTimeMax; 					//该成员记录锁定调度器的最长时间
	OS_TCB *DbgPrevPtr;							//下面3个成语变量用于调试
	OS_TCB *DbgNextPtr;
	CPU_CHAR *DbgNamePtr;
};
```
### 任务控制块初始化
**函数OSTaskCreate()在创建任务的时候会对任务的控制块进行初始化**。函数OS_taskInitTCB()用于初始化任务控制块。**用户的不需要自行初始化任务控制块**。

### 任务就绪表
#### 优先级
uCOSIII中任务优先级有宏OS_CFG_PRIO_MAX来配置，位于os_cfg.h，uCOSIII中数值越小，优先级越高，**最低可用优先级就是OS_CFG_PRIO_MAX-1。**
默认情况下是个优先级

#### 就绪表
uCOSIII中就绪表由2部分组成:
1. 优先级位映射表OSPrioTbl[]:用来记录哪个优先级下有任务就绪
2. 就绪任务列表OSRdyList[]:用来记录每一个优先级下所有的就绪任务

OSPrioTbl[]在os_prio.c中有定义
```c
CPU_DATA	OSPrioTbl[OS_PRIO_TBL_SIZE];
```
在STM32中CPU_DATA为`unsigned int`，有四个字节，32位。因此表OSPrioTbl每个参数有32位，其中每个位对应一个优先级。
因此表OSPrioTbl每个参数有32位，其中每个位对应一个优先级。
OS_PRIO_TBL_SIZE = (((OS_CFG_PRIO_MAX-1u)/DEF_INT_CPU_NBR_BITS)+1)
OS_CFG_PRIO_MAX由用户自行定义，默认为64。
DEF_INT_CPU_NBR_BITS = CPU_CFG_DATA_SIZE * DEF_OCTET_NBB_BITS
CPU_CFG_DATA_SIZE = CPU_WORD_SIZE_32 = 4
DEF_OCTET_NBR_BITS = 8
所以，当系统有64个优先级的时候：OS_PRIO_TBL_SIZE = ((64-1)/(4\*8)+1)=2

##### 寻找优先级最高的任务
函数OS_PrioGetHighest()用于找到就绪了的最高优先级的任务
函数实现如下
```c
OS_PRIO OS_PrioGetHighest(void){
	CPU_DATA		*p_tbl;
	OS_Prio			prio;
	
	prio = (OS_PRIO)0;
	p_tbl = &OSPrioTbl[0];
	while(*p_tbl == (CPU_DATA)0){
		prio += DEF_INT_CPU_NBR_BITS;
		p_tbl++;
	}
	prio += (OS_PRIO)CPU_CntLeadZeros(*p_tbl);
	return (prio);
}
```

##### 就绪任务列表
已知了那个优先级的任务已经就绪了，但是uCOSIII支持时间片轮转调度，同一个优先级可以有多个任务，因此还需要确定是优先级下的那哪些任务
就绪列表定义如下，**是一个带头节点的双向列表**
```c
struct os_rdy_list{
	OS_TCB			*HeadPtr;		// 用于创建链表，只想链表头
	OS_TCB			*TailPtr;		// 用于创建链表，只想链表尾
	OS_OBJ_QTY		NbrEntries;		// 此优先级下的任务量
};
```
**同一优先级下如果有多个任务的话最先运行的永远是HeadPtr所指向的任务**


## 注意
uCOSIII中一下优先级用户程序不能使用，这些优先级分配给了uCOSIII的5个系统内部任务
+ 优先级0：中断服务管理任务`OS_IntQTask()`
+ 优先级1：时钟节拍任务`OS_TickTask()`
+ 优先级2：定时任务 `OS_TmrTask()`
+ 优先级OS_CFG_PRIO_MAX-2：统计任务 `OS_StatTask()`
+ 优先级OS_CFG_PRIO_MAX-1：空闲任务 `OS_IdleTask()`