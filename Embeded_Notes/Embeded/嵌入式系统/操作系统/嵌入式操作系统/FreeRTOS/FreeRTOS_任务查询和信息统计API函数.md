# 任务查询和信息统计API函数
一些利于代码调试的API函数

## API函数

| 函数                           | 描述                                                     |
| ------------------------------ | -------------------------------------------------------- |
| uxTaskPriorityGet()            | 查询某个任务的优先级                                     |
| vTaskPrioritySet()             | 改变某个任务的优先级                                     |
| uxTaskGetSystemState()         | 获取系统中任务的状态                                     |
| vTaskGetInfo()                 | 获取某个任务的信息j                                      |
| xTaskGetApplicationTaskTag()   | 获取某个任务的标签(Tag)值。                              |
| xTaskGetCurrentTaskHandle()    | 获取当前正在运行的任务的任务句柄                         |
| xTaskGetHandle()               | 根据任务名字查找某个任务的句柄                           |
| xTaskGetIdleTaskHandle()       | 获取空闲任务的任务句柄                                   |
| uxTaskGetStackHighWaterMark()  | 获取任务的堆栈的历史剩余最小值，FreeRTOS中叫做“高水位线” |
| eTaskGetState()                | 获取某个任务的壮态，这个壮态是eTaskState类型。           |
| pcTaskGetName()                | 获取某个任务的任务名字。                                 |
| xTaskGetTickCount()            | 获取系统时间计数器值。                                   |
| xTaskGetTickCountFromISR()     | 在中断服务函数中获取时间计数器值                         |
| xTaskGetSchedulerState()       | 获取任务调度器的壮态，开启或未开启。                     |
| uxTaskGetNumberOfTasks()       | 获取当前系统中存在的任务数量                             |
| vTaskList()                    | 以一种表格的形式输出当前系统中所有任务的详细信息         |
| vTaskGetRunTimeStats()         | 获取每个任务的运行时间                                   |
| vTaskSetApplicationTaskTag()   | 设置任务标签(Tag)值。                                    |
| SetThreadLocalStoragePointer() | 设置线程本地存储指针                                     |
| GetThreadLocalStoragePointer() | 获取线程本地存储指针                                     |

## 解读
### uxTaskPriorityGet()
此函数用来获取指定任务的优先级，要使用此函数的话宏`INCLUDE_uxTaskPriorityGet`应该定义为1
```c
UBaseType_t uxTaskPriorityGet( TaskHandle_t xTask )
```
参数：
+ xTask：要查找的任务的任务句柄。

返回值：
+ 获取到的对应的任务的优先级，int

### vTaskPrioritySet()
此函数用于改变某一个任务的任务优先级，要使用此函数的话宏`INCLUDE_vTaskPrioritySet`应该定义为1
```c
void vTaskPrioritySet( TaskHandle_t xTask, UBaseType_t uxNewPriority )
```
参数：
+ xTask：要查找的任务的任务句柄
+ uxNewPriority:任务要使用的新的优先级，可以是`0~configMAX_PRIORITIES–1`

### uxTaskGetSystemState()
用于获取系统中所有任务的任务壮态，每个任务的壮态信息保存在一个`TaskStatus_t`类型的结构体里面，这个结构体里面包含了任务的任务句柄、任务名字、堆栈、优先级等信息
要使用此函数的话宏`configUSE_TRACE_FACILITY`应该定义为1
```c
UBaseType_t uxTaskGetSystemState( 	TaskStatus_t * const pxTaskStatusArray,
									const UBaseType_t uxArraySize,
									uint32_t * const pulTotalRunTime )
```
参数：
+ pxTaskStatusArray：指向`TaskStatus_t`结构体类型的数组首地址，每个任务至少需要一个`TaskStatus_t`结构体，任务的数量可以使用函数`uxTaskGetNumberOfTasks()`
+ uxArraySize:保存任务壮态数组的数组的大小。
+ pulTotalRunTime:如果`configGENERATE_RUN_TIME_STATS`为1的话此参数用来保存系统总的运行时间。

