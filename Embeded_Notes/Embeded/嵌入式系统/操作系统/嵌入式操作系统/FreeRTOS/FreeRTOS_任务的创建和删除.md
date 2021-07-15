# FreeRTOS任务的创建和删除
## 任务创建和删除的API函数
任务创建和删除的本质是调用FreeRTOS的API函数，位于task.c和task.h中

| 函数                    | 描述                                                       |
| ----------------------- | ---------------------------------------------------------- |
| xTaskCreate()           | 使用动态的方法创建一个任务                                 |
| xTaskCreateStatic()     | 使用静态的方法创建一个任务(参数需要用户自己提供)           |
| xTaskCreateRestricted() | 创建一个使用MPU进行限制的任务</br>相关内容使用动态内存分配 |
| xTaskDelete()           | 删除一个任务                                               | 

任务的创建方法有三种，删除的方法有一种

### 任务的创建（动态方法）
#### 动态创建任务
```c
BaseType_t xTaskCreate(	TaskFunction_t pxTaskCode,
						const char * const pcName,
						const uint16_t usStackDepth,
						void * const pvParameters,
						UBaseType_t uxPriority,
						TaskHandle_t * const pxCreatedTask)
```
参数：
+ pxTaskCode：任务函数。
+ pcName：任务名字，一般用于追踪和调试，任务名字长度不能超过。configMAX_TASK_NAME_LEN。
+ usStackDepth：任务堆栈大小，注意实际申请到的堆栈是usStackDepth的4倍。其中空闲任务的任务堆栈大小为configMINIMAL_STACK_SIZE。
+ pvParameters:传递给任务函数的参数。
+ uxPriotiry:任务优先级，范围0~configMAX_PRIORITIES-1。
+ pxCreatedTask: 任务句柄，任务创建成功以后会返回此任务的任务句柄，这个句柄其实就是任务的任务堆栈。此参数就用来保存这个任务句柄。其他API函数可能会使用到这个句柄。
返回值：
+ pdPASS:任务创建成功。
+ errCOULD_NOT_ALLOCATE_REQUIRED_MEMORY：任务创建失败，因为堆内存不足！

#### 静态创建任务
```c
TaskHandle_t xTaskCreateStatic(	TaskFunction_t pxTaskCode,
								const char * const pcName,
								const uint32_t ulStackDepth,
								void * const pvParameters,
								UBaseType_t uxPriority,
								StackType_t * const puxStackBuffer,
								StaticTask_t * const pxTaskBuffer)
```
参数：
+ pxTaskCode：任务函数。
+ pcName：任务名字，一般用于追踪和调试，任务名字长度不能超过。configMAX_TASK_NAME_LEN。
+ usStackDepth：任务堆栈大小，由于本函数是静态方法创建任务，所以任务堆栈由用户给出，一般是个数组，此参数就是这个数组的大小。
+ pvParameters:传递给任务函数的参数。
+ uxPriotiry:任务优先级，范围0~configMAX_PRIORITIES-1。
+ puxStackBuffer:任务堆栈，一般为数组，数组类型要为StackType_t类型。
+ pxTaskBuffer:任务控制块。

返回值：
+ NULL：任务创建失败，`puxStackBuffer`或`pxTaskBuffer`为NULL的时候会导致这个错误的发生。
+ 其他值：创建成功

#### 任务删除
```c
vTaskDelete( TaskHandle_t xTaskToDelete );
```
参数：
xTaskToDelete:要删除的任务的任务句柄。
返回值：
None

## 过程
基本使用的就是`xTaskCreate()`和`vTaskDelete()`(动态方法)
### 动态方法
动态创建基本就三个过程：
1. 创建函数声明
2. 设置堆栈
3. 设置任务优先级
4. 定义任务句柄(TaskHandle_t)
5. 用xTaskCreate()函数创建任务
6. 主函数调用开始函数
7. 开启任务调度器`vTaskStartScheduler();`

开始任务创建任务之后将自身删除，使用`vTaskDelete()`
程序
1. 搭建框架
2. 实现具体内容，测试框架是否正常


### 静态方法
1. 改宏，使能静态创建
2. 编译可能会有两个函数未定义
	1. vApplicationGetIdleTaskMemory()，给空闲任务定义堆栈、TCB和堆栈大小
	2. vApplicationGetTimerTaskMemory()，给定时器任务定义堆栈、TCB和堆栈大小
3. 编写测试代码
4. 创建开始任务框架
5. 创建任务框架
6. 测试代码

不同点在于需要用户自定义句柄、和TCB
