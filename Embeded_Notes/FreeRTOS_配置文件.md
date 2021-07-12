# FreeRTOS配置文件
可以根据项目的需求配置该改制文件
## "INCLUDE_"开始的宏
使用`INCLUDE_`开头的宏用来表示使能或者失能FreeRTOS中相应的API函数，作用就是用来配置FreeRTOS中的可选API函数。
例如：
```c
INCLUDE_vTaskPrioritySet
```
表示使能函数`vTaskPriority()`函数

### NCLUDE_xSemaphoreGetMutexHolder
如果要使用函数xQueueGetMutexHolder()的话</br>宏INCLUDE_xSemaphoreGetMutexHolder必须定义为1

### INCLUDE_xTaskAbortDelay
如果要使用函数xTaskAbortDelay()的话</br>将宏INCLUDE_xTaskAbortDelay定义为1。

### INCLUDE_vTaskDelay
如果要使用函数vTaskDelay()的话</br>需要将宏INCLUDE_vTaskDelay定义为1
### INCLUDE_vTaskDelayUntil
如果要使用函数vTaskDelayUntil()的话</br>需要将宏INCLUDE_vTaskDelayUntil定义为1。
### INCLUDE_vTaskDelete
如果要使用函数vTaskDelete()的话</br>需要将宏INCLUDE_vTaskDelete定义为1。
### INCLUDE_xTaskGetCurrentTaskHandle
如果要使用函数xTaskGetCurentTaskHandle()的话</br>需要将宏INCLUDE_xTaskGetCurrentTaskHandle定义为1
### INCLUDE_xTaskGetHandle
如果要使用函数xTaskGetHandle()的话</br>需要将宏INCLUDE_xTaskGetHandle定义为1。
### INCLUDE_xTaskGetSchedulerState
如果要使用函数xTaskGetSchedulerState()的话</br>需要将宏INCLUDE_xTaskGetSchedulerState定义为1。
### INCLUDE_uxTaskGetStackHighWaterMark
如果要使用函数uxTaskGetStackHighWaterMark()的话</br>需要将宏INCLUDE_uxTaskGetStackHighWaterMark定义为1。
### INCLUDE_uxTaskPriorityGet
如果要使用函数uxTaskPriorityGet()的话</br>需要将宏INCLUDE_uxTaskPriorityGet定义为1。
### INCLUDE_vTaskPrioritySet
如果要使用函数vTaskPrioritySet()的话</br>需要将宏INCLUDE_vTaskPrioritySet定义为1
### INCLUDE_xTaskResumeFromISR
如果要使用函数xTaskResumeFromISR()的话</br>需要将宏INCLUDE_xTaskResumeFromISR和INCLUDE_vTaskSuspend都定义为1。
### INCLUDE_eTaskGetState
如果要使用函数eTaskGetState()的话</br>需要将宏INCLUDE_eTaskGetState定义为1。
### INCLUDE_vTaskSuspend
如果要使用函数vTaskSuspend()</br>vTaskResume()prvTaskIsTaskSuspended()</br>xTaskResumeFromISR()的话</br>宏INCLUDE_vTaskSuspend要定义为1。
### INCLUDE_xTaskResumeFromISR
如 果 要 使 用 函 数xTaskResumeFromISR()的话宏INCLUDE_xTaskResumeFromISR和INCLUDE_vTaskSuspend都必须定义为1。
### INCLUDE_xTimerPendFunctionCall
如果要使用函数xTimerPendFunctionCall()</br>和xTimerPendFunctionCallFromISR()</br>宏INCLUDE_xTimerPendFunctionCall和configUSE_TIMERS都必须定义为1。

## "config"开始的宏
和用`INCLUDE_`开始的红一样，都是用来完成FreeRTOS的配置和裁剪的
### configAPPLICATION_ALLOCATED_HEAP
默认情况下FreeRTOS的堆内存由编译器来分配的，将宏定义为1的话，堆内存可以由用户配置，堆内存在heap.c中有定义

### configASSERT
断言，类似于C标准库中的`assert()`函数，调试代码的时候可以检查传入的参数是否合理，FreeRTOS内核的关键点都要用到`configASSERT(x)`，当x为0的时候说明有错误发生，使用断言会导致额外开销，一般在调试阶段使用。

