# FreeRTOS队列
在实际应用中会遇到一个任务或者中断服务需要和另一个任务进行“沟通交流”，这个“沟通交流”的过程其实就是消息传递的过程。在没有操作系统的时候两个应用程序进行消息传递一般使用**全局变量**的方式，但是如果在使用操作系统的应用中用全局变量来传递消息就会涉及到“**资源管理**”的问题。

## 队列简介
队列是为了**任务与任务**、**任务与中断之间**的通信而准备的
可以在**任务与任务**、**任务与中断之间**传递消息，队列中可以存储**有限**的、**大小固定**的数据项目。
**任务与任务、任务与中断之间要交流的数据保存在队列中，叫做队列项目**。队列所能保存的最大数据项目数量叫做队列的长度，创建队列的时候会指定数据项目的大小和队列的长度。
由于队列用来传递消息的，所以也称为消息队列。
FreeRTOS 中的信号量的也是依据队列实现的


### 数据结构
#### FIFO类型
通常队列采用先进先出(FIFO)的存储缓冲机制，也就是往队列发送数据的时候(也叫入队)永远都是发送到队列的尾部，而从队列提取数据的时候(也叫出队)是从队列的头部提取的。
#### LIFO
但是也可以使用 LIFO 的存储缓冲，也就是**后进先出**，FreeRTOS 中的队列也提供了 LIFO 的存储缓冲机制，类似于栈

#### 传值方式
数据发送到队列中会导致数据拷贝，也就是将要发送的数据拷贝到队列中，这就意味着在队列中存储的是数据的原始值，而不是原数据的引用(即只传递数据的指针)，这个也叫做值传递。
UCOS 的消息队列采用的是引用传递，传递的是消息指针。采用引用传递的话消息内容就必须一直保持可见性，也就是消息内容必须有效，那么局部变量这种可能会随时被删掉的东西就不能用来传递消息，但是采用引用传递会节省时间，因为不用进行数据拷贝。

采用值传递的话虽然会导致数据拷贝，会浪费一点时间，但是一旦将消息发送到队列中原始的数据缓冲区就可以删除掉或者覆写，这样的话这些缓冲区就可以被重复的使用。

FreeRTOS中使用队列传递消息的话虽然使用的是数据拷贝，但是也可以使用引用来传递消息，直接往队列中发送指向这个消息的地址指针就可以了。
这样当我要发送的消息数据太大的时候就可以直接发送消息缓冲区的地址指针，比如在网络应用环境中，网络的数据量往往都很大的，采用数据拷贝的话就不现实。

### 多任务访问
队列不是属于某个特别指定的任务的，任何任务都可以向队列中发送消息，或者从队列中提取消息。

### 出队阻塞
当任务尝试从一个队列中读取消息的时候可以指定一个阻塞时间，这个阻塞时间就是当任务从队列中读取消息无效的时候任务阻塞的时间。
**出队就是就从队列中读取消息，出队阻塞是针对从队列中读取消息的任务而言的。**

例如：
任务 A 用于处理串口接收到的数据，串口接收到数据以后就会放到队列 Q 中，任务 A 从队列 Q 中读取数据。如果此时Q是空的，说明还没有数据，任务A这个时候读取是获取不到数据的。
此时任务A有三种处理方式：
+ 不等待
+ 等待一定时间
+ 一直阻塞等待下去

这三中情况由**阻塞时间**决定，这个阻塞时间单位是时钟节拍数。
+ 阻塞时间为 0 的话就是不阻塞，没有数据的话就马上返回任务继续执行接下来的代码，对应第一种选择。
+ 如果阻塞时间为 `0~ portMAX_DELAY` ，当任务没有从队列中获取到消息的话就进入阻塞态，阻塞时间指定了任务进入阻塞态的时间，当阻塞时间到了以后还没有接收到数据的话就退出阻塞态，返回任务接着运行下面的代码，如果在阻塞时间内接收到了数据就立即返回，执行任务中下面的代码，这种情况对应第二种选择。
+ 当阻塞时间设置为 `portMAX_DELAY` 的话，任务就会一直进入阻塞态等待，直到接收到数据为止

### 入队阻塞
入队说的是向队列中发送消息，将消息加入到队列中。
和出队阻塞一样，当一个任务向队  
列发送消息的话也可以设置阻塞时间。
比如任务 B 向消息队列 Q 发送消息，但是此时队列 Q 是满的，那肯定是发送失败的。此时任务 B 就会遇到和上面任务 A 一样的问题，这两种情况的处理过程是类似的，只不过一个是向队列 Q 发送消息，一个是从队列 Q 读取消息而已。

