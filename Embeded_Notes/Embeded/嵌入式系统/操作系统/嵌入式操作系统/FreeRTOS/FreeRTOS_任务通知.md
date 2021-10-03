---
date updated: '2021-10-03T09:08:50+08:00'

---

# FreeRTOS任务通知

从vv8.2.0 版本开始，FreeRTOS新增了任务通知这个功能，可以使用任务通知代替信号量、消息队列、事件标志组等这些东西
**使用任务通知效率会更高**

## 简介

任务通知在FreeRTOS中是一个可选的功能，要使用任务通知的话就将宏`configUSE_TASK_NOTIFICATIONS`定义为1
FreeRTOS 的每个任务都有一个 32 位的通知值，任务控制块中的成员变量 `ulNotifiedValue` 就是这个通知值。

任务通知是一个事件，假如某个任务通知的接收任务因为等待任务通知而阻\
塞的话，向这个接收任务发送任务通知以后就会解除这个任务的阻塞状态，也可以更新接收任务的任务通知值，任务通知可以通过如下方法更新接收任务的通知值

- 不覆盖接收任务的通知值
- 覆盖接收任务的通知值。
- 更新接收任务通知值的一个或多个 bit
- 增加接收任务的通知值

合理使用这些通知值的方法可以在一些场合中替代队列、二值信号量、计数型信号量和事件标志组。
使用任务通知来实现二值信号量功能的时候，解除任务阻塞的时间比直接使用二值信号量要快45%，并且使用的RAM更少

任务通知的发送使用函数`xTaskNotify()`或者`xTaskNotifyGive()`来完成，这个通知值会一直被保存着，直到接收任务调用函数 `xTaskNotifyWait()`或者`ulTaskNotifyTake()`来获取这个通知值。
如接收任务因为等待任务通知而阻塞的话那么在接收到任务通知以后就会解除阻塞态。

任务通知虽然可以提高速度，并且减少 RAM 的使用，但是任务通知也是有使用限制的

- FreeRTOS 的任务通知只能有一个接收任务，其实大多数的应用都是这种情况
- 任务可以因为接收任务通知而进入阻塞态，但是发送任务不会因为任务通知发送失败而阻塞。

## 发送任务通知

| 函数                           | 描述                                             |   |
| ---------------------------- | ---------------------------------------------- | - |
| xTaskNotify()                | 发送通知，带有通知之并且不保留接受任务原通知值，用在任务中                  |   |
| xTaskNotifyFromISR()         | 发送通知，函数 xTaskNotify()的中断版本。                    |   |
| xTaskNotifyGive()            | 发送通知，不带通知值并且不保留接收任务的通知值，此函数会将接收任务的通知值加一，用于任务中。 |   |
| vTaskNotifyGiveFromISR()     | 发送通知，函数 xTaskNotifyGive()的中断版本。                |   |
| xTaskNotifyAndQuery()        | 发送通知，带有通知值并且保留接收任务的原通知值，用在任务中。                 |   |
| xTaskNotiryAndQueryFromISR() | 发送通知，函数 xTaskNotifyAndQuery()的中断版本，用在中断服务函数中。  |   |

### xTaskNotify()

此函数用于发送任务通知，此函数发送任务通知的时候带有通知值，此函数是个宏，真正执行的函数 xTaskGenericNotify()

```c
BaseType_t xTaskNotify( TaskHandle_t xTaskToNotify, 
						uint32_tulValue,
						eNotifyAction eAction)
```

参数：

- xTaskToNotify：  任务句柄，指定任务通知是发送给哪个任务的。
- ulValue： 任务通知值。
- eAction：  任务通知更新的方法

eNotifyAction 是个枚举类型，在文件 task.h 中有定义

```c
typedef enum{
	eNoAction = 0,
	eSetBits, 					// 更新指定的 bit
	eIncrement, 				// 通知值加一
	eSetValueWithOverwrite, 	// 覆写的方式更新通知值
	eSetValueWithoutOverwrite 	// 不覆写通知值
} eNotifyAction;
```

此参数可以选择枚举类型中的任意一个，不同的应用环境其选择也不同。
返回值：

- pdFAIL: 当参数 eAction 设置为 eSetValueWithoutOverwrite 的时候，如果任务通知值没有更新成功就返回 pdFAIL
- pdPASS:  eAction 设置为其他选项的时候统一返回 pdPASS

### xTaskNotifyFromISR()

此函数用于发送任务通知，是函数 xTaskNotify()的中断版本
此函数也是个宏

```c
BaseType_t xTaskNotifyFromISR( TaskHandle_t xTaskToNotify, 					
								uint32_t ulValue,eNotifyAction eAction,  
								BaseType_t * pxHigherPriorityTaskWoken );
```

参数：

- xTaskToNotify：  任务句柄，指定任务通知是发送给哪个任务的。
- ulValue： 任务通知值。
- eAction：任务通知更新的方法。
- pxHigherPriorityTaskWoken:  记退出此函数以后是否进行任务切换，这个变量的值函数会自动设置的，用户不用进行设置，用户只需要提供一个变量来保存这个值就行了。当此值为 pdTRUE 的时候在退出中断服务函数之前一定要进行一次任务切换。

返回值：

- pdFAIL:  当参数 eAction 设置为 eSetValueWithoutOverwrite 的时候，如果任务通知值没有更新成功就返回 pdFAIL。
- pdPASS:  eAction 设置为其他选项的时候统一返回 pdPASS。

### xTaskNotifyGive()

发送任务通知，相对于函数 xTaskNotify()，此函数发送任务通知的时候不带有通知值。
此函数只是将任务通知值简单的加一
此函数是个宏，真正执行的是函数 `xTaskGenericNotify()`