cnfigASSERT()需要在FreeRTOSConfig.h文件中定义，例如
```c
	#define cinfigASSERT((x)) if((x)==0)vAssertCalld(__FILE__,LINE__);
	// 当参数x错误的时候就通过串口打印出发生错误的文件名和错误所在的行号
```

configCHECK_FOR_STACK_OVERFLOW
+ 设置堆栈溢出检测，每个任务都有一个任务堆栈，</br>如果使用函数xTaskCreate()创建一个任务的话那么这个任务的堆栈是自动从FreeRTOS的堆(ucHeap)中分配的，堆栈的大小是由函数xTaskCreate()的参数usStackDepth来决定的。</br>如果使用函数xTaskCreateStatic()创建任务的话任务堆栈是由用户设置的，参数pxStackBuffer为任务堆栈，一般是一个数组。
+ 堆栈溢出是导致应用程序不稳定的主要因素，FreeRTOS提供了两种可选的机制来帮助检测和调试堆栈溢出，不管使用哪种机制都要设置宏`configCHECK_FOR_STACK_OVERFLOW`。
+ 如果使能了堆栈检测功能的话，即宏configCHECK_FOR_STACK_OVERFLOW不为0</br>那么用户必须提供一个钩子函数(回调函数)，当内核检测到堆栈溢出以后就会调用这个钩子函数，
```c
// 钩子函数原型
void vApplicationStackOverflowHook( TaskHandle_t 	xTask
									char 			*pcTaskName);
```
+ 参数xTask是任务句柄，pcTaskName是任务名字4
+ 堆栈溢出太严重的话可能会损毁这两个参数，如果发生这种情况的话可以直接查看变量pxCurrentTCB来确定哪个任务发生了堆栈溢出
+ 有些处理器可能在堆栈溢出的时候生成一个fault中断来提示这种错误
+ 堆栈溢出检测会增加上下文切换的开销，应该在调试的时候使用

#### configCHECK_FOR_STACK_OVERFLOW\=\=1
使用堆栈溢出检测方法1。
上下文切换的时候需要保存现场，现场是保存在堆栈中的，这个时候任务堆栈使用率很可能达到最大值，方法一就是不断的检测任务堆栈指针是否指向有效空间，如果指向了无效空间的话就会调用钩子函数。
方法一的优点就是快，但是缺点就是不能检测所有的堆栈溢出

#### configCHECK_FOR_STACK_OVERFLOW\=\=2
使用堆栈溢出检测方法2
在创建任务的时候会向任务堆栈填充一个已知的标记值，方法二会一直检测堆栈后面的几个bytes(标记值)是否被改写，如果被改写的话就会调用堆栈溢出钩子函数，方法二也会使用方法一中的机制
方法二比方法一要慢一些，但是对用户而言还是很快的！方法二能检测到几乎所有的堆栈溢出，但是也有一些情况检测不到，比如溢出值和标记值相同的时候。

### configCPU_CLOCK_HZ
设置CPU的频率

### configSUPPORT_DYNAMIC_ALLOCATION
定义为1的话在创建FreeRTOS的内核对象的时候所需要的RAM就会从FreeRTOS的堆中动态的获取内存，如果定义为0的话所需的RAM就需要用户自行提供
默认情况下该宏设置为1

### configENABLE_BACKWARD_COMPATIBILITY
reeRTOS.h中由一些列的#define宏定义，这些宏定义都是一些数据类型名字之前的FreeRTOS中会使用到这些数据类型，这些宏保证了代码从V8.0.0之前的版本升级到最新版本的时候不需要做出修改，默认情况下宏`configENABLE_BACKWARD_COMPATIBILITY`为1

### configGENERATE_RUN_TIME_STATS
设置为1开启时间统计功能，相应的API函数会被编译
为0时关闭时间统计功能。
如果宏`configGENERATE_RUN_TIME_STATS`为1的话还需要定义表中的宏。

| 宏                                                                            | 描述                                             |
| ----------------------------------------------------------------------------- | ------------------------------------------------ |
| portCONFIGURE_TIMER_FOR_RUN_TIME_STATS()                                      | 此宏用来初始化一个外设来作为时间统计的基准时钟。 |
| portGET_RUN_TIME_COUNTER_VALUE()</br>portALT_GET_RUN_TIME_COUNTER_VALUE(Time) | 此宏用来返回当前基准时钟的时钟值。               |

