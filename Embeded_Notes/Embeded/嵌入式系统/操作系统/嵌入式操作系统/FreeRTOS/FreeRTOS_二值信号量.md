---
date updated: '2021-10-03T09:07:56+08:00'

---

# FreeRTOS信号量

## 使用信号量的目的

- 共享资源的访问
- 与任务同步

## FreeRTOS中信号量的集中分类

1. 二值信号量
2. 计数型信号量
3. 互斥信号量
4. 递归互斥信号量

### 二值信号量

二值信号量与互斥信号量相似，但是互斥信号量拥有优先级继承机制，而二值信号量没有优先级继承。因此二值信号量更适合用于**同步(任务与任务、任务与中断)**，而互斥信号量适用于简单的互斥访问、

二值信号量其实是一个只有一个队列项的队列，这个队列要么是满的，要么是空的。任务和中断使用这个特殊的队列不在乎队列中存的是什么，只需要知道这个队列是满的还是空的。可以利用这个机制来完成任务与中断之间的同步。

在实际应用中通常会使用一个任务去处理MCU的某个外设，当有信号时就进行怎样的操作，这样的轮询方式很浪费CPU资源，也阻止了其他任务的运行。最理想的方法就是在外设没有信号时就将任务阻塞掉，把CPU让给其他的任务运行。
使用二值信号量就可以完成这样的一个功能

#### 原理性步骤

**二值信号量无效**

```mermaid
	graph LR;
	Semaphone --> Task
```

任务通过函数`xSemaphoreTake()`获取信号量，但是此时二值信号量无效，所以Task进入阻塞态

---

**中断释放信号量**

```mermaid
	graph LR;
	Interrupt--xSemaphoreGiveFromISR函数--> Semaphore-->Task
```

---

**任务获取信号量成功**
由于信号量已经有效了，所以任务获取信号量成功，任务从阻塞态解除，开始执行相关的处理过程。

---

**任务再次进入阻塞态**
由于任务函数一般都是一个大循环，所以在任务做完相关的处理以后就会再次调用函数xSemaphoreTake()获取信号量。在执行完第三步以后二值信号量就已经变为无效的了，所以任务将再次进入阻塞态，和第一步一样，直至中断再次发生并且调用函数 `xSemaphoreGiveFromISR()`释放信号量。

---

## API函数

### 创建二值信号量

| 函数                             | 描述             |
| ------------------------------ | -------------- |
| vSemaphoreCreateBinary ()      | 动态创建二值信号量(老版本) |
| xSemaphoreCreateBinary()       | 动态创建二值信号量(新版本) |
| xSemaphoreCreateBinaryStatic() | 静态创建二值信号量      |

### 释放信号量

| 函数                      | 描述         |
| ----------------------- | ---------- |
| xSemaphoreGive()        | 任务级信号量释放函数 |
| xSemaphoreGiveFromISR() | 中断级信号量释放函数 |

### 获取信号量

| 函数                      | 描述         |
| ----------------------- | ---------- |
| xSemaphoreTake()        | 任务级获取信号量函数 |
| xSemaphoreTakeFromISR() | 中断级获取信号量函数 |

---

## 创建信号量

### vSemaphoreCreateBinary ()

老版本FreeRTOS中创建二值信号函数，新版本已经基本不用了，新版本使用`xSemaphoreCreateBinary()`来替代此函数，这里还保留这个函数是为了兼容那些基于老版本FreeRTOS而做的应用层代码。

```c
void vSemaphoreCreateBinary( SemaphoreHandle_t xSemaphore )
```

参数：

- xSemaphore：保存创建成功的二值信号量句柄

返回值：

- NULL：二值信号量创建失败
- 其他值：二值信号量创建成功

### xSemaphoreCreateBinary()

