# FreeRTOS优先级反转
在使用二值信号量的时候会遇到很常见的一个问题——优先级翻转，优先级翻转在可剥夺内核中是非常常见的，在实时系统中不允许出现这种现象，这样会破坏任务的预期顺序，可能会导致严重的后果。

![[Pasted image 20210717050659.png]]

低优先级的任务占用信号量，高优先级的任务申请信号量不成功，导致低于高优先级的任务能够抢先运行，就好象优先级发生了反转
例如Task1,Task2，Task3的优先级依次增加
```c
// 任务1
void Task1_Function(void *argu){

	uint32_t time = 0;
	for(;;){
		/* 获取信号量 */
		xQueueSemaphoreTake(BinarySemaphore,portMAX_DELAY);
		printf("Low Task running \n");

		// 模拟地优先级占用信号量
		for (time = 0; time<20000000; time++) {

			 taskYIELD()  // 任务调度
		}
		
		xSemaphoreGive(BinarySemaphore);
		vTaskDelay(1000);
	}
}

// 任务2
void Task2_Function(void *argu){

	for(;;){
		printf("Middle Task running \n");
		osDelay(1000);
	}
}


// 任务3 优先级最高
void Task3_Function(void *argu){

	for(;;){
		osDelay(1000);
		xQueueSemaphoreTake(BinarySemaphore,portMAX_DELAY);
		printf("High Task running \n");
		xSemaphoreGive(BinarySemaphore);
	}
	
}
```
这样就会导致Middle任务和High任务在一段时间内的优先级发生反转