```c
BaseType_t xTaskNotifyGive( TaskHandle_t xTaskToNotify );
```

参数：

- xTaskToNotify：  任务句柄，指定任务通知是发送给哪个任务的。

返回值：

- pdPASS:  此函数只会返回 pdPASS。

### vTaskNotifyGiveFromISR()

xTaskNotifyGive()的中断版本，用在中断服务函数中

```c
void vTaskNotifyGiveFromISR( TaskHandle_t xTaskHandle,  		
							 BaseType_t * pxHigherPriorityTaskWoken
```

参数：

- xTaskToNotify：  任务句柄，指定任务通知是发送给哪个任务的。
- pxHigherPriorityTaskWoken:  记退出此函数以后是否进行任务切换，这个变量的值函数会自动设置的，用户不用进行设置，用户只需要提供一个变量来保存这个值就行了。当此值为 pdTRUE 的时候在退出中断服务函数之前一定要进行一次任务切换。

返回值：无

### xTaskNotifyAndQuery()

此函数和 `xTaskNotify()` 很类似，此函数比 xTaskNotify()多一个参数，此参数用来保存更新前的通知值。此函数是个宏，真正执行的是函数 `xTaskGenericNotify()`

```c
BaseType_t xTaskNotifyAndQuery ( TaskHandle_t xTaskToNotify, 
								 uint32_t ulValue,eNotifyAction eAction  
								 uint32_t * pulPreviousNotificationValue);
```

参数：

- xTaskToNotify： 任务句柄，指定任务通知是发送给哪个任务的。
- ulValue： 任务通知值。
- eAction：  任务通知更新的方法。
- pulPreviousNotificationValue：用来保存更新前的任务通知值。

返回值:

- pdFAIL:  当参数 eAction 设置为 `eSetValueWithoutOverwrite` 的时候，如果任务通知值没有更新成功就返回 pdFAIL。
- pdPASS:  eAction 设置为其他选项的时候统一返回 pdPASS

### xTaskNotifyAndQueryFromISR

xTaskNorityAndQuery()的中断版本，用在中断服务函数中。此函数同样为宏，真正执行的是函数 xTaskGenericNotifyFromISR()

```c
BaseType_t xTaskNotifyAndQueryFromISR ( TaskHandle_t 
										xTaskToNotify, uint32_t ulValue,eNotifyAction eAction,  
										uint32_t * pulPreviousNotificationValue  
										BaseType_t * pxHigherPriorityTaskWoken );
```

参数：

- xTaskToNotify：  任务句柄，指定任务通知是发送给哪个任务的。
- ulValue： 任务通知值。
- eAction： 任务通知更新的方法。
- pulPreviousNotificationValue：用来保存更新前的任务通知值。pxHigherPriorityTaskWoken: 记退出此函数以后是否进行任务切换，这个变量的值函数会自动设置的，用户不用进行设置，用户只需要提供一个变量来保存这个值就行了。当此值为 pdTRUE 的时候在退出中断服务函数之前一定要进行一次任务切换。

返回值：

- pdFAIL:  当参数 eAction 设置为 eSetValueWithoutOverwrite 的时候，如果任务通知值没有更新成功就返回 pdFAIL。
- pdPASS:  eAction 设置为其他选项的时候统一返回 pdPASS

## 获取任务通知

| 函数                 | 描述                                                                  |
| ------------------ | ------------------------------------------------------------------- |
| ulTaskNotifyTake() | 获取任务通知，可以设置在退出此函数的时候将任务通知值清零或者减一。当任务通知用作二值信号量或者计数信号量的时候使用此函数来获取信号量。 |
| xTaskNotifyWait()  | 等待任务通知，比 ulTaskNotifyTak()更为强大，全功能版任务通知获取函数。                        |

### ulTaskNotifyTake()

此函数为获取任务通知函数，当任务通知用作二值信号量或者计数型信号量的时候可以使用此函数来获取信号量

```c
uint32_t ulTaskNotifyTake( BaseType_t xClearCountOnExit, 
						   TickType_t xTicksToWait );
```

参数：

- xClearCountOnExit：  参数为 pdFALSE 的话在退出函数 ulTaskNotifyTake()的时候任务通知值减一，类似计数型信号量。当此参数为 pdTRUE 的话在退出函数的时候任务任务通知值清零，类似二值信号量。
- xTickToWait: 阻塞时间

返回值：

- 任何值 ： 任务通知值减少或者清零之前的值。

### xTaskNotifyWait()

也是用来获取任务通知的，不过此函数比 ulTaskNotifyTake()更为强大，不管任务通知用作二值信号量、计数型信号量、队列和事件标志组中的哪一种，都可以使用此函数来获取任务通知。但是当任务通知用作位置信号量和计数型信号量的时候推荐使用函`ulTaskNotifyTake()``。

```c
BaseType_t xTaskNotifyWait( uint32_t ulBitsToClearOnEntry,
							uint32_t ulBitsToClearOnExit,   
							uint32_t * pulNotificationValue,
							TickType_t xTicksToWait );
```

参数：

- ulBitsToClearOnEntry：当没有接收到任务通知的时候将任务通知值与此参数的取反值进行按位与运算，当此参数为 0xffffffff 或者 ULONG_MAX 的时候就会将任务通知值清零。
- ulBitsToClearOnExit：如果接收到了任务通知，在做完相应的处理退出函数之前将任务通知值与此参数的取反值进行按位与运算， 当此参数为 0xffffffff 或者ULONG_MAX 的时候就会将任务通知值清零。
- pulNotificationValue：此参数用来保存任务通知值。
- xTickToWait: 阻塞时间。

返回值：

- pdTRUE： 获取到了任务通知。
- pdFALSE：  任务通知获取失败。
