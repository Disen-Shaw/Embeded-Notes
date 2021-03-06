# uCOS的任务管理
## 参考原子的历程
原子的`delay.c`文件函数

| 函数                  | 描述                                         |
| --------------------- | -------------------------------------------- |
| delay_osschedlock()   | 任务调度器加锁，对uCOS中的对应函数做封装     |
| delay_osschedunlock() | 任务调度器解锁，对uCOS中的对应函数做封装     |
| delay_ostimedly()     | 延时，按节拍数延时，对uCOS中的对应函数做封装 |
| SysTick_Handler()     | 滴答定时器中断服务函数                       |
| delay_init()          | 滴答定时器/延时初始化                        |
| delay_us()            | 微秒延时，不会引发任务调度                   |
| Delay_ms()            | 毫秒延时，最小延时时间为uCOS系统心跳时间     |

就是要对SysTick定时器进行初始化配置来配合uCOS系统。  

### 滴答定时器
操作系统以及所有使用了时基的系统，都必须由硬件定时器来产生"滴答"中断来作为系统时基。   

| 地址       | 寄存器         | 描述             |
| ---------- | -------------- | ---------------- |
| 0xe000e010 | SysTick->CTRL  | 控制及状态寄存器 |
| 0xe000e014 | SysTick->LOAD  | 重装载寄存器     |
| 0xe000e018 | SysTick->VAL   | 当前数值寄存器   |
| 0xe000e01c | SysTick->CALIB | 校准数值寄存器   |

滴答定时器终端优先级为最低，在汇编文件os_cpu_a.asm中定义  
配置在os.cfg_app.h中定义的  

### usart.c和sys.c
使用uCOS和不使用uCOS下usart.c文件最大的不同哦奴就是串口1终端服务函数：USART1_IRQHandler()，sys.c文件则完全相同。  

服务函数如下：  

```c
void USART1_IRQHandler(void){
	#if SYSTEM_SUPPORT_OS	// 使用uCOS操作系统
		OSIntEnter();
	#endif
	
	// 中间处理函数，和不是用uCOS时相同
	#if SYSTEM_SUPPORT_OS
		OSIntExit();		// 退出中断
	#endif
}
```

### 新建中断服务函数
```c
void XXX_Handler(void){
	OSIntEnter();
	
	// 服务函数
	
	OSIntExit();
}
```

## 任务的基本概念
设计复杂、大型程序的时候，将这些负责的程序分割成多个简单的小程序，这些小程序就是单个任务，所有的小人物和谐的工作，最终完成复杂的功能。  
在操作系统中，这些小任务可以并发执行，从而提高CPU的使用效率  

uCOSIII是一个`可剥夺内核的多任务系统`，具备多人物处理能力  
在uCOSIII中任务就是`程序实体`，uCOSIII能够管理和调度这些小任务  
uCOSIII中的任务由三部分组成：`任务堆栈`、`任务控制块`和`任务函数`。  

### 任务堆栈
上下文切换的时候用来保存任务的工作环境，就是STM32的内部寄存器值。  

### 任务控制块
用来记录任务的各个属性  

### 任务函数
由用户编写的任务处理代码，要运行的任务的实体，一般格式如下：  
```c
void XXX_task(void *p_arg){
	while(1){
		// 任务主体
	}
}
```
任务函数通常是一个无限循环，也可以是一个只执行一次的任务。  
如果任务的参数是void类型，那么做的目地可以传递不同类型的数据甚至函数  
任务函数其实就是一个C语言的函数，但是在使用uCOSIII的情况下这个函数不能由用户自行调用，任务函数何时执行，何时停止完全由操作系统来控制。  

## uCOSIII的系统任务
>uCOSIII默认有5个系统任务 

### 空闲任务
uCOSIII创建的第一个任务，uCOSIII必须创建的任务，此任务由uCOSIII自动创建，此任务有uCOSIII自动创建，不需要手动创建

### 时钟节拍任务
必须创建的任务

### 统计的任务
可选任务，用来统计CPU使用率和各个任务的堆栈使用量。
此任务是可选任务，由OS_CFG_STAT_TASK_EN控制是否使用此任务

### 定时任务
用来想用户提供定时服务，也是可选任务，由宏OS_CFG_ISR_POST_DEFERRED_EN控制是否使用此任务

## uCOSIII任务的状态
从用户角度看，uCOSIII的任务一共有5种状态

| 任务状态   | 说明                                                                                                             |
| ---------- | ---------------------------------------------------------------------------------------------------------------- |
| 休眠态     | 占用了代码段，但是还未被使用                                                                  |
| 就绪态     | 系统为任务分配了任务控制块，并且任务已经在就绪表中等级</br>这个时候任务就具有了运行的条件                        |
| 运行态     | 任务获得CPU的使用权，正在运行                                                                                    |
| 等待态     | 正在运行的任务需要等待一段时间，或者等待某个事件，</br>哦这个任务就进入了等待态</br>此时系统就会把CPU使用权交给别的任务 |
| 中断服务态 | 当发送中断，`当前正在运行的任务会被挂起`，CPU转而去执行中断服务函数</br>此时任务的任务状态叫做中断服务态           |


### 任务状态转换
![[Pasted image 20210710141057.png]]

