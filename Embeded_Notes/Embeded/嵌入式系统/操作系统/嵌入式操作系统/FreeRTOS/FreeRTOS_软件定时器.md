---
date updated: '2021-10-03T09:08:23+08:00'

---

# FreeRTOS软件定时器

## 简介

### 硬件定时器

CPU内部自带的定时器模块，通过初始化、配置可以实现定时，定时时间到以后会执行相应的定时器中断处理函数。
硬件定时器一般都带有其他功能，比如PWM输出、输入不会等功能，但是缺点是硬件定时器数量较少。

### 软件定时器

允许设置一段时间，当设置的时间到达之后就执行指定的功能函数，被定时器调用的这个功能函数叫做定时器的**回调函数**。回调函数的两次执行间隔叫做定时器的定时周期，当定时器的定时周期到了以后就会执行回调函数。

软件定时器的回调函数是在定时器服务任务中执行的，**所以一定不能在回调函数中调用任何会阻塞任务的API函数**，例如`vTaskDelay()`、`vTaskDelayUnti()`等，还有一些访问队列或者信号量的非零阻塞时间的API函数也不能调用

## 定时器服务/Daemon任务

定时器是一个可选的、不属于 FreeRTOS 内核的功能，它是由定时器服务(或 Daemon)任务来提供的。
FreeRTOS 提供了很多定时器有关的 API 函数，这些 API 函数大多都使用 FreeRTOS 的队列发送命令给定时器服务任务，这个队列叫做定时器命令队列。定时器命令队列是提供给FreeRTOS 的软件定时器使用的，用户不能直接访问。

![Pasted image 20210717210936](../../../../../pictures/Pasted%20image%2020210717210936.png)
在这个例子中，应用程序调用了函数 `xTimerReset()` ，结果就是复位命令会被发送到定时器命令队列中，定时器服务任务会处理这个命令。应用程序是通过函数 `xTimerReset()` 间接的向定时器命令队列发送了复位命令，并不是直接调用类似 `xQueueSend()` 这样的队列操作函数发送的。

### 定时器相关配置

- configUSE_TIMERS
  - 如果要使用软件定时器的话宏 configUSE_TIMERS 一定要设置为1
  - 当设置为 1 的话定时器服务任务就会在启动 FreeRTOS 调度器的时候自动创建

- configTIMER_TASK_PRIORITY
  - 设置软件定时器服务任务优先级，可以是`0~( configMAX_PRIORITIES-1)`
  - 优先级一定要根据实际的应用要求来设置。如果定时器服务任务的优先级设置的高的话，定时器命令队列中的命令和定时器回调函数就会及时的得到处理。

- configTIMER_QUEUE_LENGTH
  - 此宏用来设置定时器命令队列的队列长度

- configTIMER_TASK_STACK_DEPTH
  - 此宏用来设置定时器服务任务的任务堆栈大小，单位是字，不是字节。
  - 对于STM32来说，一个字是4字节

## 单次定时器和周期定时器

软件定时器分两种：单次定时器和周期定时器，单次定时器的话定时器回调函数就执行一次，比如定时 1s，当定时时间到了以后就会执行一次回调函数，然后定时器就会停止运行。对于单次定时器我们可以再次手动重新启动(调用相应的 API 函数即可)。
但是单次定时器不能自动重启。相反的，周期定时器一旦启动以后就会在执行完回调函数以后自动的重新启动，这样回调函数就会周期性的执行

![Pasted image 20210717211554](../../../../../pictures/Pasted%20image%2020210717211554.png)

## 复位软件定时器

有时候我们可能会在定时器正在运行的时候需要复位软件定时器，复位软件定时器的话会重新计算定时周期到达的时间点，**这个新的时间点是相对于复位定时器的那个时刻计算的**，**并不是第一次启动软件定时器的那个时间点**。

FreeRTOS提供两个API函数用来完成软件定时器的复位

