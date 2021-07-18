# FreeRTOS空闲任务
空闲任务是 FreeRTOS 必不可少的一个任务，其他 RTOS 类系统也有空闲任务，比如 uC/OS空闲任务是处理器空闲的时候去运行的一个任务，当系统中没有其他就绪任务的时候空闲任务就会开始运行，空闲任务的优先级是最低的，FreeRTOS的空闲任务会执行一些其他的处理，而不会让CPU一直处于空闲状态

## 空闲任务简介
当 FreeRTOS 的调度器启动以后就会自动的创建一个空闲任务，这样就可以确保至少有一任务可以运行。但是这个空闲任务使用最低优先级，如果应用中有其他高优先级任务处于就绪态的话这个空闲任务就不会跟高优先级的任务抢占 CPU 资源。空闲任务还有另外一个重要的职责，如果某个任务要调用函数 `vTaskDelete()`删除自身，那么这个任务的任务控制块 TCB 和任务堆栈等这些由 FreeRTOS 系统自动分配的内存需要在空闲任务中释放掉，如果删除的是别的任务那么相应的内存就会被直接释放掉，不需要在空闲任务中释放。
一定要给空闲任务执行的机会！除此以外空闲任务就没有什么特别重要的功能了，所以可以根据实际情况减少空闲任务使用 CPU 的时间(比如，当 CPU 运行空闲任务的时候使处理器进入低功耗模式)。

## 空闲任务
### 空闲任务的创建
当调用`vTaskStartScheduler()`启动任务调度器的时候此函数就会自动创建空闲任务。
```c
void vTaskStartScheduler( void ){
	BaseType_t xReturn;
	
	//创建空闲任务，使用最低优先级
	#if( configSUPPORT_STATIC_ALLOCATION == 1 )
	{
		StaticTask_t *pxIdleTaskTCBBuffer = NULL;  
		StackType_t *pxIdleTaskStackBuffer = NULL;  
		uint32_t ulIdleTaskStackSize;  
  
		vApplicationGetIdleTaskMemory( &pxIdleTaskTCBBuffer, &pxIdleTaskStackBuffer,&ulIdleTaskStackSize );
		xIdleTaskHandle = xTaskCreateStatic(  prvIdleTask,  
											  "IDLE", 
											  ulIdleTaskStackSize, 
											  ( void * ) NULL,  
											  ( tskIDLE_PRIORITY | portPRIVILEGE_BIT ),
											  pxIdleTaskStackBuffer,  
											  pxIdleTaskTCBBuffer );
	
	}
}
		if( xIdleTaskHandle != NULL )
		{
			xReturn = pdPASS;
		}
		else  
		{  
			xReturn = pdFAIL;  
		}
		
	}
	#else
	{  
		xReturn = xTaskCreate( prvIdleTask,  
							   "IDLE",  
								configMINIMAL_STACK_SIZE,  
								( void * ) NULL,  
								( tskIDLE_PRIORITY | portPRIVILEGE_BIT ),  
								&xIdleTaskHandle );  
	}  
#endif /* configSUPPORT_STATIC_ALLOCATION */  
  
/*********************************************************************/  
/**************************省略其他代码*******************************/  
/*********************************************************************/  
}
```
空闲任务的任务函数为 `prvIdleTask()`，任务堆栈大小为`configMINIMAL_STACK_SIZE`，任务堆栈大小可以在 FreeRTOSConfig.h 中修改。任务优先级为`tskIDLE_PRIORITY`，宏 `tskIDLE_PRIORITY` 为 0，说明空闲任务优先级最低，用户不能随意修改空闲任务的优先级。