```c
typedef struct xTASK_STATUS{
	TaskHandle_t xHandle;						//任务句柄
	const char *pcTaskName;						//任务名字
	UBaseType_t xTaskNumber;					//任务编号
	eTaskState eCurrentState;					//当前任务壮态，eTaskState是一个枚举类型UBaseType_t 
	uxCurrentPriority;							//任务当前的优先级
	UBaseType_t uxBasePriority;					//任务基础优先级
	uint32_t ulRunTimeCounter;					//任务运行的总时间
	StackType_t *pxStackBase;					//堆栈基地址
}
```

返回值：
统计到的任务壮态的个数，也就是填写到数组pxTaskStatusArray中的个数，此值应该等于函数uxTaskGetNumberOfTasks()的返回值。如果参数uxArraySize太小的话返回值可能为0。

### vTaskGetInfo()
此函数也是用来获取任务壮态的，但是是获取指定的单个任务的壮态的，任务的壮态信息填充到参数pxTaskStatus中，这个参数也是`TaskStatus_t`类型的，要使用此函数的话宏`configUSE_TRACE_FACILITY`要定义为1
```c
void vTaskGetInfo( 		TaskHandle_t xTask,
						TaskStatus_t *pxTaskStatus,
						BaseType_t xGetFreeStackSpace,
						eTaskState eState )
```
参数：
+ xTask：要查找的任务的任务句柄
+ pxTaskStatus:指向类型为TaskStatus_t的结构体变量。
+ xGetFreeStackSpace:在结构体TaskStatus_t中有个字段usStackHighWaterMark来保存自任务运行以来任务堆栈剩余的历史最小大小，这个值越小说明越接近堆栈溢出，但是计算这个值需要花费一点时间，所以我们可以通过将xGetFreeStackSpace设置为pdFALSE来跳过这个步骤，当设置为pdTRUE的时候就会检查堆栈的历史剩余最小值。
+ eState:结构体TaskStatus_t中有个字段eCurrentState用来保存任务运行壮态，这个字段是eTaskState类型的，这是个枚举类型
```c
typedef enum{
	eRunning = 0,			//运行壮态
	eReady,					//就绪态
	eBlocked,				//阻塞态
	eSuspended,				//挂起态
	eDeleted,				//任务被删除
	eInvalid				//无效
}eTaskState;
```
获取任务运行壮态会耗费不少时间，所以为了加快函数vTaskGetInfo()的执行速度结构体TaskStatus_t中的字段eCurrentState就可以由用户直接赋值，参数eState就是要赋的值。如果不在乎这点时间，那么可以将eState设置为eInvalid，这样任务的壮态信息就由函数vTaskGetInfo()去想办法获取。

返回值：
无

### xTaskGetApplicationTaskTag()
用于获取任务的Tag(标签)值，任务控制块中有个成员变量pxTaskTag来保存任务的标签值标签的功能由用户自行决定，此函数就是用来获取这个标签值的，FreeRTOS系统内核是不会使用到这个标签的。
要使用此函数的话宏`configUSE_APPLICATION_TASK_TAG`必须为1
```c
TaskHookFunction_t xTaskGetApplicationTaskTag( TaskHandle_t xTask );
```

参数：
+ xTask：要获取标签值的任务对应的任务句柄，如果为NULL的话就获取当前正在运行的任务标签值。

返回值：
任务的标签值

### xTaskGetCurrentTaskHandle()
用于获取当前任务的任务句柄，其实获取到的就是任务控制块，在前面讲解任务创建函数的时候说过任务句柄就是任务控制。
如果要使用此函数的话宏`INCLUDE_xTaskGetCurrentTaskHandle`应该为1。
```c
TaskHandle_t xTaskGetHandle( const char *pcNameToQuery）
```
参数：
+ pcNameToQuery：任务名，C语言字符串。

返回值：
+ NULL：没有任务名pcNameToQuery所对应的任务
+ 其他值：任务名pcNameToQuery所对应的任务句柄

### xTaskGetIdleTaskHandle()
此函数用于返回空闲任务的任务句柄。
要使用此函数的话宏`INCLUDE_xTaskGetIdleTaskHandle`必须为1
```c
TaskHandle_t xTaskGetIdleTaskHandle( void )
```
参数：
无
返回值：
空闲任务的任务句柄

