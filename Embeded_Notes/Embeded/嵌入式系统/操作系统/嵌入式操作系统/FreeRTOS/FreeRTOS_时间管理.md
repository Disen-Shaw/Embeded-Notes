# FreeRTOS系统延时
## 系统延时函数
FreeRTOS中的系统延时函数有两个：

| 函数              | 说明     |
| ----------------- | -------- |
| vTaskDelay()      | 相对延时 |
| vTaskDelayUntil() | 绝对延时 |

### vTaskDelay()
相对延时的模式
```c
void vTaskDelay( const TickType_t xTicksToDelay ){

	BaseType_t xAlreadyYielded = pdFALSE;  
	//延时时间要大于 0。  
	if( xTicksToDelay > ( TickType_t ) 0U ) (1)  
	{  
		configASSERT( uxSchedulerSuspended == 0 );  
		vTaskSuspendAll(); (2)  
		{  
			traceTASK_DELAY();  
			prvAddCurrentTaskToDelayedList( xTicksToDelay, pdFALSE 	); (3)  
		}  
		xAlreadyYielded = xTaskResumeAll(); (4)  
	}  
	else  
	{  
		mtCOVERAGE_TEST_MARKER();  
	}  
	if( xAlreadyYielded == pdFALSE ) (5)  
	{  
		portYIELD_WITHIN_API(); (6)  
	}  
	else  
	{  
		mtCOVERAGE_TEST_MARKER();
	}
}
```
(1)延时时间由参数 xTicksToDelay 来确定，为要延时的时间节拍数，延时时间肯定要大于0。否则的话相当于直接调用函数 `portYIELD()` 进行任务切换。
(2)调用函数 `vTaskSuspendAll()`挂起任务调度器。
(3)调用函数`prvAddCurrentTaskToDelayedList()`将要延时的任务添加到延时列表`pxDelayedTaskList`或者`pxOverflowDelayedTaskList()` 中
(4)调用函数 `xTaskResumeAll()`恢复任务调度器。
(5)如果函数 `xTaskResumeAll()`没有进行任务调度的话那么在这里就得进行任务调度
(6)调用函数 `portYIELD_WITHIN_API()`进行一次任务调度

#### prvAddCurrentTaskToDelayedList()
将当前任务添加到等待列表中，在task.c中定义
```c
static void prvAddCurrentTaskToDelayedList( TickType_t x TicksToWait, const BaseType_t xCanBlockIndefinitely ){
	TickType_t xTimeToWake;  
	const TickType_t xConstTickCount = xTickCount; (1)  
  
	#if( INCLUDE_xTaskAbortDelay == 1 )  
	{  
		//如果使能函数 xTaskAbortDelay()的话复位任务控制块的 ucDelayAborted 字段为  
		//pdFALSE。  
		pxCurrentTCB->ucDelayAborted = pdFALSE;  
	}  
	#endif
	if( uxListRemove( &( pxCurrentTCB->xStateListItem ) ) == ( UBaseType_t ) 0 )  (2)  
	{  
	portRESET_READY_PRIORITY( pxCurrentTCB->uxPriority, uxTopReadyPriority ); (3)  
	}  
		else  
	{  
		mtCOVERAGE_TEST_MARKER();  
	}
	#if ( INCLUDE_vTaskSuspend == 1 )  
	{  
		if( ( xTicksToWait == portMAX_DELAY ) && ( xCanBlockIndefinitely != pdFALSE ) )(4)  
	{  
		vListInsertEnd( &xSuspendedTaskList, &( pxCurrentTCB->xStateListItem ) ); (5)  
	}  
	else  
	{  
		xTimeToWake = xConstTickCount + xTicksToWait; (6)  
		listSET_LIST_ITEM_VALUE( &( pxCurrentTCB->xStateListItem ), \ (7)  
		xTimeToWake );  
		if( xTimeToWake < xConstTickCount ) (8)  
		{  
			vListInsert( pxOverflowDelayedTaskList, &( pxCurrentTCB->\ (9)  
			xStateListItem ) );
		}
		else  
		{  
			vListInsert( pxDelayedTaskList, &( pxCurrentTCB->xStateListItem ) ); (10)  
			if( xTimeToWake < xNextTaskUnblockTime ) (11)  
			{  
				xNextTaskUnblockTime = xTimeToWake; (12)  
			}  
			else  
			{  
				mtCOVERAGE_TEST_MARKER();  
			}  
		}  
	}  
}
/***************************************************************************/  
/****************************其他条件编译语句*******************************/  
/***************************************************************************/
```
函数的主要内容为：
(1)读取进入函数 prvAddCurrentTaskToDelayedList()的时间点并保存在 xConstTickCount 中，后面计算任务唤醒时间点的时候要用到。xTickCount 是时钟节拍计数器，每个滴答定时器中断 xTickCount 都会加一。
(2)要将当前正在运行的任务添加到延时列表中，肯定要先将当前任务从就绪列表中移除。
(3)将当前任务从就绪列表中移除以后还要取消任务在 `uxTopReadyPriority` 中的就绪标记。也就是将 `uxTopReadyPriority` 中对应的 bit 清零
(4)延时时间为最大值portMAX_DELAY，并且`xCanBlockIndefinitely` 不为`pdFALSE`(`xCanBlockIndefinitely` 不为 `pdFALSE` 的话表示允许阻塞任务)的话直接将当前任务添加到挂起列表中，任务就不用添加到延时列表中。
(5)将当前任务添加到挂起列表`xSuspendedTaskList`的末尾
(6)计算任务唤醒时间点，也就是(1)中获取到的进入函数 `prvAddCurrentTaskToDelayedList()`的时间值 `xConstTickCount` 加上延时时间值 `xTicksToWait`
(7)将计算到的任务唤醒时间点值 `xTimeToWake` 写入到任务列表中壮态列表项的相应字段中。
(8)计算得到的任务唤醒时间点小于 xConstTickCount，说明发生了溢出。
(9)如果发生了溢出的话就将当前任务添加到`pxOverflowDelayedTaskList`所指向的列表中
(10)如果没有发生溢出的话就将当前任务添加到 `pxDelayedTaskList` 所指向的列表中。
(11)`xNextTaskUnblockTime` 是个全局变量，保存着距离下一个要取消阻塞的任务最小时间点值。 当 `xTimeToWake` 小于 `xNextTaskUnblockTime` 的话说明有个更小的时间点来了。
(12)更新 xNextTaskUnblockTime 为 xTimeToWake。

