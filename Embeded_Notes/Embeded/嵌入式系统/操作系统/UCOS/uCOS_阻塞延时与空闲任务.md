# 阻塞延时与空闲任务
之前任务体内的延时使用的是软件延时，即还是让CPU空等来达到延时的效果。使用RTOS的很大优势就是榨干CPU的性能，永远不能让它闲着，任务如果需要延时也就不能再让CPU空等来实现延时的效果。

RTOS中的延时叫阻塞延时，即任务需要延时的时候，任务会放弃CPU的使用权，CPU可以去干其他的事情，当任务延时时间到，重新获取CPU使用权，任务继续运行，这样就充分地利用了CPU的资源，而不是干等着。当任务需要延时，进入阻塞状态，如果没有其他任务可以运行，RTOS都会为CPU创建一个空闲任务，这个时候CPU就运行空闲任务。

在μC/OS-III中，空闲任务是系统在初始化的时候创建的优先级最低的任务，空闲任务主体很简单，只是对一个全局变量进行计数。鉴于空闲任务的这种特性，在实际应用中，当系统进入空闲任务的时候，可在空闲任务中让单片机进入休眠或者低功耗等操作

## 实现空闲任务
### 定义空闲任务栈
空闲任务栈在os_cdf_app.c中定义，具体如下
```c

// 空闲任务栈起始地址
CPU_STK		OSCfg_IdleTaskStk[OS_CFG_IDLE_TASK_STK_SIZE];
// 空闲任务的栈是一个定义好的数组，大小由OS_CFG_IDLE_TASK_STK_SIZE这 个 宏 控 制。OS_CFG_IDLE_TASK_STK_SIZE在os_cfg_app.h这个头文件定义，大小为128

// 空闲任务栈大小
CPU_STK_SIZEconstOSCfg_IdleTaskStkSize=(CPU_STK_SIZE)OS_CFG_,→IDLE_TASK_STK_SIZE;
```

空闲任务的栈的起始地址和大小均被定义成一个常量，不能被修改
变量OSCfg_IdleTaskStkBasePtr和OSCfg_IdleTaskStkSize同时还在os.h中声明，这样就具有全局属性，可以在其他文件里面被使用，
空闲任务栈起始地址和任务栈大小如下：
```c
// 空闲任务栈起始地址
extern CPU_STK  *const OSCfg_IdleTaskStkBasePtr;

// 空闲任务栈大小
extern CPU_STK_SIZE constOSCfg_IdleTaskStkSize;
```

### 定义空闲任务TCB
任务控制块TCB是每一个任务必须的，空闲任务的TCB在os.h中定义，是一个全局变量
如下
```c
// 空闲任务TCB
OS_EXT OS_TCB OSIdleTaskTCB;
```

### 定义空闲任务函数
空闲任务正如其名，空闲，任务体里面只是对全局变量OSIdleTaskCtr++操作，如下
```c
void OS_IdleTask(void){
	p_arg = p_arg;
	/* 空闲任务什么都不做，只对全局变量OSIdleTaskCtr++操作 */
	for(;;){
		OSIdleTaskCtr++;
	}
}
```
空闲任务中的全局变量OSIdletaskCtr在os.h中定义,如下
```c
/* 空闲任务计数变量 */
OS_EXT OS_IDLE_CTR OSIdleTaskCtr;
```
OS_IDLE_CTR是在os_type.h中重新定义的数据类型，如下：
```c
typedef CPU_INT32U OS_IDLE_CTR;
```

### 空闲任务初始化
空闲任务的初始化在OSInit()在完成，意味着在系统还没有启动之前空闲任务就已经创建好，具体在os_core.c定义,如下：
**系统初始化函数**
```c
void OSInit(OS_ERR*p_err){
	// 配置OS初始状态为停止态
	OSRunning = OS_STATE_OS_STOPPED;
	
	/*初始化两个全局TCB，这两个TCB用于任务切换*/
	OSTCBCurPtr=(OS_TCB*)0;
	OSTCBHighRdyPtr=(OS_TCB*)0;
	
	// 初始化就绪列表
	OS_RdyListInit();

////////////////////////////////////////////////////////////////////////////////
	// 初始化空闲任务
	OS_IdleTaskInit(p_err);
////////////////////////////////////////////////////////////////////////////////
	if(*p_err!=OS_ERR_NONE) {
		return;
	}
}
```
**空闲任务初始化函数**
```c
void OS_IdleTaskInit(OS_ERR *p_err){
	// 初始化空闲任务计数器
	OSIdleTaskCtr=(OS_IDLE_CTR)0;
	
	// 创建空闲任务
	OSTaskCreate( (OS_TCB*)&OSIdleTaskTCB,
				  (OS_TASK_PTR )OS_IdleTask,
				  (void *)0,
				  (CPU_STK*)OSCfg_IdleTaskStkBasePtr,
				  (CPU_STK_SIZE)OSCfg_IdleTaskStkSize,
				  (OS_ERR*)p_err );
}
```

