# FreeRTOS计数型信号量
## 简介
计数型信号量叫做数值信号量，二值信号量相当于长度为 1 的队列，那么计数型信号量就是长度大于 1 的队列。  
同二值信号量一样，用户不需要关心队列中存储了什么数据，只需要关心队列是否为空即可。  

**技术信号量通常用于下面两个场合**  
+ 事件计数
+ 资源计数

### 事件计数
每次事件发生的时候就在事件处理函数中释放信号量(增加信号量的计数值)，其他任务会获取信号量(信号量计数值减一，信号量值就是队列结构体成员变量`uxMessagesWaiting`)来处理事件。

### 资源管理
信号量值代表当前资源的可用数量，一个任务要想获得资源的使用权，首先必须获取信号量，信号量获取成功以后信号量值就会减一。当信号量值为 0 的时候说明没有资源了。  
当一个任务使用完资源以后一定要释放信号量，释放信号量以后信号量值会加一。
在这个场合中创建的计数型信号量初始值应该是资源的数量，比如停车场一共有100个停车位，那么创建信号量的时候就应该初始化为100

## 创建计数型信号量
| 函数                             | 描述                         |
| -------------------------------- | ---------------------------- |
| xSemaphoreCreateCounting()       | 使用动态方法创建计数型信号量 |
| xSemaphoreCreateCountingStatic() | 使用静态方法创建计数型信号量 | 

### xSemaphoreCreateCounting()
创建一个计数型信号量，所需要的内存通过动态内存管理方法分配。  
本质是一个宏，真正完成信号量创建的是`xQueueCreateCountingSemaphore()`

```c
SemaphoreHandle_t xSemaphoreCreateCounting(UBaseType_t uxMaxCount,
						UBaseType_t uxInitialCount )
```
参数:  
+ uxMaxCount：  计数信号量最大计数值，当信号量值等于此值的时候释放信号量就会失败。
+ uxInitialCount：  计数信号量初始值。

返回值：
+ NULL：计数型信号量创建失败。
+ 其他值: 计数型信号量创建成功，返回计数型信号量句柄。

### xSemaphoreCreateCountingStatic()
使用此函数创建计数型信号量的时候所需要的内存    
需要由用户分配，此函数也是一个宏，真正执行的是函数  
`xQueueCreateCountingSemaphoreStatic()`
```c
SemaphoreHandle_t xSemaphoreCreateCountingStatic( UBaseType_t uxMaxCount,
					UBaseType_t uxInitialCount,
					StaticSemaphore_t * pxSemaphoreBuffer )
```
参数：
+ uxMaxCount：计数信号量最大计数值，当信号量值等于此值的时候释放信号量就会失败。
+ uxInitialCount：计数信号量初始值。
+ pxSemaphoreBuffer：指向一个 `StaticSemaphore_t `类型的变量，用来保存信号量结构体。

返回值：
+ NULL：计数型信号量创建失败。
+ 其他值: 计数型号量创建成功，返回计数型**信号量句柄**

**释放和获取信号量与二值信号量相同**