### vTaskDelayUntil()
函数 `vTaskDelayUntil()`会**阻塞任务**，阻塞时间是一个**绝对时间**，那些需要按照一定的频率运行的任务可以使用函数 `vTaskDelayUntil()`。

```c
void vTaskDelayUntil( TickType_t * const  pxPreviousWakeTime, const TickType_t xTimeIncrement ){
	TickType_t xTimeToWake;  
	BaseType_t xAlreadyYielded, xShouldDelay = pdFALSE;  

	configASSERT( pxPreviousWakeTime );  
	configASSERT( ( xTimeIncrement > 0U ) );  
	configASSERT( uxSchedulerSuspended == 0 );
	vTaskSuspendAll(); (1)  
	{  
		const TickType_t xConstTickCount = xTickCount; (2)  
		xTimeToWake = *pxPreviousWakeTime + xTimeIncrement; (3)  

		if( xConstTickCount < *pxPreviousWakeTime ) (4)  
		{  
			if( ( xTimeToWake < *pxPreviousWakeTime ) && ( xTimeToWake >\ (5)  
			xConstTickCount ) )  
			{  
				xShouldDelay = pdTRUE; (6)  
			}  
			else  
			{  
				mtCOVERAGE_TEST_MARKER();  
			}  
		}
		else
		{  
		if( ( xTimeToWake < *pxPreviousWakeTime ) || ( xTimeToWake > \ (7)  
xConstTickCount ) )  
		{  
			xShouldDelay = pdTRUE; (8)  
		}  
		else
		{  
			mtCOVERAGE_TEST_MARKER();  
		}
	}
	*pxPreviousWakeTime = xTimeToWake; (9)  
  
	if( xShouldDelay != pdFALSE ) (10)  
	{  
		traceTASK_DELAY_UNTIL( xTimeToWake );  
		prvAddCurrentTaskToDelayedList( xTimeToWake - xConstTickCount, pdFALSE );(11)  
	}
	else  
	{  
		mtCOVERAGE_TEST_MARKER();  
	}
	xAlreadyYielded = xTaskResumeAll(); (12)  
  
	if( xAlreadyYielded == pdFALSE )  
	{  
		ortYIELD_WITHIN_API();  
	}  
	else  
	{  
		mtCOVERAGE_TEST_MARKER();  
	}
}
```
参数：
+ pxPreviousWakeTime：上一次任务延时结束被唤醒的时间点，任务中第一次调用函数`vTaskDelayUntil()` 的话需要将 `pxPreviousWakeTime` 初始化进入任务的 while()循环体的时间点值。在以后的运行中函数 `vTaskDelayUntil()`会自动更新 `pxPreviousWakeTime`。
+ xTimeIncrement：任务需要延时的时间节拍数(相对于 `pxPreviousWakeTime` 本次延时的节拍数)

(1)挂起任务调度器
(2)记录进入函数 `vTaskDelayUntil()`的时间点值，并保存在 `xConstTickCount`中。
(3)根据延时时间 `xTimeIncrement` 来计算任务下一次要唤醒的时间点，并保存在 `xTimeToWake` 中。
这个延时时间是相对于 `pxPreviousWakeTime` 的，也就是上一次任务被唤醒的时间点
pxPreviousWakeTime、xTimeToWake、xTimeIncrement 和 xConstTickCount的关系如图：
![[Pasted image 20210715220655.png]]
也就是说如果使用 vTaskDelayUntil()的话任务相当于任务的执行周  
期永远都是 xTimeIncrement，而任务一定要在这个时间内执行完成。这样就保证了任务永远按照一定的频率运行了，这个延时值就是绝对延时时间，因此函数 vTaskDelayUntil()也叫做绝对延时函数


使用函数 `vTaskDelayUntil()` 延时的任务也不一定就能周期性的运行，使用函数 `vTaskDelayUntil()` 只能保证你按照一定的周期取消阻塞，进入就绪态。如果有更高优先级或者中断的话你还是得等待其他的高优先级任务或者中断服务函数运行完成才能轮到你。

## FreeRTOS系统时钟节拍
不管是什么系统，运行都需要有个系统时钟节拍
xTickCount 就是FreeRTOS 的系统时钟节拍计数器。每个滴答定时器中断中 xTickCount 就会加一，xTickCount 的具体操作过程是在函数 `xTaskIncrementTick()`中进行的，函数在tasks.c中定义

如果用户如果调用函数 `vTaskSuspendAll()` 挂起了任务调度器的话在每个滴答定时器中断就不不会更新 `xTickCount` 了。
取而代之的是用 `uxPendedTicks` 来记录调度器挂起过程中的时钟节拍数。这样在调用函数 `xTaskResumeAll()` 恢复任务调度器的时候就会调用 `uxPendedTicks` 次函数`xTaskIncrementTick()`，这样 `xTickCount` 就会恢复，并且那些应该取消阻塞的任务都会取消阻塞。

如果使能了时间片钩子函数的话就执行时间片钩子函数`vApplicationTickHook()`，函数的具体内容由用户自行编写。

