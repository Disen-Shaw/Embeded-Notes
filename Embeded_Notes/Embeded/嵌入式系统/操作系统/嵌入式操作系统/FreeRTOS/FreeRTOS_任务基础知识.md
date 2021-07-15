 # FreeRTOS
## FreeRTOS任务特性
+ 简单
+ 没有使用限制
+ 支持抢占
+ 支持优先级
+ 每个任务都拥有堆栈导致RAM使用量增大
+ 如果使用抢占的话必须仔细考虑重入的问题

 ## FreeRTOS四种任务状态
![[Pasted image 20210712214618.png]]
 + 运行态
 + 就绪态
 + 阻塞态
 + 挂起态

### 运行态
当一个任务正在运行时，那么就说这个任务处于运行态，处于运行态的任务就是当前正在使用处理器的任务。**如果使用的是单核处理器的话那么不管在任何时刻永远都只有一个任务处于运行态。**

### 就绪态
处于就绪态的任务是那些已经准备就绪(这些任务没有被阻塞或者挂起)，可以运行的任务，但是处于就绪态的任务还没有运行，**因为有一个同优先级或者更高优先级的任务正在运行**

### 阻塞态
如果一个任务当前正在等待某个外部事件的话就说它处于阻塞态，比如说如果某个任务调用了函数vTaskDelay()的话就会进入阻塞态，直到延时周期完成。任务在等待队列、信号量、事件组、通知或互斥信号量的时候也会进入阻塞态。任务进入阻塞态会有一个超时时间，当超过这个超时时间任务就会退出阻塞态，**即使所等待的事件还没有来临**

### 挂起态
像阻塞态一样，任务进入挂起态以后也不能被调度器调用进入运行态，但是进入挂起态的任务没有超时时间。任务进入和退出挂起态通过调用函数`vTaskSuspend()`和`xTaskResume()`。

## 任务优先级
任务优先级决定了任务的执行优先级别，在FreeRTOS中任务优先级可选范围为`0～configMAX_PRIORITIES-1`
数字越大，优先级越高

FreeRTOS调度器确保处于就绪态或运行态的高优先级的任务获取处理器使用权。当宏	`configUSE_TIME_SLICING`定义为1的时候多个任务可以共用一个优先级，数量不限。
默认情况下宏`configUSE_TIME_SLICING`在文件FreeRTOS.h中已经定义为1。
此时处于就绪态的优先级相同的任务就会使用`时间片轮转调度器`获取运行时间。

## 任务实现
任务实现即为任务的具体工作内容
```c
void vATaskFunction(void *pvParameters){
	for(;;){
		任务应用程序
		vTaskDelay();
	}
	// 不能从任务函数中返回或者退出，从任务函数中返回或退出的话会调用configASSERT()，
	// 前提是定义了configASSERT()。
	// 如果一定要从任务函数中退出，一定要调用函数vTaskDelete(NULL)来删除此任务
	vTaskDelete(NULL);
}
```

## 任务控制块
描述任务属性的数据结构称之为任务控制块，为TCB_t
```c
typedef struct tskTaskControlBlock{
	volatile StackType_t *pxTopOfStack;			// 任务堆栈栈顶
#if (portUSING_MPU_WRAPPERS == 1)	
	xMPU_SETTINGS	xMPUSettings;				// MPU相关设置
#endif	
	ListItem_t		xStateListItem;				// 状态列表项
	ListItem_t		xEventListItem;				// 事件列表项
	UBaseType_t		uxPriority;					// 任务优先级
	StackType_t		*pxStack;					// 任务堆栈起始地址
	charpcTaskName[ onfigMAX_TASK_NAME_LEN];	// 任务名字
#if ( portSTACK_GROWTH > 0 )
	StackType_t*pxEndOfStack;					//任务堆栈栈底
#endif
#if ( portCRITICAL_NESTING_IN_TCB == 1 )
	UBaseType_t		uxCriticalNesting;			//临界区嵌套深度
#endif
#if ( configUSE_TRACE_FACILITY == 1 )			//trace或到debug的时候用到
	UBaseType_t		uxTCBNumber;
	UBaseType_t		uxTaskNumber;
#endif
#if ( configUSE_MUTEXES == 1 )
	UBaseType_t		uxBasePriority;				//任务基础优先级,优先级反转的时候用到			
	UBaseType_t		uxMutexesHeld;				//任务获取到的互斥信号量个数
#endif
#if ( configUSE_APPLICATION_TASK_TAG == 1 )
	TaskHookFunction_t pxTaskTag;
#endif
#if( configNUM_THREAD_LOCAL_STORAGE_POINTERS > 0 )	//与本地存储有关
	void *pvThreadLocalStoragePointers[ configNUM_THREAD_LOCAL_STORAGE_POINTERS ];
#endif
#if( configGENERATE_RUN_TIME_STATS == 1 )
	uint32_t		ulRunTimeCounter;			//用来记录任务运行总时间
#endif
#if ( configUSE_NEWLIB_REENTRANT == 1 )
	struct_reent 	xNewLib_reent;				//定义一个newlib结构体变量
#endif
#if( configUSE_TASK_NOTIFICATIONS == 1 )		//任务通知相关变量
	volatile uint32_t ulNotifiedValue;			//任务通知值
	volatile uint8_t ucNotifyState;				//任务通知状态
#endif
#if( tskSTATIC_AND_DYNAMIC_ALLOCATION_POSSIBLE != 0 )
	//用来标记任务是动态创建的还是静态创建的，如果是静态创建的此变量就为pdTURE，
	//如果是动态创建的就为pdFALSE
	uint8_t			ucStaticallyAllocated;
#endif
#if( INCLUDE_xTaskAbortDelay == 1 )
	uint8_t			ucDelayAborted;
#endif
	
}tskTCB;
typedef  
```
新版本的FreeRTOS任务控制块重命名为TCB_t，但是本质上还是tskTCB，主要是为了兼容就版本的应用

`可以看出来FreeRTOS的任务控制块中的成员变量相比UCOSIII要少很多，而且大多数与裁剪有关，当不使用某些功能的时候与其相关的变量就不参与编译，任务控制块大小就会进一步的减小。`

## 任务堆栈
FreeRTOS之所以能正确的恢复一个任务的运行就是因为有任务堆栈在保驾护航，任务调度器在进行任务切换的时候会将当前任务的现场(CPU寄存器值等)保存在此任务的任务堆栈中，等到此任务下次运行的时候就会先用堆栈中保存的值来恢复现场，恢复现场以后任务就会接着从上次中断的地方开始运行

用来保存现场(CPU寄存器值)，创建任务的时候需要指定任务栈，任务堆栈的变量类行为StackType_t，变量类型如下：
```c
#define portSTACK_TYPE uint32_t
#define portBASE_TYPE long 
typedef portSTACK_TYPE StackTypep_t;
```
需要根据任务的大小设置合适的堆栈大小
