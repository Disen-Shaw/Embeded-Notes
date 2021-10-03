---
date updated: '2021-10-03T09:08:36+08:00'

---

# FreeRTOS事件标志组

信号量同步只能与单个的时间或者任务进行同步，有时候某个任务可能需要与多个事件或者任务进行同步，此时信号量不可以满足要求了。\
FreeRTOS为此提供了一个可选的解决方法，那就是时间标志组。

## 简介

### 事件位(事件标志)

事件位用来表明某个事件是否发生，事件位通常用作事件标志\
例如

- 当收到一条消息并且把这条消息处理掉以后就可以将某个位(标志)置 1，当队列中没有消息需要处理的时候就可以将这个位(标志)置 0。
- 当把队列中的消息通过网络发送输出以后就可以将某个位(标志)置 1，当没有数据需要从网络发送出去的话就将这个位(标志)置 0
- 需要向网络中发送一个心跳信息，将某个位(标志)置 1。现在不需要向网络中发送心跳信息，这个位(标志)置 0

### 事件组

一个事件组就是一组的事件位，事件组中的事件位通过位编号来访问\
上面列出的三个例子：

- 事件标志组的 bit0 表示队列中的消息是否处理掉
- 事件标志组的 bit1 表示是否有消息需要从网络中发送出去
- 事件标志组的 bit2 表示现在是否需要向网络发送心跳信息

### 事件标志组和事件位的数据类型

事件标志组的数据类型为 `EventGroupHandle_t` ，当 `configUSE_16_BIT_TICKS` 为 1 的时候 事件标志组可以存储 8 个事件位，当 `configUSE_16_BIT_TICKS` 为 0 的时候事件标志组存储 24 个事件位。\
事件标志组中的所有事件位都存储在一个无符号的 `EventBits_t` 类型的变量中，`EventBits_t` 在 `event_groups.h`

```c
typedef  TickType_t EventBits_t;
```

数据类型 `TickType_t` 在文件 portmacro.h

```c
#if( configUSE_16_BIT_TICKS == 1 )  
	typedef uint16_t TickType_t;  
	#define portMAX_DELAY ( TickType_t ) 0xffff  
#else  
	typedef uint32_t TickType_t;  
	#define portMAX_DELAY ( TickType_t ) 0xffffffffUL  
	#define portTICK_TYPE_IS_ATOMIC 1  
#endif
```

当 `configUSE_16_BIT_TICKS` 为 0 的时候 `TickType_t` 是个 32 位的数据类型，因此 `EventBits_t` 也是个 32 位的数据类型。`EventBits_t` 类型的变量可以存储 24 个事件位，另外的那高 8 位有其他用。事件位 0 存放在这个变量的 bit0 上，变量的 bit1 就是事件位 1，以此类推。\
**对于STM32来说，最多可以存储24个事件位**

![[Pasted image 20210717224328.png]]

## 创建事件标志组

| 函数                        | 描述             |
| ------------------------- | -------------- |
| xEventGroupCreate()       | 使用动态方法创建事件标志组。 |
| xEventGroupCreateStatic() | 使用静态方法创建事件标志组  |

### xEventGroupCreate()

用于创建一个事件标志组，所需要的内存通过动态内存管理方法分配由于内部处理的原因，事件标志组可用的bit数取决于`configUSE_16_BIT_TICKS` ， 当 `configUSE_16_BIT_TICKS1` 为1的时候事件标志组有8个可用的位(bit0~~bit7) ， 当 configUSE_16_BIT_TICKS 为 0 的时候事件标志组有 24 个可用的位(bit0~~bit23)

```c
EventGroupHandle_t xEventGroupCreate( void )
```

参数：

- 无

返回值

- NULL：事件标志组创建失败。
- 其他值: 创建成功的事件标志组句柄。

### xEventGroupCreateStatic()

此函数用于创建一个事件标志组定时器，所需要的内存需要用户自行分配

```c
EventGroupHandle_t xEventGroupCreateStatic( StaticEventGroup_t *pxEventGroupBuffer )
```

参数：

- pxEventGroupBuffer：  参数指向一个 StaticEventGroup_t 类型的变量，用来保存事件标志组结构体。

返回值：

- NULL: 事件标志组创建失败。
- 其他值: 创建成功的事件标志组句柄。

## 设置事件位

FreeRTOS 提供了 4 个函数用来设置事件标志组中事件位(标志)，事件位(标志)的设置包括清零和置 1 两种操作

| 函数                            | 描述                   |   |
| ----------------------------- | -------------------- | - |
| xEventGroupClearBits()        | 将指定的事件位清零，用在任务中。     |   |
| xEventGroupClearBitsFromISR() | 将指定的事件位清零，用在中断服务函数中  |   |
| xEventGroupSetBits()          | 将指定的事件位置 1，用在任务中。    |   |
| xEventGroupSetBitsFromISR()   | 将指定的事件位置 1，用在中断服务函数中 |   |

### xEventGroupClearBits()

将事件标志组中的指定事件位清零，此函数只能用在任务中，不能用在中断服务函数中

```c
EventBits_t xEventGroupClearBits( EventGroupHandle_t xEventGroup, const EventBits_t uxBitsToClear );
```

参数：

- xEventGroup： 要操作的事件标志组的句柄。
- uxBitsToClear：  要清零的事件位，比如要清除 bit3 的话就设置为 0X08。可以同时清除多个bit，如设置为 0X09 的话就是同时清除 bit3 和 bit0