## FreeRTOS队列
### 队列结构体
有一个结构体用于描述队列，叫做`Queue_t`，这个结构体在文件queue.c中定义
老版本的FreeRTOS中队列可能会之用xQUEUE这个名字，新版本中队列的名字都是用Queue_t
```c
typedef struct QueueDefinition 		
{
	int8_t *pcHead;											// 指向队列存储区的开始地址		
	int8_t *pcWriteTo;										// 指向存储区中下一个空白区域

	union
	{
		QueuePointers_t xQueue;								// 当用作队列的时候指向最后一个出队的队列项首地址
		SemaphoreData_t xSemaphore; 						// 当用作递归互斥量的时候用来记录递归互斥量被调用的次数
	} u;

	List_t xTasksWaitingToSend;								// 等待发送任务列表，那些因为队列满导致入队失败而进入阻塞态的任务就会挂到此列表上
	List_t xTasksWaitingToReceive;							// 等待接收任务列表，那些因为队列空导致出队失败而进入阻塞态的任务就会挂到此列表上。

	volatile UBaseType_t uxMessagesWaiting;					// 队列中当前队列项数量，也就是消息数
	UBaseType_t uxLength;									// 创建队列时指定的队列长度，也就是队列中最大允许的队列项(消息)数量
	UBaseType_t uxItemSize;									// 创建队列时指定的每个队列项(消息)最大长度，单位字节

	volatile int8_t cRxLock;								// 当队列上锁以后用来统计从队列中接收到的队列项数量，也就是出队的队列项数量，当队列没有上锁的话此字段为 queueUNLOCKED		
	volatile int8_t cTxLock;								// 当队列上锁以后用来统计发送到队列中的队列项数量，也就是入队的队列项数量，当队列没有上锁的话此字段为 queueUNLOCKED

	#if( ( configSUPPORT_STATIC_ALLOCATION == 1 ) && ( configSUPPORT_DYNAMIC_ALLOCATION == 1 ) )
		uint8_t ucStaticallyAllocated;						// 如果使用静态存储的话此字段设置为pdTURE
	#endif

	#if ( configUSE_QUEUE_SETS == 1 )						// 队列集相关宏
		struct QueueDefinition *pxQueueSetContainer;
	#endif

	#if ( configUSE_TRACE_FACILITY == 1 )					// 跟踪调试相关宏
		UBaseType_t uxQueueNumber;
		uint8_t ucQueueType;
	#endif

} xQUEUE;

typedef xQUEUE Queue_t;
```

### 队列的创建
有两种队列的创建方式，一种是静态的，一种是动态的
+ 静态创建队列：xQueueCreateStatic()
+ 动态创建队列：xQueueCreate()

这两个函数都是重定义的宏，真正完成创建的是`xQUEUEGenericCreate()`和`xQUEUEGenericCreateStatic()`，两个函数在queue.c中有定义

#### xQueueCreate()
用于动态创建队列，最终调用的是`xQueueGenericCreate()`函数
```c
QueueHandle_t xQueueCreate(UBaseType_t uxQueueLength, UBaseType_t uxItemSize)
```
参数：
+ uxQueueLength： 要创建的队列的队列长度，这里是队列的项目数
+ uxItemSize： 队列中每个项目(消息)的长度，单位为字节

返回值：
+ NULL：创建失败
+ 其他值：创建成功以后返回的句柄

#### xQueueCreateStatic()
用于静态创建队列，队列所需的内存由用户自行分配，本质上是一个宏，最终调用`xQueueGenericCreateStatic()`
```c
QueueHandle_t xQueueCreateStatic(UBaseType_t uxQueueLength,UBaseType_t uxItemSize,uint8_t * pucQueueStorageBuffer,StaticQueue_t * pxQueueBuffer)
```
参数：
+ uxQueueLength： 要创建的队列的队列长度，这里是队列的项目数
+ uxItemSize： 队列中每个项目(消息)的长度，单位为字节
+ pucQueueStorage: 指向队列项目的存储区，也就是消息的存储区，这个存储区需要用户自行分配。此参数必须指向一个 `uint8_t` 类型的数组。这个存储区要大于等  于(`uxQueueLength * uxItemsSize`)字节
+ pxQueueBuffer: 此参数指向一个 StaticQueue_t 类型的变量，用来保存队列结构体。

返回值：
+ NULL：队列创建失败
+ 其他值：队列创建成功后的队列句柄