### uxTaskGetStackHighWaterMark()
每个任务都有自己的堆栈，堆栈的总大小在创建任务的时候就确定了，此函数用于检查任务从创建好到现在的历史剩余最小值，**这个值越小说明任务堆栈溢出的可能性就越大**
FreeRTOS把这个历史剩余最小值叫做“高水位线”。此函数相对来说会多耗费一点时间，所以在代码调试阶段可以使用，产品发布的时候最好不要使用。
要使用此函数的话宏`INCLUDE_uxTaskGetStackHighWaterMark`必须为1
```c
UBaseType_t uxTaskGetStackHighWaterMark( TaskHandle_t xTask )
```
参数：
+ xTask：要查询的任务的任务句柄，当这个参数为NULL的话说明查询自身任务(即调用函数uxTaskGetStackHighWaterMark()的任务)的“高水位线”。

返回值：
+ 任务堆栈的“高水位线”值，也就是堆栈的历史剩余最小值。

### eTaskGetState()
此函数用于查询某个任务的运行壮态
运行态、阻塞态、挂起态、就绪态等，返回值是个枚举类型
要使用此函数的话宏INCLUDE_eTaskGetState必须为1
```c
eTaskState eTaskGetState( TaskHandle_t xTask )
```
参数：
+ xTask：要查询的任务的任务句柄。
+ 返回值：返回值为eTaskState类型，这是个枚举类型，在文件task.h中有定义

### pcTaskGetName()
根据某个任务的任务句柄来查询这个任务对应的任务名
```c
char *pcTaskGetName( TaskHandle_t xTaskToQuery )
```
参数：
+ xTaskToQuery：要查询的任务的任务句柄，此参数为NULL的话表示查询自身任务(调用函数pcTaskGetName())的任务名字

返回值：
返回任务所对应的任务名

### xTaskGetTickCount()
此函数用于查询任务调度器从启动到现在时间计数器xTickCount的值。xTickCount是系统的时钟节拍值，并不是真实的时间值。每个滴答定时器中断xTickCount就会加1
一秒钟滴答定时器中断多少次取决于宏`configTICK_RATE_HZ`
理论上xTickCount存在溢出的问题，但是这个溢出对于FreeRTOS的内核没有影响，但是如果用户的应用程序有使用到的话就要考虑溢出

什么时候溢出取决于宏`configUSE_16_BIT_TICKS`，当此宏为1的时候xTixkCount就是个16位的变量，当为0的时候就是个32位的变量

```c
TickType_t xTaskGetTickCount( void )
```
参数：
无
返回值：
时间计数器xTickCount的值。

### xTaskGetTickCountFromISR()
xTaskGetTickCount()的中断级版本，用于在中断服务函数中获取时间计数器xTickCount的值
```c
TickType_t xTaskGetTickCountFromISR( void )
```
参数：
无

### xTaskGetSchedulerState()
用于获取FreeRTOS的任务调度器运行情况：运行、关闭、还是挂起
要使用此函数的话宏`INCLUDE_xTaskGetSchedulerState`必须为1
```c
BaseType_t xTaskGetSchedulerState( void )
```
参数：
无
返回值：
+ taskSCHEDULER_NOT_STARTED：调度器未启动
	调度器的启动是通过函数`vTaskStartScheduler()`来完成，所以在函数`vTaskStartScheduler()`未调用之前调用函数`xTaskGetSchedulerState()`的话就会返回此值。
+ taskSCHEDULER_RUNNING：调度器正在运行
+ taskSCHEDULER_SUSPENDED：调度器挂起。

### uxTaskGetNumberOfTasks()
此函数用于查询系统当前存在的任务数量
```c
UBaseType_t uxTaskGetNumberOfTasks( void )
```
参数：无
返回值：
当前系统中存在的任务数量，此值=挂起态的任务+阻塞态的任务+就绪态的任务+空闲任务+运行态的任务。