| 函数                   | 描述                |
| -------------------- | ----------------- |
| xTimerReset()        | 复位软件定时器，用在任务中。    |
| xTimerResetFromISR() | 复位软件定时器，用在中断服务函数中 |

### xTimerReset()

复位一个软件定时器，此函数只能用在任务中，不能用于中断服务函数
此函数是一个宏定义，真正执行的是`xTimerGenericCommand()`

```c
BaseType_t xTimerReset( TimerHandle_t xTimer, TickType_t xTicksToWait )
```

参数：

- xTimer：  要复位的软件定时器的句柄。
- xTicksToWait：  设置阻塞时间，调用函数 xTimerReset ()开启软件定时器其实就是向定时器命令队列发送一条 `tmrCOMMAND_RESET` 命令，既然是向队列发送消息，那就会涉及到入队阻塞时间的设置。

返回值：

- pdPASS:  软件定时器复位成功，其实就是命令发送成功。
- pdFAIL:  软件定时器复位失败，命令发送失败。

### xTimerResetFromISR()

`xTimerReset()`的中断版本，此函数用于中断服务函数中
此函数是一个宏定义`xTimerGenericCommand()`

```c
BaseType_t xTimerResetFromISR( TimerHandle_t xTimer, BaseType_t * pxHigherPriorityTaskWoken );
```

参数：

- xTimer：  要复位的软件定时器的句柄。
- pxHigherPriorityTaskWoken：  记退出此函数以后是否进行任务切换，这个变量的值函数会自动设置的，用户不用进行设置，用户只需要提供一个变量来保存这个值就行了。当此值为 pdTRUE 的时候在退出中断服务函数之前一定要进行一次任务切换。

返回值：

- pdPASS:  软件定时器复位成功，其实就是命令发送成功
- pdFAIL:  软件定时器复位失败，命令发送失败

## 创建软件定时器

| 函数                   | 描述             |
| -------------------- | -------------- |
| xTimerCreate()       | 使用动态方法创建软件定时器。 |
| xTimerCreateStatic() | 使用静态方法创建软件定时器。 |

### xTiemrCreate()

用于创建一个软件定时器，所需要的内存通过动态内存管理方法分配。新创建的软件定时器处于休眠状态，也就是未运行的。

- xTimerStart()
- xTimerReset()
- xTimerStartFromISR()
- xTimerResetFromISR()
- xTimerChangePeriod()
- xTimerChangePeriodFromISR()

可以使新创建的定时器进入活动状态

```c
TimerHandle_t xTimerCreate( const char * const pcTimerName，
							TickType_t xTimerPeriodInTicks,
							 UBaseType_tuxAutoReload，
							 void * pvTimerID,
							 TimerCallbackFunction_t pxCallbackFunction )
```

参数：

- pcTimerName： 软件定时器名字，名字是一串字符串，用于调试使用
- xTimerPeriodInTicks ：软件定时器的定时器周期，单位是时钟节拍数。可以借助`portTICK_PERIOD_MS` 将 ms 单位转换为时钟节拍数。

举个例子，定时器的周期为 100 个时钟节拍的话，那么 `xTimerPeriodInTicks` 就为100，当定时器周期为 500ms 的时候 `xTimerPeriodInTicks` 就可以设置为(500/ portTICK_PERIOD_MS)。

- uxAutoReload：  设置定时器模式
  - pdTRUE的时候表示创建的是周期定时器
  - pdFALSE 的话表示创建的是单次定时器

- pvTimerID：定时器 ID 号，一般情况下每个定时器都有一个回调函数，当定时器定时周期到了以后就会执行这个回调函数。但是 FreeRTOS 也支持多个定时器共用同一个回调函数，在回调函数中根据定时器的 ID 号来处理不同的定时器。

- pxCallbackFunction： 定时器回调函数，当定时器定时周期到了以后就会调用这个函数。

返回值：

- NULL: 软件定时器创建失败。
- 其他值: 创建成功的软件定时器句柄。

