# FreeRTOS任务调度器
## 任务调度器开启函数
基本历程都是在main()函数中创建一个开始任务，后面紧接着调用函数`vTaskStartScheduler()`，这个函数的功能就是开启任务调度器，在task.c中定义。
主要内容是创建空闲函数，如果使用静态内存的话使用函数`xTaskCreateStatic()`来创建空闲任务，优先级为`tskIDLE_PRIORITY`，宏`tskIDLE_PRIORITY`为0，也就是最低优先级。

如果使用软件定时器的话还需要通过函数`xTimerCreateTimerTask()`来创建定时器服务任务定时器服务任务的具体创建过程是在函数`xTimerCreateTimerTask()`中完成的
关闭中断，在SVC中断服务函数`vPortSCVHandler()`中会打开中断变量`xSchedulerRunning`设置为`pdTRUE`，表示调度器开始运行

当宏`configGENERATE_RUN_TIME_STATS`为1的时候说明使能时间统计功能，此时需要用户实现宏`portCONFIGURE_TIMER_FOR_RUN_TIME_STATS`，此宏用来配置一个定时器/计数器
调用函数`xPortStartScheduler()`来初始化跟调度器启动有关的硬件，比如滴答定时器、FPU但愿和PendSV中断等

```c
void vTaskStartScheduler( void )
{
BaseType_t xReturn;

	/* Add the idle task at the lowest priority. */
	#if( configSUPPORT_STATIC_ALLOCATION == 1 )
	// 如果支持静态创建任务，Idle函数的堆栈和TCB会被设置成NULL，需要用户自己完善这个功能
	{
		StaticTask_t *pxIdleTaskTCBBuffer = NULL;
		StackType_t *pxIdleTaskStackBuffer = NULL;
		uint32_t ulIdleTaskStackSize;

		/* The Idle task is created using user provided RAM - obtain the
		address of the RAM then create the idle task. */
		vApplicationGetIdleTaskMemory( &pxIdleTaskTCBBuffer, &pxIdleTaskStackBuffer, &ulIdleTaskStackSize );
		xIdleTaskHandle = xTaskCreateStatic(	prvIdleTask,
												configIDLE_TASK_NAME,
												ulIdleTaskStackSize,
												( void * ) NULL, /*lint !e961.  The cast is not redundant for all compilers. */
												portPRIVILEGE_BIT, /* In effect ( tskIDLE_PRIORITY | portPRIVILEGE_BIT ), but tskIDLE_PRIORITY is zero. */
												pxIdleTaskStackBuffer,
												pxIdleTaskTCBBuffer ); /*lint !e961 MISRA exception, justified as it is not a redundant explicit cast to all supported compilers. */

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
	// 动态创建方式,自动完成创建,Idle任务参数在宏定义中定义
	{
		/* The Idle task is being created using dynamically allocated RAM. */
		xReturn = xTaskCreate(	prvIdleTask,
								configIDLE_TASK_NAME,
								configMINIMAL_STACK_SIZE,
								( void * ) NULL,
								portPRIVILEGE_BIT, /* In effect ( tskIDLE_PRIORITY | portPRIVILEGE_BIT ), but tskIDLE_PRIORITY is zero. */
								&xIdleTaskHandle ); /*lint !e961 MISRA exception, justified as it is not a redundant explicit cast to all supported compilers. */
	}
	#endif /* configSUPPORT_STATIC_ALLOCATION */
	// 如果定义了定时任务
	#if ( configUSE_TIMERS == 1 )
	{
		if( xReturn == pdPASS )
		{
			xReturn = xTimerCreateTimerTask();
		}
		else
		{
			mtCOVERAGE_TEST_MARKER();
		}
	}
	#endif /* configUSE_TIMERS */

	if( xReturn == pdPASS )
	{
		/* freertos_tasks_c_additions_init() should only be called if the user
		definable macro FREERTOS_TASKS_C_ADDITIONS_INIT() is defined, as that is
		the only macro called by the function. */
		// 如果定义了那个宏,就要初始化这个application_init的函数
		#ifdef FREERTOS_TASKS_C_ADDITIONS_INIT
		{
			freertos_tasks_c_additions_init();
		}
		#endif

		/* Interrupts are turned off here, to ensure a tick does not occur
		before or during the call to xPortStartScheduler().  The stacks of
		the created tasks contain a status word with interrupts switched on
		so interrupts will automatically get re-enabled when the first task
		starts to run. */
		// 关中断
		portDISABLE_INTERRUPTS();

		#if ( configUSE_NEWLIB_REENTRANT == 1 )
		{
			/* Switch Newlib's _impure_ptr variable to point to the _reent
			structure specific to the task that will run first.
			See the third party link http://www.nadler.com/embedded/newlibAndFreeRTOS.html
			for additional information. */
			_impure_ptr = &( pxCurrentTCB->xNewLib_reent );
		}
		#endif /* configUSE_NEWLIB_REENTRANT */

		xNextTaskUnblockTime = portMAX_DELAY;
		xSchedulerRunning = pdTRUE;
		xTickCount = ( TickType_t ) configINITIAL_TICK_COUNT;

		/* If configGENERATE_RUN_TIME_STATS is defined then the following
		macro must be defined to configure the timer/counter used to generate
		the run time counter time base.   NOTE:  If configGENERATE_RUN_TIME_STATS
		is set to 0 and the following line fails to build then ensure you do not
		have portCONFIGURE_TIMER_FOR_RUN_TIME_STATS() defined in your
		FreeRTOSConfig.h file. */
		portCONFIGURE_TIMER_FOR_RUN_TIME_STATS();

		traceTASK_SWITCHED_IN();

		/* Setting up the timer tick is hardware specific and thus in the
		portable interface. */
		if( xPortStartScheduler() != pdFALSE )
		{
			/* Should not reach here as if the scheduler is running the
			function will not return. */
		}
		else
		{
			/* Should only reach here if a task calls xTaskEndScheduler(). */
		}
	}
	else
	{
		/* This line will only be reached if the kernel could not be started,
		because there was not enough FreeRTOS heap to create the idle task
		or the timer task. */
		configASSERT( xReturn != errCOULD_NOT_ALLOCATE_REQUIRED_MEMORY );
	}

	/* Prevent compiler warnings if INCLUDE_xTaskGetIdleTaskHandle is set to 0,
	meaning xIdleTaskHandle is not used anywhere else. */
	( void ) xIdleTaskHandle;
}

```
## 内核相关硬件初始化函数
FreeRTOS系统时钟是由滴答定时器来提供的，而且任务切换也会用到PendSV中断，这些硬件的初始化由函数`xPortStartScheduler()`来完成
主要设置PendSV的中断优先级,为最低优先级
设置滴答定时器的中断优先级,为最低优先级
调用函数`vPortSetupTimerInterrupt()`来设置来设置滴答定时器的定时周期，并且使能滴答定时器的中断
初始化临界区嵌套计数器
调用函数`prvEnableVFP()`使能FPU。
设置寄存器FPCCR的bit31和bit30都为1，这样S0~S15和FPSCR寄存器在异常入口和退出时的壮态自动保存和恢复。并且异常流程使用惰性压栈的特性以保证中断等待
```c
BaseType_t xPortStartScheduler( void )
{
	/* configMAX_SYSCALL_INTERRUPT_PRIORITY must not be set to 0.
	See http://www.FreeRTOS.org/RTOS-Cortex-M3-M4.html */
	configASSERT( configMAX_SYSCALL_INTERRUPT_PRIORITY );

	/* This port can be used on all revisions of the Cortex-M7 core other than
	the r0p1 parts.  r0p1 parts should use the port from the
	/source/portable/GCC/ARM_CM7/r0p1 directory. */
	configASSERT( portCPUID != portCORTEX_M7_r0p1_ID );
	configASSERT( portCPUID != portCORTEX_M7_r0p0_ID );

	#if( configASSERT_DEFINED == 1 )
	{
		volatile uint32_t ulOriginalPriority;
		volatile uint8_t * const pucFirstUserPriorityRegister = ( volatile uint8_t * const ) ( portNVIC_IP_REGISTERS_OFFSET_16 + portFIRST_USER_INTERRUPT_NUMBER );
		volatile uint8_t ucMaxPriorityValue;

		/* Determine the maximum priority from which ISR safe FreeRTOS API
		functions can be called.  ISR safe functions are those that end in
		"FromISR".  FreeRTOS maintains separate thread and ISR API functions to
		ensure interrupt entry is as fast and simple as possible.

		Save the interrupt priority value that is about to be clobbered. */
		ulOriginalPriority = *pucFirstUserPriorityRegister;

		/* Determine the number of priority bits available.  First write to all
		possible bits. */
		*pucFirstUserPriorityRegister = portMAX_8_BIT_VALUE;
		
		/* Read the value back to see how many bits stuck. */
		ucMaxPriorityValue = *pucFirstUserPriorityRegister;

		/* Use the same mask on the maximum system call priority. */
		ucMaxSysCallPriority = configMAX_SYSCALL_INTERRUPT_PRIORITY & ucMaxPriorityValue;

		/* Calculate the maximum acceptable priority group value for the number
		of bits read back. */
		ulMaxPRIGROUPValue = portMAX_PRIGROUP_BITS;
		while( ( ucMaxPriorityValue & portTOP_BIT_OF_BYTE ) == portTOP_BIT_OF_BYTE )
		{
			ulMaxPRIGROUPValue--;
			ucMaxPriorityValue <<= ( uint8_t ) 0x01;
		}

		#ifdef __NVIC_PRIO_BITS
		{
			/* Check the CMSIS configuration that defines the number of
			priority bits matches the number of priority bits actually queried
			from the hardware. */
			configASSERT( ( portMAX_PRIGROUP_BITS - ulMaxPRIGROUPValue ) == __NVIC_PRIO_BITS );
		}
		#endif

		#ifdef configPRIO_BITS
		{
			/* Check the FreeRTOS configuration that defines the number of
			priority bits matches the number of priority bits actually queried
			from the hardware. */
			configASSERT( ( portMAX_PRIGROUP_BITS - ulMaxPRIGROUPValue ) == configPRIO_BITS );
		}
		#endif

		/* Shift the priority group value back to its position within the AIRCR
		register. */
		ulMaxPRIGROUPValue <<= portPRIGROUP_SHIFT;
		ulMaxPRIGROUPValue &= portPRIORITY_GROUP_MASK;

		/* Restore the clobbered interrupt priority register to its original
		value. */
		*pucFirstUserPriorityRegister = ulOriginalPriority;
	}
	#endif /* conifgASSERT_DEFINED */

	/* Make PendSV and SysTick the lowest priority interrupts. */
	portNVIC_SYSPRI2_REG |= portNVIC_PENDSV_PRI;
	portNVIC_SYSPRI2_REG |= portNVIC_SYSTICK_PRI;

	/* Start the timer that generates the tick ISR.  Interrupts are disabled
	here already. */
	vPortSetupTimerInterrupt();

	/* Initialise the critical nesting count ready for the first task. */
	uxCriticalNesting = 0;

	/* Ensure the VFP is enabled - it should be anyway. */
	vPortEnableVFP();

	/* Lazy save always. */
	*( portFPCCR ) |= portASPEN_AND_LSPEN_BITS;

	/* Start the first task. */
	prvPortStartFirstTask();

	/* Should never get here as the tasks will now be executing!  Call the task
	exit error function to prevent compiler warnings about a static function
	not being called in the case that the application writer overrides this
	functionality by defining configTASK_RETURN_ADDRESS.  Call
	vTaskSwitchContext() so link time optimisation does not remove the
	symbol. */
	vTaskSwitchContext();
	prvTaskExitError();

	/* Should not get here! */
	return 0;
}
```
### 使能FPU函数
函数 xPortStartScheduler()中会通过调用 prvEnableVFP()来使能FPU,这个函数是汇编形式的,在文件port.c中定义
```c
__asm void prvEnableVFP( void )  
{  
	PRESERVE8  
  
	ldr.w r0, =0xE000ED88 ;R0=0XE000ED88 				
	ldr r1, [r0] ;从 R0 的地址读取数据赋给 R1 			   

	orr r1, r1, #( 0xf << 20 ) ;R1=R1|(0xf<<20) 		  
	str r1, [r0] ;R1 中的值写入 R0 保存的地址中 			  
	bx r14 (5)  
	nop  
}
```
利用寄存器CPACR可以使能或者禁止FPU,此寄存器的地址0XE000ED88,此寄存器的 `CP10(bit20 和 bit21)`和 `CP11(bit22  
和 bit23)`用于控制FPU