### 空闲任务函数
空闲任务的任务函数为 `prvIdleTask()`，但是实际上是找不到这个函数的，因为它是通过宏定义来实现的，在portmacro.h中有定义
```c
#define portTASK_FUNCTION( vFunction, pvParameters ) void vFunction( void *pvParameters )
```
`portTASK_FUNCTION()`在task.c中有定义，他就是空闲任务函数
```c
static portTASK_FUNCTION( prvIdleTask, pvParameters )
{
	( void ) pvParameters; 			//防止报错
	//本函数为 FreeRTOS 的空闲任务任务函数，当任务调度器启动以后空闲任务会自动  
	//创建
	for(;;){
		//检查是否有任务要删除自己，如果有的话就释放这些任务的任务控制块 TCB 和  
		//任务堆栈的内存
		prvCheckTasksWaitingTermination();
		#if ( configUSE_PREEMPTION == 0 )
		{
			//如果没有使用抢占式内核的话就强制进行一次任务切换查看是否有其他  
			//任务有效，如果有使用抢占式内核的话就不需要这一步，因为只要有任  
			//何任务有效(就绪)之后都会自动的抢夺 CPU 使用权
			taskYIELD();
		}
		#endif /* configUSE_PREEMPTION */
		#if ( ( configUSE_PREEMPTION == 1 ) && ( configIDLE_SHOULD_YIELD == 1 ) ){
			//如果使用抢占式内核并且使能时间片调度的话，当有任务和空闲任务共享  
			//一个优先级的时候，并且此任务处于就绪态的话空闲任务就应该放弃本时  
			//间片，将本时间片剩余的时间让给这个就绪任务。如果在空闲任务优先级  
			//下的就绪列表中有多个用户任务的话就执行这些任务
			if( listCURRENT_LIST_LENGTH( & ( pxReadyTasksLists[ tskIDLE_PRIORITY ] ) )> ( UBaseType_t ) 1 ){
				taskYIELD();
			}
			else
			{
				mtCOVERAGE_TEST_MARKER();
			}
		}
		endif
		#if ( configUSE_IDLE_HOOK == 1)
		{
			extern void vApplicationIdleHook( void );
			//执行用户定义的空闲任务钩子函数，钩子函数里面不能使用任何  
			//可以引起阻塞空闲任务的 API 函数
			vApplicayionIdleHook();
		}
		#endif /* configUSE_IDLE_HOOK */
		
		//如果使能了 Tickless 模式的话就执行相关的处理代码
		#if ( configUSE_TICKLESS_IDLE != 0 )
		{
			TickType_t xExpectedIdleTime;
			
			xExpectedIdleTime = prvGetExpectedIdleTime();
			if( xExpectedIdleTime >= configEXPECTED_IDLE_TIME_BEFORE_SLEEP )
			{
				vTaskSuspendAll();
				{
					//调度器已经被挂起，重新采集一次时间值，这次的时间值可以  
					//使用
					configASSERT( xNextTaskUnblockTime >= xTickCount );
					xExpectedIdleTime = prvGetExpectedIdleTime();
					
					if( xExpectedIdleTime >= configEXPECTED_IDLE_TIME_BEFORE_SLEEP )
					{
						traceLOW_POWER_IDLE_BEGIN();  
						portSUPPRESS_TICKS_AND_SLEEP( xExpectedIdleTime ); (11)  
						traceLOW_POWER_IDLE_END();	
					}
					else
					{
						mtCOVERAGE_TEST_MARKER();
					}
				}
				(void)xTaskResumeAll();
			}
			else
			{
				mtCOVERAGE_TEST_MARKER();
			}
			#endif /* configUSE_TICKLESS_IDLE */
		}
	}
}

```
基本就是完成介绍说的那些功能，并且判断低功耗模式是否使用

## 空闲任务钩子函数
FreeRTOS 中有多个钩子函数，钩子函数类似回调函数，当某个功能(函数)执行的时候就会调用钩子函数，钩子函数的具体内容那就由用户来编写。

| 宏定义                             | 描述                                                                                                                                       |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| configUSE_IDLE_HOOK                | 空闲任务钩子函数，空闲任务会调用此钩子函数。                                                                                               |
| configUSE_TICK_HOOK                | 时间片钩子函数，`xTaskIncrementTick()`会调用此钩子函数</br>此钩子函数最终会被节拍中断服务函数用，对于 STM32 来说就是滴答定时器中断服务函数。 |
| configUSE_MALLOC_FAILED_HOOK       | 内存申请失败钩子函数当使用函数`pvPortMalloc()`申请内存失败的时候就会调用此钩子函数。                                                         |
| configUSE_DAEMON_TASK_STARTUP_HOOK | 守护(Daemon)任务启动钩子函数，守护任务也就是定时器服务任务                                                                                 |

钩子函数的使用方法基本相同，用户使能相应的钩子函数，然后自行根据实际需求编写钩子函数的内容