### configIDLE_SHOULD_YIELD
此宏定义了与空闲任务(idle Task)处于同等优先级的其他用户任务的行为
当为0的时候空闲任务不会为其他处于同优先级的任务让出CPU使用权。
当为1的时候空闲任务就会为处于同等优先级的用户任务让出CPU使用权
除非没有就绪的用户任务，这样花费在空闲任务上的时间就会很少，但是这种方法也带了副作用。
**一般关闭此功能**

### configKERNEL_INTERRUPT_PRIORITY</br>configMAX_SYSCALL_INTERRUPT_PRIORITY</br>configMAX_API_CALL_INTERRUPT_PRIORITY
这三个宏和FreeRTOS的中断配置有关

### configMAX_CO_ROUTINE_PRIORITIES
设置可以分配给协程的最大优先级，也就是协程的优先级数。
设置号以后协程的优先级可以从0到`configMAX_CO_ROUTINE_PRIORITIES-1`
其中0是最低的优先级，`configMAX_CO_ROUTINE_PRIORITIES-1`为最高的优先级。

### configMAX_PRIORITIES
设置任务的优先级数量，设置好以后任务就可以使用从0到`configMAX_PRIORITIES-1`的优先级，其中0是最低优先级，`configMAX_PRIORITIES-1`是最高优先级。
这里要注意和UCOS的区别，UCOS中0是最高优先级

### configMAX_TASK_NAME_LEN
设置任务名最大长度

### configMINIMAL_STACK_SIZE
设置空闲任务的最小任务堆栈大小，以字为单位，不是字节。
比如在STM32上设置为100的话，那么真正的堆栈大小就是100*4=400字节。

### configNUM_THREAD_LOCAL_STORAGE_POINTERS
设置每个任务的本地存储指针数组大小，任务控制块中有本地存储数组指针，用户应用程序可以在这些本地存储中存入一些数据

### configQUEUE_REGISTRY_SIZE
设置可以注册的队列和信号量的最大数量
在使用内核调试器查看信号量和队列的时候需要设置此宏，而且要先将消息队列和信号量进行注册，只有注册了的队列和信号量才会再内核调试器中看到
如果不使用内核调试器的话此宏设置为0即可

### configSUPPORT_STATIC_ALLOCATION
当此宏定义为1，在创建一些内核对象的时候需要用户指定RAM
当为0的时候就会自使用heap.c中的动态内存管理函数来自动的申请RAM

### configTICK_RATE_HZ
设置FreeRTOS的系统时钟节拍频率，单位为HZ，此频率就是滴答定时器的中断频率，需要使用此宏来配置滴答定时器的中断。

### configTIMER_QUEUE_LENGTH
配置FreeRTOS软件定时器的，FreeRTOS的软件定时器API函数会通过命令队列向软件定时器任务发送消息，此宏用来设置这个软件定时器的命令队列长度。

### configTIMER_TASK_PRIORITY
设置软件定时器任务的任务优先级

### configTIMER_TASK_STACK_DEPTH
设置定时器服务任务的任务堆栈大小。

### configTOTAL_HEAP_SIZE
设置堆大小，如果使用了动态内存管理的话，FreeRTOS在创建任务、信号量、队列等的时候就会使用heap_x.c(x为1~5)中的内存申请函数来申请内存。
这些内存就是从堆ucHeap\[configTOTAL_HEAP_SIZE]中申请的，堆的大小由`configTOTAL_HEAP_SIZE`来定义。

### configUSE_16_BIT_TICKS
系统节拍计数器变量数据类型，系统节拍计数器变量类型为`TickType_t`
当`configUSE_16_BIT_TICKS`为1的时候TickType_t就是16位的
当`configUSE_16_BIT_TICKS`为0的话TickType_t就是32位的。

### configUSE_APPLICATION_TASK_TAG
此宏设置为1的话函数`configUSE_APPLICATION_TASK_TAGF()`和`xTaskCallApplicationTaskHook()`就会被编译。

### configUSE_CO_ROUTINES
设置为1的时候启用协程，协程可以节省开销，但是功能有限，现在的MCU性能已经非常强大了，因此建议关闭协程。