返回值：

- 任何值：  将指定事件位清零之前的事件组值

### xEventGroupClearBitsFromISR()

xEventGroupClearBits()的中断级版本，也是将指定的事件位(标志)清零

```c
BaseType_t xEventGroupClearBitsFromISR( EventGroupHandle_t  xEventGroup, const EventBits_t uxBitsToSet );
```

参数：

- xEventGroup： 要操作的事件标志组的句柄。
- uxBitsToClear：  要清零的事件位

返回值：

- pdPASS:  事件位清零成功
- pdFALSE: 事件位清零失败

### xEventGroupSetBits()

设置指定的事件位为 1，此函数只能用在任务中，不能用于中断服务函数

```c
EventBits_t xEventGroupSetBits( EventGroupHandle_t xEventGroup,  const EventBits_t uxBitsToSet );
```

参数：

- xEventGroup： 要操作的事件标志组的句柄。
- uxBitsToClear：  指定要置 1 的事件位，比如要将 bit3 值 1 的话就设置为 0X08。可以同时将多个 bit 置 1，如设置为 0X09 的话就是同时将 bit3 和 bit0 置 1。

返回值：

- 任何值：  在将指定事件位置 1 后的事件组值。

### xEventGroupSetBitsFromISR()

此函数也用于将指定的事件位置 1，此函数是 xEventGroupSetBits()的中断版本

```c
BaseType_t xEventGroupSetBitsFromISR( EventGroupHandle_t xEventGroup, const EventBits_t uxBitsToSet, BaseType_t * pxHigherPriorityTaskWoken );
```

参数：

- xEventGroup： 要操作的事件标志组的句柄
- uxBitsToClear：指定要置 1 的事件位，比如要将 bit3 值 1 的话就设置为 0X08。可以同时将多个 bit 置 1，如设置为 0X09 的话就是同时将 bit3 和 bit0 置 1。
- pxHigherPriorityTaskWoken：标记退出此函数以后是否进行任务切换，这个变量的值函数会自动设置的，用户不用进行设置，用户只需要提供一个变量来保存这个值就行了。当此值为pdTRUE 的时候在退出中断服务函数之前一定要进行一次任务切换。

返回值:

- pdPASS：  事件位置 1 成功
- pdFALSE: 事件位置 1 失败

## 获取事件标志组的值

| 函数                          | 描述                    |   |
| --------------------------- | --------------------- | - |
| xEventGroupGetBits()        | 获取当前事件标志组的值，用在任务中     |   |
| xEventGroupGetBitsFromISR() | 获取当前事件标志组的值，用在中断服务函数中 |   |

### xEventGroupGetBits()

用于获取当前事件标志组的值，也就是各个事件位的值。此函数用在任务中，不能用在中断服务函数中。此函数是个宏，真正执行的是函数 `xEventGroupClearBits()`

```c
EventBits_t xEventGroupGetBits( EventGroupHandle_t xEventGroup )
```

参数：

- xEventGroup： 要获取的事件标志组的句柄。

返回值：

- 任何值：当前事件标志组的值。

### xEventGroupGetBitsFromISR()

获取当前事件标志组的值，此函数是 xEventGroupGetBits()的中断版本

```c
EventBits_t xEventGroupGetBitsFromISR( EventGroupHandle_t xEventGroup )
```

参数：

- xEventGroup： 要获取的事件标志组的句柄

返回值：

- 任何值： 当前事件标志组的值。

## 等待指定的事件位

某个任务可能需要与多个事件进行同步，那么这个任务就需要等待并判断多个事件位(标志)，使用函数 xEventGroupWaitBits()可以完成这个功能。调用函数以后如果任务要等待的事件位还没有准备好(置 1 或清零)的话任务就会进入阻塞态，直到阻塞时间到达或者所等待的事件位准备好。

```c
EventBits_t xEventGroupWaitBits( EventGroupHandle_t  xEventGroup,  										
								const EventBits_t uxBitsToWaitFor,
								const BaseType_t xClearOnExit,
								const BaseType_t xWaitForAllBits,
								const TickType_t xTicksToWait );
```

参数：

- xEventGroup： 指定要等待的事件标志组。
- uxBitsToWaitFord：  指定要等待的事件位，比如要等待bit0和(或)bit2的时候此参数就是0X05，如果要等待 bit0 和(或)bit1 和(或)bit2 的时候此参数就是 0X07，以此类推。
- xClearOnExit：  此参数要是为 pdTRUE 的话，那么在退出此函数之前由参数 uxBitsToWaitFor所设置的这些事件位就会清零。如果设置位 pdFALSE 的话这些事件位就不会改变。
- xWaitForAllBits： 此参数如果设置为 pdTRUE 的话，当 uxBitsToWaitFor 所设置的这些事件位都置 1，或者指定的阻塞时间到的时候函数 xEventGroupWaitBits()才会返回。当此函数为 pdFALSE 的话，只要 uxBitsToWaitFor 所设置的这些事件位其中的任意一个置1，或者指定的阻塞时间到的话函数xEventGroupWaitBits()就会返回。
- 设置阻塞时间，单位为节拍数

返回值：

- 任何值： 返回当所等待的事件位置 1 以后的事件标志组的值，或者阻塞时间到。根据这个值我们就知道哪些事件位置 1 了。如果函数因为阻塞时间到而返回的话那么这个返回值就不代表任何的含义。
