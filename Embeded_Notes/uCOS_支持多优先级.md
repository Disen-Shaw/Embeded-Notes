# 支持多优先级
在μC/OS-III中，数字优先级越小，逻辑优先级越高
## 定义优先级相关的全局变量
在支持任务多优先级的时候，需要在os.h头文件添加两个优先级相关的全局变量，如下
```c
/* 在os.h中定义 */
// 当前优先级
OS_EXT OS_PRIO OSPrioCur;
// 最高优先级
OS_EXT OS_PRIO OSPrioHighRdy;
```

## 修改OSInit()函数
上面添加的优先级相关的全部变量，需要在OSInit()函数中进行初始化，**其实OS中定义的所有的全局变量都是在OSInit()中初始化的。**
代码如下：
```c
voidOSInit(OS_ERR*p_err)
{
	/*配置OS初始状态为停止态*/
	OSRunning=OS_STATE_OS_STOPPED;
	/*初始化两个全局TCB，这两个TCB用于任务切换*/
	OSTCBCurPtr=(OS_TCB*)0;
	OSTCBHighRdyPtr=(OS_TCB*)0;
	
	/*初始化优先级变量*/
	OSPrioCur=(OS_PRIO)0;
	OSPrioHighRdy=(OS_PRIO)0;

//////////////////////////////////////////////////////////////////////////////
	/*初始化优先级表*/
	OS_PrioInit();
//////////////////////////////////////////////////////////////////////////////
	
	/*初始化就绪列表*/
	OS_RdyListInit();
	
	/*初始化空闲任务*/
	OS_IdleTaskInit(p_err);
	if(*p_err!=OS_ERR_NONE){
		return;
	}
}
```

## 修改任务控制块TCB
在任务控制块中，加入优先级字段Prio，优先级Prio的数据类型为OS_PRIO，宏展开后是8位的整型，所以只支持255个优先级
**TCB结构体改动如下**
```c
structos_tcb{
	CPU_STK *StkPtr;
	CPU_STK_SIZE StkSize;
	
	/*任务延时周期个数*/
	OS_TICK TaskDelayTicks;
	
	/*任务优先级*/
	OS_PRIO Prio;
	
	/*就绪列表双向链表的下一个指针*/
	OS_TCB *NextPtr;
	/*就绪列表双向链表的前一个指针*/
	OS_TCB *PrevPtr;
	
};
```

另外，还修改了下面的一些函数

| 函数              | 改动                                 |
| ----------------- | ------------------------------------ |
| OSTaskCreate()    | 在里面加入优先级相关的处理           |
| OS_IdleTaskInit() | 跟空闲任务分配一个优先级             |
| OSStart()         | 具体哪一个任务最先运行，由优先级决定 |
| PendSV_Handler()  | 添加了优先级相关的代码               |
| OSTimeDly()       |                                      |
| OSSched()         | 需要根据优先级来调度                 |
| OSTimeTick()      |                                      |
