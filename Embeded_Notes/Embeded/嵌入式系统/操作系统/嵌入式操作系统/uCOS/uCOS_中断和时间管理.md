# uCOSIII中断和时间管理
## uCOS中断管理
中断对应内部或外部异步事件的请求终止当前任务，而去处理异步事件所要求的任务的过程叫做中断
使用的情况下重点为如何在uCOSIII下编写中断服务函数
```c
void USART1_IRQHandler(void){
	OSIntEnter();
	// 中断服务函数
	OSIntExit();
}
```
### 进入和退出中断服务函数
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
`OSIntNestingCtr`记录中断嵌套次数，**uCOSIII最多支持250级的中断嵌套。**
退出中断服务函数时要用`OSIntExit()`，每完成一个中断，`OSIntNestCtr`的值就会减1



### uCOSIII临界代码保护
临界代码段也叫临界区，是指那些必须完整连续运行，不可以被大段的代码段。当访问这些临界代码段的时候需要对这些临界代码段进行保护。
当宏`OS_CFG_ISR_POST_DEFERRED_EN`
+ 为0时，uCOSIII使用关中断的方式来保护临界段代码
+ 为1时，会采用给调度器上锁的方式来保护临界段代码。

采用关中断的方式会影响到时间相关的底层外设，而调度器上锁的方式会被中断给剥夺内核

uCOS定义了一个进入临界段代码的宏：`OS_CRITICAL_ENTER()`，定义了两个退出临界段代码的宏：
+ `OS_CRITICAL_EXIT`
+ `OS_CRITICAL_EXIT_NO_SCHED()不进行任务调度`

**如果要使用临界区代码保护，必须调用`CPU_SR_ALLOC();`**

## uCOS时间管理
### 任务延时
uCOSIII中的任务是一个无限循环并且还是一个抢占式内核，为了使高优先级的任务不至于独占CPU，可以给其他优先级较低的任务获取CPU使用权的机会，uCOSIII中除了空闲任务外的所有任务必须在合适的位置调用系统提供的**延时函数(任务调度函数)**，让当前的任务暂停运行一段时间并进行一个任务切换。
延时函数有两种:
+ `OSTimeDly()`
+ `OSTimeDlyHMSM()`

`OSTimeDly()`有三种工作模式：相对模式、周期模式和绝对模式
`OSTimeDlyHMSM()`只在相对模式下工作
在os_time.c中有详细定义

### 取消任务延时
延时任务可以通过在其他任务中调用函数`OSTimeDlyResume()`取消延时而进入就绪状态，此函数最后会引发任务调度。

### 获取系统时间
uCOSIII定义了一个`CPU_INT32U`类型的全局变量`OSTickCtr`来记录系统时钟节拍数，在调用`OSInit()`时被初始化为0,以后每发生一个时钟节拍，`OSTickCtr`加1。
`OSTimeSet()`允许用户改变当前时钟节拍计数器的值，要谨慎使用。
`OSTimeGet()`用来获取动迁时钟节拍计数器的值，可以用这个获取任务的运行时间。