### configUSE_COUNTING_SEMAPHORES
设置为1的时候启用计数型信号量，相关的API函数会被编译

### configUSE_DAEMON_TASK_STARTUP_HOOK
当宏`configUSE_TIMERS`和`configUSE_DAEMON_TASK_STARTUP_HOOK`都为1的时需要定义函数`vApplicationDaemonTaskStartupHook()`，函数原型如下：
```c
void vApplicationDaemonTaskStartupHook( oid)
```

### configUSE_IDLE_HOOK
为1时使用空闲任务钩子函数，用户需要实现空闲任务钩子函数，函数原型如下
```c
void vApplicationIdleHook(void)
```

### configUSE_MALLOC_FAILED_HOOK
为1时使用内存分配失败钩子函数，用户需要实现内存分配失败钩子函数,函数原型如下：
```c
void vApplicationMallocFailedHook(void)
```

### configUSE_MUTEXES
为1时使用互斥信号量，相关的API函数会被编译。

### configUSE_PORT_OPTIMISED_TASK_SELECTION
FreeRTOS有两种方法来选择下一个要运行的任务，一个是通用的方法，另外一个是特殊的方法，也就是硬件方法，使用MCU自带的硬件指令来实现。
#### 通用方法
+ 当宏`configUSE_PORT_OPTIMISED_TASK_SELECTION`为0，或者硬件不支持的时候。
+ 希望所有硬件通用的时候
+ 全部用C语言来实现，但是效率比特殊方法低
+ 不限制最大优先级数目的时候。

#### 特殊办法
+ 不是所有硬件都支持
+ 当宏`configUSE_PORT_OPTIMISED_TASK_SELECTION`为1的时候
+ 硬件拥有特殊的指令，比如计算前导零(CLZ)指令。
+ 比通用方法效率高
+ 会限制优先级数目，一般是32个。

STM32有计算前导零的指令，所以我们可以使用特殊方法，即将宏`configUSE_PORT_OPTIMISED_TASK_SELECTION`定义为1。
计算前导零的指令在UCOSIII也用到了，也是用来查找下一个要运行的任务的。

### configUSE_PREEMPTION
为1时使用抢占式调度器，为0时使用协程。如果使用抢占式调度器的话内核会在每个时钟节拍中断中进行任务切换，当使用协程的话会在如下地方进行任务切换：
+ 一个任务调用了函数taskYIELD()。
+ 一个任务调用了可以使任务进入阻塞态的API函数
+ 应用程序明确定义了在中断中执行上下文切换。

### configUSE_QUEUE_SETS
为1时启用队列集功能。

### configUSE_RECURSIVE_MUTEXES
为1时使用递归互斥信号量，相关的API函数会被编译

### configUSE_STATS_FORMATTING_FUNCTIONS
宏`configUSE_TRACE_FACILITY`和`configUSE_STATS_FORMATTING_FUNCTIONS`都为1的时候函数`vTaskList()`和`vTaskGetRunTimeStats()`会被编译。
### configUSE_TASK_NOTIFICATIONS
为1的时候使用任务通知功能，相关的API函数会被编译，**开启了此功能的话每个任务会多消耗8个字节。**

### configUSE_TICK_HOOK
为1时使能时间片钩子函数，用户需要实现时间片钩子函数，函数的原型如下：
```c
void vApplicationTickHook(void)
```

### configUSE_TICKLESS_IDLE
为1时使能低功耗tickless模式。

### configUSE_TIMERS
为1时使用软件定时器，相关的API函数会被编译，当宏`configUSE_TIMERS`为1的话，那么宏`configTIMER_TASK_PRIORITY`、`configTIMER_QUEUE_LENGTH`和`configTIMER_TASK_STACK_DEPTH`必须定义。

### configUSE_TIME_SLICING
默认情况下，FreeRTOS使用抢占式调度器，这意味着调度器永远都在执行已经就绪了的最高优先级任务，优先级相同的任务在时钟节拍中断中进行切换
当宏`configUSE_TIME_SLICING`为0的时候不会在时钟节拍中断中执行相同优先级任务的任务切换
默认情况下宏configUSE_TIME_SLICING为1。

### configUSE_TRACE_FACILITY
为1启用可视化跟踪调试，会增加一些结构体成员和API函数。