#### xQueueGenericCreatexQueueGenericCreate()
用于动态创建队列，创建队列过程中需要的内存均通过 FreeRTOS 中的动态内存管理函数 pvPortMalloc()分配，函数原型如下
```c
QueueHandle_t  xQueueGenericCreate( const UBaseType_t uxQueueLength,const UBaseType_t uxItemSize,const uint8_t ucQueueType )
```
参数：
+ uxQueueLength： 要创建的队列的队列长度，这里是队列的项目数。
+ uxItemSize： 队列中每个项目(消息)的长度，单位为字节。
+ ucQueueType： 队列类型，由于 FreeRTOS 中的信号量等也是通过队列来实现的，创建信号量的函数最终也是使用此函数的，因此在创建的时候需要指定此队列的用途，也就是队列类型，一共有六种类型：
	+ queueQUEUE_TYPE_BASE：普通的消息队列
	+ queueQUEUE_TYPE_SET：队列集
	+ queueQUEUE_TYPE_MUTEX：互斥信号集
	+ queueQUEUE_TYPE_COUNTING_SEMAPHORE：计数型信号量
	+ queueQUEUE_TYPE_BINARY_SEMAPHORE：二值信号量
	+ queueQUEUE_TYPE_RECURSIVE_MUTEX：递归互斥信号量
	函数xQueueCreate()创建队列时默认选择的就是`queueQUEUE_TYPE_BASE`

返回值
+ NULL：队列创建失败
+ 其他值：创建成功句柄

#### xQueueGenericCreateStatic()
用于静态创建队列，创建队列过程中需要的内存需要用户自行分配，函数原型如下：
```c
QueueHandle_t xQueueGenericCreateStatic( const UBaseType_t uxQueueLength,
										const UBaseType_t uxItemSize,
										uint8_t * pucQueueStorage,
										StaticQueue_t * pxStaticQueue,
										const uint8_t ucQueueType )
```
参数：
+ uxQueueLength： 要创建的队列的队列长度，这里是队列的项目数。
+ uxItemSize： 队列中每个项目(消息)的长度，单位为字节
+ pucQueueStorage: 指向队列项目的存储区，也就是消息的存储区，这个存储区需要用户自行分配。
此参数必须指向一个 uint8_t 类型的数组。这个存储区要大于等于(uxQueueLength * uxItemsSize)字节。
+ pxStaticQueue: 此参数指向一个 StaticQueue_t 类型的变量，用来保存队列结构体。
+ ucQueueType： 队列类型，同上面的

返回值：
+ NULL：队列创建失败
+ 其他值：队列创捷成功以后队列句柄

#### 队列创建过程
```c
QueueHandle_t xQueueGenericCreate( 	const UBaseType_t uxQueueLength,
									const UBaseType_t uxItemSize,
									const uint8_t ucQueueType )
{
	Queue_t *pxNewQueue;  			// 新建队列结构体指针
	size_t xQueueSizeInBytes;  		// 创建变量用于存储队列空间大小
	uint8_t *pucQueueStorage;		// 用于存储队列的空间的指针
	
	configASSERT( uxQueueLength > ( UBaseType_t ) 0 ); // 判断是否队列长度是否大于0
													   // 如果传个负数直接返回
	if( uxItemSize == ( UBaseType_t ) 0 )   
	{  
		//队列项大小为 0，那么就不需要存储区，此时xQueueSizeInBytes为0
		xQueueSizeInBytes = ( size_t ) 0;  
	}
	else{
		// 分配足够的存储区，确保随时随地都可以保存所有的项目
		// 到这里还没有分配
		xQueueSizeInBytes = ( size_t ) ( uxQueueLength * uxItemSize );
	}
	// 开始分配
	pxNewQueue = ( Queue_t * ) pvPortMalloc( sizeof( Queue_t ) + xQueueSizeInBytes );
	// 如果内存申请成功
	if( pxNewQueue != NULL ){
		// 将队列部分的头地址传给这个指针
		pucQueueStorage = ( ( uint8_t * ) pxNewQueue ) + sizeof( Queue_t );
	}
	#if( configSUPPORT_STATIC_ALLOCATION == 1 ){
		//队列是使用动态方法创建的，所以队列字段 ucStaticallyAllocated 标记为 pdFALSE。
		pxNewQueue->ucStaticallyAllocated = pdFALSE;
	}
	#endif
	// 队列初始化
	prvInitialiseNewQueue( uxQueueLength, uxItemSize, pucQueueStorage,ucQueueType, pxNewQueue );
	return pxNEWQueue;
}
```

