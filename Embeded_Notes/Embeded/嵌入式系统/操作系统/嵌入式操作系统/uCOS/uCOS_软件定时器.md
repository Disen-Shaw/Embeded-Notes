# uCOS软件定时器
## 软件定时器简介
本质是递减计数器，当计数器减到零可以触发某种动作的执行，这个动作通过`回调函数`来实现。的那个定时器计时完成，定义的回调函数就会被立即调用，应用程序可以有任务数量的定时器，uCOSIII中定时器的时间**分辨率**由宏`OS_CFG_TMR_TASK_RATE_HZ`，单位为Hz，默认为100Hz  

**要避免在回调函数中使用阻塞函数调用或者可以阻塞或者删除定时器的任务**  

回调函数就是一个通过函数指针调用的函数，如果把函数的指针作为参数传递给另一个函数，当这个指针用来调用其所指向的函数，就说这个是回调函数  
回调函数不是由该函数的实现方法直接调用的，而是在特定的事件或者条件发生时由另外一方调用的，对该事件响应。  

### 软件定时器API函数

| 函数名           | 作用                     |
| ---------------- | ------------------------ |
| OSTmrCreate()    | 创建定时器并制定运行模式 |
| OSTmrDel()       | 删除定时器               |
| OSTmrRemainGet() | 获取定时器的剩余时间     |
| OSTmrStart()     | 启动定时器计数           |
| OSTmrStateget()  | 获取当前定时器状态       |
| OSTmrStop()      | 停止计数器倒计时         |

API定义位于os_tmr.c  

## 软件定时器工作模式
### 定时器的创建流程和退出流程
#### 创建定时器
由函数OSTmrCreate()创建
```c
OSTmrCreate(	OS_TMR					*p_tmr,
				OS_CHAR					*p_name,
				OS_TICK					dly,
				OS_CHAR					period,
				OS_OPT					opt,
				OS_TMR_CALLBACK_PTR		p_callback,
				void					*p_callback_arg,
				OS_ERR					*p_err)
```
使用之前需要定义一个定时器结构体，回调函数
```c
OS_TMR tmr1;	// 定义定时器结构体1
OS_TMR tmr2;	// 定义定时器结构体2

void tmr1_callback(void *p_tmr,void *p_arg); // 定时器1回调函数
void tmr2_callback(void *p_tmr,void *p_arg); // 定时器2回调函数

... ...
创建定时器
OSTmrCreate(	(OS_TMR  	*)&tmr1 ,				// 定时器1
				(CPU_CHAR	*)"rmr1",				// 定时器名字
				(OS_TICK	 )20,					// 20*10=200ms	第一个周期
				(OS_TICK	 )100,					// 100*10=1000ms 之后的延时
				(OS_OPT	 	 )OS_OPT_TMR_PERIODIC,	// 周期模式
				(OS_TMR_CALLBACK_PTR)tmr1_callback,	// 定时器1回调函数
				(void 		*)0,					// 参数为0
				(OS_ERR		*)&err);				// 返回的错误码


```

#### 启动定时器

启动定时器通过函数`OSTmrStart()`来完成。  
```c
CPU_BOOLEAN	OSTmrStart(	OS_TMR *p_tmr,
						OS_ERR *p_err
						);
```

#### 停止定时器

启动定时器通过函数`OSTmrStop()`来完成。  
```c
CPU_BOOLEAN	OSTmrStart(	OS_TMR *p_tmr,
						OS_OPT	opt,
						void *p_callback_arg,
						OS_ERR *p_err
						);
```

### 单次定时器模式
单次定时器从初始值(OSTmrCreate()函数中的擦书dly)开始倒计时，知道为0位置，单次定时器的定时器只执行一次。  
如果再要使用，则调用`OSTmrStart()`  
![[Pasted image 20210711171250.png]]

### 周期模式
#### 无初始延迟
创建定时器的时候可以设定为周期模式，当倒计时完成后，定时器调用回调函数，并重置计数器重新开始计时，一直循环下去。  
如果在调用函数`OSTmrCreate()`创建定时器时让参数`dly`为0，那么定时器每个周期就是`period`  
![[Pasted image 20210711171220.png]]

#### 有初始延迟
可以设定为带初始延迟时间的运行模式，使用函数`OSYmrCreate()`参数`dly`来确定第一个周期，以后的每个周期开始时将计数器的值重置为`period`  
![[Pasted image 20210711171715.png]]