### 启动第一个任务
函数prvStartFirstTask()用于启动第一个任务,这是一个汇编代码.函数源码如下
```c
__asm void prvStartFirstTask( void )
{
	PRESERVE8  

	ldr r0, =0xE000ED08 ;R0=0XE000ED08 
	ldr r0, [r0] ;取 R0 所保存的地址处的值赋给 R0 
	ldr r0, [r0] ;获取 MSP 初始值 

	msr msp, r0 ;复位 MSP 
	cpsie I ;使能中断(清除 PRIMASK) 
	cpsie f ;使能中断(清除 FAULTMASK) 
	dsb ;数据同步屏障 
	isb ;指令同步屏障 

	svc 0 ;触发 SVC 中断(异常)
	nop  
	nop
}
```

### SVC 中断服务函数
在函数`prvStartFirstTask()`中通过调用 SVC 指令触发了 SVC 中断，而第一个任务的启动就是在 SVC 中断服务函数中完成的，SVC 中断服务函数应该为`SVC_Handler()`，但是  FreeRTOSConfig.h 中通过#define 的方式重新定义为了`xPortPendSVHandler()`
```c
#define xPortPendSVHandler PendSV_Handler
```
函数 vPortSVCHandler()在文件 port.c 中定义，这个函数也是用汇编写的
```c
__asm void vPortSVCHandler( void )
{
	PRESERVE8  

	ldr r3, =pxCurrentTCB ;R3=pxCurrentTCB 的地址 
	ldr r1, [r3] ;取 R3 所保存的地址处的值赋给 R1
	ldr r0, [r1] ;取 R1 所保存的地址处的值赋给 R0

	ldmia r0!, {r4-r11, r14} ;出栈 ，R4~R11 和 R14 
	msr psp, r0 ;进程栈指针 PSP 设置为任务的堆栈 
	isb ;指令同步屏障  
	mov r0, #0 ;R0=0 
	msr basepri, r0 ;寄存器 basepri=0，开启中断 
	bx r14
}
```

### 空闲任务
此函数会创建一个名为“IDLE”的任务，这个任务叫做空闲任务。顾名思义，空闲任务就是空闲的时候运行的任务，也就是系统中其他的任务由于各种原因不能运行的时候空闲任务就在运行。空闲任务是 FreeRTOS 系统自动创建的，不需要用户手动创建。任务调度器启动以后就必须有一个任务运行！但是空闲任务不仅仅是为了满足任务调度器启动以后至少有一个任务运行而创建的，空闲任务中还会去做一些其他的事情
例如：
1. 判断系统是否有任务删除，如果有的话就在空闲任务中释放被删除任务的任务堆栈和任  
务控制块的内存。
2. 运行用户设置的空闲任务钩子函数。
3. 判断是否开启低功耗 tickless 模式，如果开启的话还需要做相应的处理
	空闲任务的任务优先级是最低的，为 0，任务函数为 prvIdleTask()