使用此函数创建二值信号量的话信号量所需要的 RAM 是由 FreeRTOS 的内存管理部分来动态分配的。此函数创建好的二值信号量默认是空的，也就是说**刚创建好的二值信号量使用函数xSemaphoreTake()是获取不到的**
此函数也是个宏，具体的创建过程是由函数xQueueGenericCreate()来完成的。

```c
SemaphoreHandle_t  xSemaphoreCreateBinary( void )
```

参数：

- 无

返回值：

- NULL：二值信号量创建失败
- 其他值：创建成功的二值信号量的句柄

### xSemaphoreCreateBinaryStatic()

此函数也是创建二值信号量的，只不过使用此函数创建二值信号量的话信号量所需要的RAM 需要由用户来分配，此函数也是个宏，具体创建过程通过函数`xQueueGenericCreateStatic()`来完成

```c
SemaphoreHandle_t xSemaphoreCreateBinaryStatic( StaticSemaphore_t *pxSemaphoreBuffer )
```

参数：

- pxSemaphoreBuffer：此参数指向一个 StaticSemaphore_t 类型的变量，用来保存信号量结构体。

返回值：

- NULL：二值信号量创建失败
- 其他值：创建成功的二值信号量句柄。

### 二值信号量的创建过程

老版本的二值信号量创建

```c
#if( configSUPPORT_DYNAMIC_ALLOCATION == 1 )
#define vSemaphoreCreateBinary( xSemaphore ) 				\  
{ 															\  
	( xSemaphore ) = xQueueGenericCreate( ( UBaseType_t ) 1,\ (1)  
	semSEMAPHORE_QUEUE_ITEM_LENGTH, 						\  
	queueQUEUE_TYPE_BINARY_SEMAPHORE ); 					\  
	if( ( xSemaphore ) != NULL ) 							\  
	{ 														\  
		( void ) xSemaphoreGive( ( xSemaphore ) ); 			\ (2)  
	} 														\  
}  
#endif
```

(1)二值信号量实在队列的基础上实现的，所以创建二值信号量就是创建队列的过程这里使用函数 `xQueueGenericCreate()` 创建了一个队列，队列长度为 1，队列项长度为 0，队列类型为 `queueQUEUE_TYPE_BINARY_SEMAPHORE`\
(2)当二值信号量创建成功以后立即调用函数 xSemaphoreGive()释放二值信号量，此时新创建的二值信号量有效

新版本的二值信号量创建

```c
#if( configSUPPORT_DYNAMIC_ALLOCATION == 1 )
	#define  xSemaphoreCreateBinary()				\
		xQueueGenericCreate( ( UBaseType_t ) 1,		\
		semSEMAPHORE_QUEUE_ITEM_LENGTH,				\
		queueQUEUE_TYPE_BINARY_SEMAPHORE )			\
#endif
```

新版本的二值信号量创建函数也是使用函数 xQueueGenericCreate()来创建一个类型为 queueQUEUE_TYPE_BINARY_SEMAPHORE、长度为 1、队列项长度为 0 的队列。这一步和老版本的二值信号量创建函数一样，唯一不同的就是新版本的函数在成功创建二值信号量以后不会立即调用函数 xSemaphoreGive()释放二值信号量，也就是说新版函数创建的二值信号量默认是无效的，而老版本是有效的

创建的队列是一个没有存储区的队列，使用队列是否为空来表示二值\
信号量，而队列是否为空可以通过队列结构体的成员变量`uxMessagesWaiting` 来判断

## 释放信号量

同队列一样，释放信号量也分为任务级和中断级。不管是二值信号量、计数型信号量还是互斥信号量，都用上面API中的函数释放信号量，递归互斥信号量有专门的释放函数

### xSemaphoreGive()

此函数用于释放二值信号量、计数型信号量或互斥信号量，此函数是一个宏，真正释放信号量的过程是由函数 xQueueGenericSend()来完成的

```c
#define xSemaphoreGive( xSemaphore ) 						\
	xQueueGenericSend( ( QueueHandle_t ) ( xSemaphore ), 	\
	NULL, 													\
	semGIVE_BLOCK_TIME, 									\  
	queueSEND_TO_BACK ) 									\
```

