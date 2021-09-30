---
date updated: '2021-10-01T07:46:36+08:00'

---

# uCOSIII消息传递

## 任务间通信

### 任务间通信

一个任务或者中断服务程序有时候需要和另一个任务交流信息，这个消息传递过程就是**任务间通信**，任务间的消息传递可以通过两种途径：

- 通过**全局变量**
- 通过**发布消息**

使用全局变量的时候每个任务或者终端服务程序都必须保证其对全局变量的**独占访问**。
消息也可以通过消息队列作为中介发布给任务

### 消息

消息包含几个部分：

- 指向数据的指针
- 数据的长度
- 记录消息发布时刻的时间戳

指针指向的可以是一块数据区域或者甚至是一个函数

消息的内热哦嗯必须一直保持可见，可见性是指代表信息的变量必须在接收消息的任务代码范围内有效，这是因为发布的数据采用的是指针传递，也就是引用传递，并不是值传递。也就是说，发布的消息本身不产生拷贝，可以使用动态内存分配的方式来给消息分配一个内存快，或者可以传递一个指向全局变量、全局数据结构，全局数组或者函数的指针。

## uCOSIII消息队列

### 消息队列结构

FIFO结构
![[Pasted image 20210712150033.png]]
消息队列是uCOSIII中的一个内核对象，为结构体OS_Q，具体定义如下：\
消息队列架构

```c
struct os_q{
OS_OBJ_TYPE		Type;
CPU_CHAR		*NamePtr;
OS_PEND_LIST	PendList;
#if OS_CFG_DBG_EN > 0U
	OS_Q		*DbgPrevPtr;
	OS_Q		*DbgNextPtr;
	OS_Q		*DbgNamePtr;
#endif
OS_MSG_Q		MsgQ;		//消息队列
};
```

消息队列，将消息组成链表

```c
struct os_msg_q{
	OS_MSG		*InPtr;
	OS_MSG		*OutPtr;
	OS_MSG_QTY	NbrEntriesSize;
	OS_MSG_QTY	NbrEntries;
	OS_MSG_QTY	NbrEntriesMax;
};
```

具体的消息

```c
struct os_msg{
	OS_MSG		*NextPtr;
	void 		*MsgPtr;
	OS_MSG_SIZE	MsgSize;
	CPU_TS		MsgTS;
};
```

### 消息队列API函数

| 函数名             | 作用              |
| --------------- | --------------- |
| **OSQCreate()** | **创建一个消息队列**    |
| OSQdel()        | 删除一个消息队列        |
| OSQFlush()      | 清空消息队列          |
| **OSQPend()**   | **等待消息**        |
| OSQPendAbort()  | 取消等待消息          |
| **OSQPost()**   | **向消息队列发布一则消息** |

## 任务内建消息队列

### 简介

同任务内嵌信号量一样，uCOSIII的每个任务中也有内建消息队列，而且多个任务等待同一个消息队列的应用很少见，uOCSIII中每个任务多有其内建消息队列的话用户可以不通过外部消息队列而直接向任务发布消息\
如果使用任务内建消息队列功能的时候需要将宏OS_CFG_TASK_Q_EN置为1来使能相关的代码

### API函数

| 函数名                | 作用            |
| ------------------ | ------------- |
| **OSTaskQOend()**  | **等待消息**      |
| OSTaskQPendAbort() | 取消等待消息        |
| **OSTaskQPost()**  | **向任务发布一则消息** |
| OSTaskQFlush()     | 清空任务的消息队列     |