#### 队列初始化函数
队列初始化函数 `prvInitialiseNewQueue()` 用于队列的初始化，在queue.c中定义
```c
static void prvInitialiseNewQueue(  const UBaseType_t uxQueueLength,//队列长度
									const UBaseType_t uxItemSize, 	//队列项目长度
									uint8_t * pucQueueStorage, 		//队列项目存储区
									const uint8_t ucQueueType, 		//队列类型
									Queue_t * pxNewQueue ) 			//队列结构体		
```

#### 队列复位函数
队列初始化函数 `prvInitialiseNewQueue()` 中调用了函数 `xQueueGenericReset()` 来复位队列，在queue.c中定义
```c
BaseType_t xQueueGenericReset( QueueHandle_t xQueue, BaseType_t xNewQueue )
```

#### 队列创建成功
执行了上面的几个函数之后，队列也就创建成功了
例如创建了一个有四个队列项，每个队列项长度为32个字节的队列TestQueue,创建的队列如下：
![[Pasted image 20210716023530.png]]

### 向队列发送消息
创建好队列以后就可以向队列发送消息了，FreeRTOS 提供了 8 个向队列发送消息的 API 函数
![[Pasted image 20210716024035.png]]

#### xQueueSend()、xQueueSendToBack()和xQueueSendToFront()
这三个函数都是向队列中发送消息的，这三个函数本质上都是宏，其中函数 `xQueueSend()` 和 `xQueueSendToBack()`是一样的，都是后向入队，即将新的消息插入到队列的后面。函数 `xQueueSendToToFront()` 是前向入队，即将新消息插入到队列的前面。
然而这三个函数最后都调用的通过一个函数：`xQueueGenericSend()`。
这三个函数只能用于任务函数中，不能用于中断服务函数，中断服务函数有专用的函数，它们以`“FromISR”`结尾。
```c
BaseType_t xQueueSend( 		QueueHandle_t xQueue,
							const void * pvItemToQueue,
							TickType_t xTicksToWait);
BaseType_t xQueueSendToBack(QueueHandle_t xQueue,
							const void* pvItemToQueue,
							TickType_t xTicksToWait);
BaseType_t xQueueSendToToFront(QueueHandle_t xQueue,
							const void *pvItemToQueue,
							TickType_t xTicksToWait);
```
参数：
+ 队列句柄，指明要向哪个队列发送数据，创建队列成功以后会返回此队列的队列句柄。
+ pvItemToQueue：指向要发送的消息，发送时候会将这个消息拷贝到队列中。
+ xTicksToWait： 阻塞时间，此参数指示当队列满的时候任务进入阻塞态等待队列空闲的最大时间。如果为 0 的话当队列满的时候就立即返回；当为 portMAX_DELAY 的  话就会一直等待，直到队列有空闲的队列 项，也就是死等，但是宏  `INCLUDE_vTaskSuspend` 必须为 1。

返回值：
+ pdPASS： 向队列发送消息成功！
+ errQUEUE_FULL: 队列已经满了，消息发送失败


#### xQueueOverwrite()
也是用于向队列中发送数据的，当队列满了以后会覆写掉旧的数据，不管这个旧数据  
有没有被其他任务或中断取走。这个函数常用于向那些长度为 1 的队列发送消息，此函数也是一个宏，最终调用的也是函数 `xQueueGenericSend()`
```c
BaseType_t xQueueOverwrite(QueueHandle_t xQueue,
							const void * pvItemToQueue);
```
参数：
+ xQueue： 队列句柄，指明要向哪个队列发送数据，创建队列成功以后会返回此队列的队列句柄。
+ pvItemToQueue：指向要发送的消息，发送的时候会将这个消息拷贝到队列中。

返回值：
+ pdPASS： 向队列发送消息成功，此函数也只会返回。

#### **xQueueGenericSend()**
```c
BaseType_t xQueueGenericSend( QueueHandle_t xQueue,
							  const void * const pvItemToQueue,
							  TickType_t xTicksToWait,
							  const BaseType_t  xCopyPosition )
```
参数：
+ xQueue： 队列句柄，指明要向哪个队列发送数据，创建队列成功以后会返回此队列的  队列句柄。
+ pvItemToQueue：指向要发送的消息，发送的过程中会将这个消息拷贝到队列中
+ xTicksToWait：阻塞时间
+ xCopyPosition: 入队方式，有三种入队方式
	+ queueSEND_TO_BACK： 后向入队
	+ queueSEND_TO_FRONT： 前向入队
	+ queueOVERWRITE： 覆写入队。

返回值：
+ pdTRUE： 向队列发送消息成功！
+ errQUEUE_FULL: 队列已经满了，消息发送失败。