### xTimerCreateStatic()

用于创建一个软件定时器，所需要的内存需要用户自行分配。

```c
TimerHandle_t xTimerCreateStatic(const char * const pcTimerName, 
								TickType_t xTimerPeriodInTicks,  
								UBaseType_t uxAutoReload,  
								void * pvTimerID,  
								TimerCallbackFunction_t pxCallbackFunction,  
								StaticTimer_t * pxTimerBuffer )
```

参数：

- pcTimerName： 软件定时器名字，名字是一串字符串，用于调试使用。
- xTimerPeriodInTicks ：软件定时器的定时器周期，单位是时钟节拍数。
- uxAutoReload：  设置定时器模式
- pvTimerID： 定时器 ID 号，一般情况下每个定时器都有一个回调函数，当定时器定时周期到了以后就会执行这个回调函数。
- pxCallbackFunction： 定时器回调函数
- pxTimerBuffer：参数指向一个 StaticTimer_t 类型的变量，用来保存定时器结构体。

## 开启软件定时器

| 函数                   | 描述             |
| -------------------- | -------------- |
| xTimerStart()        | 开启软件定时器，用于任务中。 |
| xTimerStartFromISR() | 开启软件定时器，用于中断中。 |

### xTimerStart()

启动软件定时器
此函数是个宏，真正执行的是函数 `xTimerGenericCommand`

```c
aseType_t xTimerStart( TimerHandle_t xTimer, TickType_t xTicksToWait )
```

参数：

- xTimer：要开启的软件定时器的句柄。
- xTicksToWait：设置阻塞时间

返回值：

- pdPASS:  软件定时器开启成功，其实就是命令发送成功。
- pdFAIL:  软件定时器开启失败，命令发送失败。

### xTimerStartFromISR()

函数 xTimerStart()的中断版本，用在中断服务函数中，此函数是一个宏，真正执行的是函数 `xTimerGenericCommand()`

```c
BaseType_t xTimerStartFromISR( TimerHandle_t xTimer, BaseType_t * pxHigherPriorityTaskWoken );
```

参数：

- xTimer：  要开启的软件定时器的句柄。
- pxHigherPriorityTaskWoken：  标记退出此函数以后是否进行任务切换，自动设置的，用户只要提供一个类型的参数保存这个值就可

返回值：

- pdPASS:  软件定时器开启成功，其实就是命令发送成功。
- pdFAIL:  软件定时器开启失败，命令发送失败。

## 停止软件定时器

| 函数                  | 描述                 |   |
| ------------------- | ------------------ | - |
| xTimerStop()        | 停止软件定时器，用于任务中。     |   |
| xTimerStopFromISR() | 停止软件定时器，用于中断服务函数中。 |   |

### xTimerStop()

用于停止一个软件定时器，此函数用于任务中，不能用在中断服务函数中
此函数是一个宏，真正调用的是函数 `xTimerGenericCommand()`

```c
BaseType_t xTimerStop ( TimerHandle_t xTimer, TickType_t xTicksToWait )
```

参数：

- xTimer：  要停止的软件定时器的句柄。
- xTicksToWait：  设置阻塞时间

返回值：

- pdPASS:  软件定时器停止成功，其实就是命令发送成功。
- pdFAIL:  软件定时器停止失败，命令发送失败。

### xTimerStopFromISR()

xTimerStop()的中断版本，此函数用于中断服务函数中
此函数是一个宏，真正执行的是`xTimerGenericCommand()`

```c
BaseType_t xTimerStopFromISR( TimerHandle_t xTimer, BaseType_t * pxHigherPriorityTaskWoken );
```

参数：

- xTimer：  要停止的软件定时器句柄。
- pxHigherPriorityTaskWoken：  标记退出此函数以后是否进行任务切换

返回值：

- pdPASS:  软件定时器停止成功，其实就是命令发送成功。
- pdFAIL:  软件定时器停止失败，命令发送失败
