# uCOSIII中断
中断对应内部或外部异步事件的请求终止当前任务，而去处理异步事件所要求的任务的过程叫做中断
使用的情况下重点为如何在uCOSIII下编写中断服务函数
```c
void USART1_IRQHandler(void){
	OSIntEnter();
	// 中断服务函数
	OSIntExit();
}
```
## 进入和退出中断服务函数
进入中断服务函数以后使用函数`OSIntEnter()`，定义如下:
```c
void OSintEnter(void){
	if(OSRunnng!=OS_STATE_OS_RUNNING){
		return;
	}
	if(OSIntNestingCtr >= (OS_NESTING_CTR)250u){
		return;
	}
	OSIntNestingCtr++;
}
```
`OSIntNestingCtr`记录中断嵌套次数，uCOSIII最多支持250级的中断嵌套。
退出中断服务函数时要用`OSIntExit()`


## uCOSIII临界代码保护
临界代码段也叫临界区，是指那些必须完整连续运行，不可以被大段的代码段。当访问这些临界代码段的时候需要对这些临界代码段进行保护。
当宏`OS_CFG_ISR_POST_DEFERRED_EN`为0时，uCOSIII使用关中断的方式来保护临界段代码，当设置为1的时候就会采用给调度器上锁的方式来保护临界段代码。
uCOS定义了一个进入临界段代码的宏：`OS_CRITICAL_ENTER()`，定义了两个退出临界段代码的宏：`OS_CRITICAL_EXIT`和`OS_CRITICAL_EXIT_NO_SCHED(不进行任务调度)`