## 实现阻塞延时
阻塞延时的阻塞是指任务调用该延时函数后，任务会被剥离CPU使用权，然后进入阻塞状态，直到延时结束，任务重新获取CPU使用权才可以继续运行。在任务阻塞的这段时间，CPU可以去执行其他的任务，如果其他的任务也在延时状态，那么CPU就将运行空闲任务。
阻塞延时函数在os_time.c中定义，具体如下
```c
/* 阻塞延时 */
void OSTimeDly(OS_TICK dly){
	
	// 设置延时时间
	OSTCBCurPtr->TaskDelayTicks=dly;
	
	// 进行任务调度
	OSSched();
}
```
**TaskDelayTicks是任务控制块的一个成员，用于记录任务需要延时的时间，单位为SysTick的中断周期**
此时具体的os_tcb代码如下：
```c
struct os_tcb{
	CPU_STK			*StkPtr;
	CPU_STK_SIZE 	StkSize;
	
	// 任务延时周期个数
	OS_TICK			TaskDelayTicks;
};
```
调度任务也有不同
之前的调度任务是两个任务轮流执行
将之更改为当前任务如果是空闲任务，么就去尝试执行任务1或者任务2
看他们的延时时间是否结束，如果任务的延时时间均没有到期，那就返回继续执行空闲任务
具体如下所示：
```c
void OSSched(void){
	if(OSRdyList[0]==&OSIdleTaskTCB){
		if(OSRdyList[0].HeadPtr->TaskDelayTicks==0){
			OSTCBHighRdyPtr=OSRdyList[0].HeadPtr;
		}
		else if{
			OSTCBHighRdyPtr=OSRdyList[1].HeadPtr;
		}
		else{
			/*任务延时均没有到期则返回，继续执行空闲任务*/
			return;
		}
	}
	else{
	/*如果是task1或者task2的话，检查下另外一个任务,如果另外的任务不在延时中，就切换到该任务否则，判断下当前任务是否应该进入延时状态，如果是的话，就切换到空闲任务。否则就不进行任何切换*/
		if(OSTCBCurPtr==OSRdyList[0].HeadPtr){
			if(OSRdyList[1].HeadPtr->TaskDelayTicks==0){
				OSTCBHighRdyPtr=OSRdyList[1].HeadPtr;
			}
			else if(OSTCBCurPtr->TaskDelayTicks != 0){
				OSTCBHighRdyPtr = &OSIdleTaskTCB;
				
			}
			else{
				/*返回，不进行切换，因为两个任务都处于延时中*/
				return;
			}
		}
		else if(OSTCBCurPtr==OSRdyList[1].HeadPtr){
			if(OSRdyList[0].HeadPtr->TaskDelayTicks==0){
				OSTCBHighRdyPtr=OSRdyList[0].HeadPtr;
			}
			else if(OSTCBCurPtr->TaskDelayTicks!=0){
				OSTCBHighRdyPtr=&OSIdleTaskTCB;
			}
			else{
				/*返回，不进行切换，因为两个任务都处于延时中*/
				return;
			}
		}
	}
	OS_TASK_SW();
}
```


## main()函数
主函数中做出更改
```c
int main(void){
	OS_ERR err;
	
	/* 关闭中断 */
	CPU_IntDis();
	
	/* 配置SysTick 10ms 一次 */
	OS_CPU_SysTickInit(10);
	
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

// 不再需要软件延时

/* 任务1 */
void Task1(void *p_arg){
	for(;;){
	
		flag1 = 1;	
		// delay(100);
		ISTimeDly(2);
		
		flag1 = 0;
		// delay(100);
		ISTimeDly(2);
		
		/* 任务切换，这里是手动切换 */
		OSSched();
	}
}

/* 任务2 */
void Task2(void *p_arg){
	for(;;){
	
		flag2 = 1;	
		// delay(100);
		ISTimeDly(2);
		
		flag2 = 0;
		// delay(100);
		ISTimeDly(2);
		
		/* 任务切换，这里是手动切换 */
		OSSched();
	}
}
```

空闲任务初始化函数在OSInit中调用，在系统启动之前创建好空闲任务
延时函数替代为阻塞延时，延时周期为2个SysTick周期

到这里，两个任务就像好像在CPU中一起运行了
![[Pasted image 20210706104722.png]]