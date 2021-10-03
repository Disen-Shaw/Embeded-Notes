# uCOS任务调度
## 可剥夺型任务调度
任务调度就是终止当前正在运行的任务而转去执行其他的任务
uCOSIII是可剥夺的内核，当一个高优先级的任务准备就绪，并且此时发生了任务调度，那么这个高优先级的任务就会获得CPU的使用权
uCOSIII的任务调度是有任务调度器完成的，任务调度器有2种：`任务级中断调度器`和`中断级调度器`。
任务级调度器为函数`OSSched()`
中断级调度器为函数`OSIntExit()`，**当退出外部中断服务函数的时候使用中断级任务调度。**


### 任务调度点
1. 释放信号量或者发送消息，也通过配置相应的参数不发生任务调度。
2. **使用延时函数`OSTimeDly()`或者`OSTimeDlyHMSM()`**
	1. `OSTimeDly()`按照时间延时
	2. `OSTimeDlyHMSM()`按照节拍数延时
3. 任务等待的事情还没有发生(等待信号量、消息队列等)
4. 任务取消等待
5. **创建任务**
6. **删除任务**
7. 删除一个内核对象
8. 任务改变自身的优先级或者其他任务的优先级
9. **任务通过调用`OSTaskSuspend()`将自身挂起**
10. **任务解挂某个挂起的任务**
11. 退出所有的嵌套中断
12. 通过OSSchedUnlock()给调度器解锁
13. 任务调用OSSchedRoundRobinYield()放弃执行时间片
14. **用户调用`OSSched()`**


### 调度器的上锁和解锁
有时候希望代码执行过程中是**不可打断的**，这时可以使用函数`OSSchedLock()`对调度器加锁，当想要恢复的时候就可以使用函数`OSSchedUnlock()`给已经上锁的任务调度器解锁。

### 时间片轮转调度
uCOSIII允许一个优先级下有多个任务，每个任务可以执行指定的时间(时间片)，然后轮转到下一个任务，这个过程就是时间片轮转调度，当一任务不想在运行的时候，就可以放弃其时间片。
时间片轮转调度器为：`OS_SchedRoundRobin()`

**示例：**

| 任务  | 时间片数 |
| ----- | -------- |
| Task1 | 4        |
| Task2 | 4        |
| Task3 | 2        |

![Pasted image 20210710171456](../../../../../pictures/Pasted%20image%2020210710171456.png)
任务切换时间基本可以忽略不计


## 任务切换
当uCOSIII需要切换到另一个任务时，他将保存当前任务的现场到当前任务的堆栈中，主要是CPU寄存器的值，然后回复带新的现场并执行新的任务，这个过程就是任务切换
任务切换分为两种：`任务级切换`和`中断级切换`
任务级切换函数为：OXCtxSw()
任务级切换函数为：OXintCtxSw()

**任务调度的内部包含任务切换**

## uCOSIII系统初始化
在使用uCOSIII子前必须先初始化uCOSIII，函数`OSInit()`用来完成uCOSIII的初始化，而且OSInit()**必须先于其他uCOSIII函数调用**，包括`OSStart()`
一般主函数如下:
```c
int main(void){
	OS_ERR err;
	......
	// 其他函数，一般为外设初始化函数
	......
	OSInit(&err);
	......
	// 其他函数，一般为任务创建任务函数
	......
	OSStart(&err);
}
```

## 系统启动
使用函数`OSStart()`来启动uCOSIII，函数如下
```c
void OSStart(OS_ERR *p_err){
	if(OSRunning == OS_STATE_OS_STOPPED){
		OSPrioHighRdy 	= 	OS_PrioGetHighest();
		OSPRrioCur    	=	OSPrioHighRdy;
		OSTCBHihghRdyPtr=	OSRdyList[OSPrioHighRdy].HeadPtr;
		OSTCBCurPtr		= 	OSTCBHighRdyPtr;
		OSRunning		= 	OS_STATE_OS_RUNNING;
		OSStartHighRdy();
		*p_err			= 	OS_ERR_FATAL_RETURN;
	}else{
		*p_err			=	OS_ERR_OS_RUNNING;
	}
}	
```


