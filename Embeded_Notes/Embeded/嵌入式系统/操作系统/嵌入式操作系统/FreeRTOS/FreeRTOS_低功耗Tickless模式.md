---
date updated: '2021-10-03T09:08:47+08:00'

---

# FreeRTOS低功耗Tickless模式

很多应用场合对于空耗的要求很严格，比如长期无人照看的数据采集仪器，可穿戴设备等
很多MCU都对应有着相应的低功耗模式，以此来降低设备运行时的功耗，进行裸机开发的时候就可以使用这些低功耗模式。
但是现在要对裸机上操作系统，操作系统对于低功耗的支持也显得尤为重要，这样硬件与软件相结合，可以进一步降低系统的功耗。
而FreeRTOS就提供了一个叫做 Tickless 的低功耗模式

## Tickless 模式

### 如何降低功耗

一般的简单应用中处理器大量的时间都在处理空闲任务，所以可以考虑当处理器处理空闲任务的时候就进入低功耗模式，当需要处理应用层代码的时候就将处理器从低功耗模式唤醒。
FreeRTOS 就是通过在处理器处理空闲任务的时候将处理器设置为低功耗模式来降低能耗。一般会在空闲任务的钩子函数中执行低功耗相关处理，比如设置处理器进入低功耗模式、关闭其他外设时钟、降低系统主频等等

FreeRTOS 的系统时钟是由滴答定时器中断来提供的，系统时钟频率越高，那么滴答定时器中断频率也就越高。中断是可以将 STM32F407 从睡眠模式中唤醒，周期性的滴答定时器中断就会导致 STM32F407 周期性的进入和退出睡眠模式。因此，如果滴答定时器中断频率太高的话会导致大量的能量和时间消耗在进出睡眠模式中，这样导致的结果就是低功耗模式的作用被大大的削弱。
为此，FreeRTOS 特地提供了一个解决方法——Tickless 模式，当处理器进入空闲任务周期以后就关闭系统节拍中断(滴答定时器中断)，只有当其他中断发生或者其他任务需要处理的时候处理器才会被从低功耗模式中唤醒。

## Tickless具体实现

### 宏configUSE_TICKLESS_IDLE

要想使用 Tickless 模式，首先必须将 FreeRTOSConfig.h 中的宏 `configUSE_TICKLESS_IDLE` 设置为 1

```c
#define configUSE_TICKLESS_IDLE 1 //1 启用低功耗 tickless 模式
```

### 宏portSUPPRESS_TICKS_AND_SLEEP()

使能 Tickless 模式以后当下面两种情况都出现的时候
FreeRTOS 内核就会调用宏`portSUPPRESS_TICKS_AND_SLEEP()`来处理低功耗相关的工作

- 空闲任务是唯一可运行的任务，因为其他所有的任务都处于阻塞态或者挂起态
- 系统处于低功耗模式的时间至少大于 `configEXPECTED_IDLE_TIME_BEFORE_SLEEP`个时钟节拍，宏 `configEXPECTED_IDLE_TIME_BEFORE_SLEEP` 默认在文件 FreeRTOS.h 中定义为 2，我们可以在 FreeRTOSConfig.h 中重新定义，此宏必须大于 2！

portSUPPRESS_TICKS_AND_SLEEP()有个参数，此参数用来指定还有多长时间将有任务进入就绪态，其实就是处理器进入低功耗模式的时长(单位为时钟节拍数)，因为一旦有其他任务进入就绪态处理器就必须退出低功耗模式去处理这个任务。

`portSUPPRESS_TICKS_AND_SLEEP()`应该是由用户根据自己所选择的平台来编写的，此宏会被空闲任务调用来完成具体的低功耗工作。但是！如果使用 STM32 的话编写这个宏的工作就不用我们来完成了，因为 FreeRTOS 已经帮我们做好了
如果要自己编写的话要将configUSE_TICKLESS_IDLE设置为2
宏 `portSUPPRESS_TICKS_AND_SLEEP` 在文件 portmacro.h 中如下定义

```c
#ifndef portSUPPRESS_TICKS_AND_SLEEP  
	extern void vPortSuppressTicksAndSleep( TickType_t xExpectedIdleTime );  
	#define portSUPPRESS_TICKS_AND_SLEEP( xExpectedIdleTime )  
	vPortSuppressTicksAndSleep( xExpectedIdleTime )  
#endif
```

可以看出`portSUPPRESS_TICKS_AND_SLEEP()`的本质就是函数`vPortSuppressTicksAndSleep()`，此函数在文件port.c中有定义