### vTaskList()
此函数会创建一个表格来描述每个任务的详细信息
表中的信息如下：
Name：创建任务的时候给任务分配的名字。
State：任务的壮态信息，B是阻塞态，R是就绪态，S是挂起态，D是删除态。
Priority：任务优先级。
Stack：任务堆栈的“高水位线”，就是堆栈历史最小剩余大小
Num：任务编号，这个编号是唯一的，当多个任务使用同一个任务名的时候可以通过此编号来做区分。
```c
void vTaskList( char * pcWriteBuffer )
```
参数：
+ pcWriteBuffer：保存任务壮态信息表的存储区。

返回值：
无

### vTaskGetRunTimeStats()
FreeRTOS可以通过相关的配置来统计任务的运行时间信息，任务的运行时间信息提供了每个任务获取到CPU使用权总的时间。函数vTaskGetRunTimeStats()会将统计到的信息填充到一个表里面，表里面提供了每个任务的运行时间和其所占总时间的百分比
![[Pasted image 20210714215657.png]]
函数`vTaskGetRunTimeStats()`是一个很实用的函数，要使用此函数的话宏`configGENERATE_RUN_TIME_STATS`和`configUSE_STATS_FORMATTING_FUNCTIONS`必须都为1。
如果宏`configGENERATE_RUN_TIME_STATS`为1的话还需要实现一下几个宏定义
`portCONFIGURE_TIMER_FOR_RUN_TIME_STATS()`:此宏用来初始化一个外设来提供时间统计功能所需的时基，一般是定时器/计数器。这个时基的分辨率一定要比FreeRTOS的系统时钟高，一般这个时基的时钟精度比系统时钟的高10~20倍就可以了

`portGET_RUN_TIME_COUNTER_VALUE()`或者`portALT_GET_RUN_TIME_COUNTER_VALUE(Time)`，这两个宏实现其中一个就行了，这两个宏用于提供当前的时基的时间值。

```c
void vTaskGetRunTimeStats( char *pcWriteBuffer )
```

参数：
+ pcWriteBuffer：保存任务时间信息的存储区。存储区要足够大来保存任务时间信息

返回值：
无

### vTaskSetApplicationTaskTag()
用于设置某个任务的标签值，这个标签值的具体函数和用法由用户自行决定，FreeRTOS内核不会使用这个标签值
如果要使用此函数的话宏configUSE_APPLICATION_TASK_TAG必须为1
```c
void vTaskSetApplicationTaskTag(TaskHandle_t xTask, TaskHookFunction_t pxHookFunction )
```

参数：
+ xTask：要设置标签值的任务，此值为NULL的话表示设置自身任务的标签值。
+ pxHookFunction：要设置的标签值，这是一个TaskHookFunction_t类型的函数指针，但是也可以设置为其他值。

返回值：
无

### SetThreadLocalStoragePointer()
此函数用于设置线程本地存储指针的值，每个任务都有它自己的指针数组来作为线程本地存储，使用这些线程本地存储可以用来在任务控制块中存储一些应用信息，这些信息只属于任务自己的 。
线程本地存储指针数组的大小由宏configNUM_THREAD_LOCAL_STORAGE_POINTERS来决定的。
如果要使用此函数的话宏configNUM_THREAD_LOCAL_STORAGE_POINTERS不能为0，宏的具体值是本地存储指针数组的大小
```c
void vTaskSetThreadLocalStoragePointer(TaskHandle_t xTaskToSet, BaseType_t xIndex, void *pvValue )
```

参数：
+ xTaskToSet：要设置线程本地存储指针的任务的任务句柄，如果是NULL的话表示设置任务自身的线程本地存储指针。
+ xIndex：要设置的线程本地存储指针数组的索引。
+ pvValue:要存储的值。

返回值：
无

### GetThreadLocalStoragePointer()
此函数用于获取线程本地存储指针的值，如果要使用此函数的话宏`configNUM_THREAD_LOCAL_STORAGE_POINTERS`不能为0
```c
void *pvTaskGetThreadLocalStoragePointer( TaskHandle_t xTaskToQuery, BaseType_txIndex )
```
参数：
+ xTaskToSet：要获取的线程本地存储指针的任务句柄，如果是NULL的话表示获取任务自身的线程本地存储指针。
+ xIndex：要获取的线程本地存储指针数组的索引

返回值：
获取到的线程本地存储指针的值