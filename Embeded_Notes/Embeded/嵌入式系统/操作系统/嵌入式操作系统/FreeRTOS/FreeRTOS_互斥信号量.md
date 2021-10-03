---
date updated: '2021-10-03T09:08:16+08:00'

---

# FreeRTOS互斥信号量

## 互斥信号量

互斥信号量其实就是一个拥有优先级继承的二值信号量，在同步的应用中(任务与任务或中断与任务之间的同步)二值信号量最适合。互斥信号量适合用于那些需要互斥访问的应用中。
在同步的应用中(任务与任务或中断与任务之间的同步)二值信号量最适合
而互斥信号量适合用于那些需要互斥访问的应用中。
互斥访问中互斥信号量相当于一个钥匙，当任务想要使用资源的时候就必须先获得这个钥匙，当使用完资源以后就必须归还这个钥匙，这样其他的任务就可以拿着这个钥匙去使用资源。
互斥信号量使用和二值信号量相同的 API 操作函数，所以互斥信号量也可以设置阻塞时间，\
不同于二值信号量的是互斥信号量具有**优先级继承的特性**

当一个互斥信号量正在被一个低优先级的任务使用，而此时有个高优先级的任务也尝试获取这个互斥信号量的话就会被阻塞。不过这个高优先级的任务会将低优先级任务的优先级提升到与自己相同的优先级，这个过程就是优先级继承。
优先级继承尽可能的降低了高优先级任务处于阻塞态的时间，并且将已经出现的\
“优先级翻转”的影响降到最低。

优先级继承并不能完全的消除优先级翻转，它只是尽可能的降低优先级翻转带来的影响。
互斥信号量有优先级继承的机制，所以只能用在任务中，不能用于中断服务函数。
**中断服务函数中不能因为要等待互斥信号量而设置阻塞时间进入阻塞态。**

## 创建互斥信号量

| 函数                            | 描述             |
| ----------------------------- | -------------- |
| xSemaphoreCreateMutex()       | 使用动态方法创建互斥信号量。 |
| xSemaphoreCreateMutexStatic() | 使用静态方法创建互斥信号量  |

### xSemaphoreCreateMutex()

此函数用于创建一个互斥信号量，所需要的内存通过**动态内存管理方法**分配。
函数本质是一个宏，真正完成创建的是函数`xQueueCreateMutex()`

```c
SemaphoreHandle_t xSemaphoreCreateMutex( void )
```

参数：

- 无

返回值：

- NULL：互斥信号量创建失败。
- 其他值: 创建成功的互斥信号量的句柄

### xSemaphoreCreateMutexStatic()

此函数也是创建互斥信号量的，只不过使用此函数创建互斥信号量的话信号量所需要的RAM 需要由用户来分配
此函数也是一个宏，具体创建过程是通过函数 `xQueueCreateMutexStatic ()`来完成

```c
SemaphoreHandle_t xSemaphoreCreateMutexStatic( StaticSemaphore_t *pxMutexBuffer )
```

参数：

- pxMutexBuffer：此参数指向一个 StaticSemaphore_t 类型的变量，用来保存信号量结构体。

返回值：

- NULL：互斥信号量创建失败。
- 其他值: 创建成功的互斥信号量的句柄。

### 互斥信号量创建过程分析

xQueueCreateMutex()定义如下

```c
QueueHandle_t xQueueCreateMutex( const uint8_t ucQueueType ){
	Queue_t *pxNewQueue;
	const UBaseType_t uxMutexLength = ( UBaseType_t ) 1, uxMutexSize = ( UBaseType_t ) 0;
	pxNewQueue = ( Queue_t * ) xQueueGenericCreate( uxMutexLength, uxMutexSize,ucQueueType );
	prvInitialiseMutex( pxNewQueue );
	return pxNewQueue;
}
```

调用xQueueGenericCreate()创建一个队列，队列长度为 1，队列项长度为 0，队列类型为参数 ucQueueType，互斥信号量，因此参数为`queueQUEUE_TYPE_MUTEX`。