参数：

- xSemaphore：要释放的信号量句柄。

返回值：

- pdPASS:  释放信号量成功。
- errQUEUE_FULL: 释放信号量失败。

释放信号量就是向队列发送消息的过程，只是这里并没有发送具体的消息\
阻塞时间为 0(宏 semGIVE_BLOCK_TIME 为 0)，入队方式采用的后向入队。

### xSemaphoreGiveFromISR()

此函数用于在中断中释放信号量，此函数只能用来释放二值信号量和计数型信号量，不可以用来在中断服务函数中释放互斥信号量\
此函数是一个宏，真正执行的是函数xQueueGiveFromISR(),此函数原型如下：

```c
BaseType_t xSemaphoreGiveFromISR( SemaphoreHandle_t xSemaphore, BaseType_t * pxHigherPriorityTaskWoken)
```

参数：

- xSemaphore： 要释放的信号量句柄。
- pxHigherPriorityTaskWoken： 标记退出此函数以后是否进行任务切换，这个变量的值由这三个函数来设置的，用户不用进行设置，用户只需要提供一个变量来保存这个值就行了。当此值为 pdTRUE 的时候在退出中断服务函数之前一定要进行一次任务切换。

返回值：

- pdPASS:  释放信号量成功。
- errQUEUE_FULL: 释放信号量失败。

在中断中释放信号量真正使用的是函数 `xQueueGiveFromISR()`

## 获取信号量

不管是二值信号量、计数型信号量还是互斥信号量都使用的是API中的函数

### xSemaphoreTake()

此函数用于获取二值信号量、计数型信号量或互斥信号量，此函数是一个宏，真正获取信号量的过程是由函数 `xQueueGenericReceive()` 来完成的。

```c
#define xSemaphoreTake( xSemaphore, xBlockTime ) 		\  
xQueueGenericReceive( ( QueueHandle_t ) ( xSemaphore ), \  
					NULL, 								\
					( xBlockTime ), 					\  
					pdFALSE ) 							\
```

参数：

- xSemaphore：要获取的信号量句柄。
- xBlockTime:  阻塞时间。

返回值：

- pdTRUE: 获取信号量成功。
- pdFALSE:  超时，获取信号量失败。

获取信号量的过程其实就是读取队列的过程，只是这里并不是为了读取队列中的消息

### xSemaphoreTakeFromISR()

用于在中断服务函数中获取信号量，此函数用于获取二值信号量和计数型信号量，绝对不能使用此函数来获取互斥信号量。
此函数是一个红，真正执行的是函数`xQueueReceiveFromISR()`

```c
BaseType_t xSemaphoreTakeFromISR(SemaphoreHandle_t xSemaphore, BaseType_t * pxHigherPriorityTaskWoken)
```

参数：

- xSemaphore： 要获取的信号量句柄。
- pxHigherPriorityTaskWoken： 标记退出此函数以后是否进行任务切换，这个变量的值由这三个函数来设置的，用户不用进行设置，用户只需要提供一个变量来保存这个值就行了。当此值为 pdTRUE 的时候在退出中断服务函数之前一定要进行一次任务切换。

返回值

- pdPASS: 获取信号量成功。
- pdFALSE: 获取信号量失败

在中断中获取信号量真正使用的是函数 xQueueReceiveFromISR ()，这个函数就是中断级出队函数，当队列不为空的时候就拷贝队列中的数据(用于信号量的时候不需要这一步)，然后将队列结构体中的成员变量uxMessagesWaiting减1。如果有任务因为入队而阻塞的话就解除阻塞态，当解除阻塞的任务拥有更高优先级的话就将参数 pxHigherPriorityTaskWoken 设置为pdTRUE，最后返回 pdPASS 表示出队成功。如果队列为空的话就直接返回 pdFAIL 表示出队失败