调用函数 `prvInitialiseMutex()`初始化互斥信号量

```c
static void prvInitialiseMutex( Queue_t *pxNewQueue ){
	if( pxNewQueue != NULL ){
		//虽然创建队列的时候会初始化队列结构体的成员变量，但是此时创建的是互斥 
		//信号量，因此有些成员变量需要重新赋值，尤其是那些用于优先级继承的。
		pxNewQueue->pxMutexHolder = NULL;
		pxNewQueue->uxQueueType = queueQUEUE_IS_MUTEX;
		
		//如果是递归互斥信号量的话。
		pxNewQueue->u.uxRecursiveCallCount = 0;
		
		traceCREATE_MUTEX( pxNewQueue );
		
		// 释放互斥信号量
		( void ) xQueueGenericSend( pxNewQueue, NULL, ( TickType_t ) 0U,queueSEND_TO_BACK );
		}else{  
			traceCREATE_MUTEX_FAILED();  
		}
	}
}
```

**互斥信号量创建成功之后会调用函数xQueueGenericSend()释放一次信号量，说明互斥信号量默认是有效的。**

获取和释放信号量与二值信号量相同

## 递归互斥信号量

递归互斥信号量可以看作是一个特殊的互斥信号量，已经获取了互斥信号量的任务就不能再次获取这个互斥信号量，但是递归互斥信号量不同，已经获取了递归互斥信号量的任务可以再次获取这个递归互斥信号量，而且次数不限。

一个任务使用函数 `xSemaphoreTakeRecursive()` 成功的获取了多少次递归互斥信号量就得使用函数 `xSemaphoreGiveRecursive()` 释放多少次。
**递归互斥信号量也有优先级继承的机制，所以当任务使用完递归互斥信号量以后一定得释放。**
**使用递归互斥信号量的话红configUSE_RECURSIVE_MUTEXS必须设置为1**

## 创建递归互斥信号量

| 函数                                     | 描述               |
| -------------------------------------- | ---------------- |
| xSemaphoreCreateRecursiveMutex()       | 使用动态方法创建递归互斥信号量  |
| xSemaphoreCreateRecursiveMutexStatic() | 使用静态方法创建递归互斥信号量。 |

### xSemaphoreCreateRecursiveMutex()

用于创建一个递归互斥信号量，所需要的内存通过动态内存管理方法分配
此函数是宏定义，真正完成信号量创建的是函数`xQueueCreateMutex()`

```c
SemaphoreHandle_t  xSemaphoreCreateRecursiveMutex( void )
```

参数：

- 无

返回值

- NULL: 互斥信号量创建失败。
- 其他值: 创建成功的互斥信号量的句柄。

### xSemaphoreCreateRecursiveMutexStatic()

使用此函数创建递归互斥信号量的话信号量所需要的RAM需要由用户来分配，此函数是个宏

```c
SemaphoreHandle_t xSemaphoreCreateRecursiveMutexStatic( StaticSemaphore_t *pxMutexBuffer )
```

参数：

- pxMutexBuffer：此参数指向一个 StaticSemaphore_t 类型的变量，用来保存信号量结构体。

返回值：

- NULL: 互斥信号量创建失败。
- 其他值: 创建成功的互斥信号量的句柄

### 获取与释放信号量

递归信号量有专门的释放函数：`xSemphoreGiveRecursive()`，此函数是一个宏定义

```c
#define  xSemaphoreGiveRecursive( xMutex ) xQueueGiveMutexRecursive( ( xMutex ) )
```

真正释放是由函数`xQueueGiveMutexRecuisive()`来完成的

获取信号量也有专门的函数xSemaphoreTakeRecursive()
此函数也是一个宏定义

```c
#define xSemaphoreTakeRecursive( xMutex, xBlockTime )   xQueueTakeMutexRecursive( ( xMutex ), ( xBlockTime ) )
```
