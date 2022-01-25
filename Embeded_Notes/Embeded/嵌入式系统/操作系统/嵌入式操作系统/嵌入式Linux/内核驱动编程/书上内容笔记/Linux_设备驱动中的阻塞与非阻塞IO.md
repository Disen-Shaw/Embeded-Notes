---
date updated: '2021-10-01T07:50:53+08:00'

---

# Linux设备驱动中的阻塞IO与非阻塞IO

## 阻塞与非阻塞IO

- 阻塞操作指在执行设备操作时，若不能获取资源，则挂起进程直到满足操作条件后再进行操作
  - 被挂起的任务进入 `睡眠状态`，被从调度器的运行队列中移走直到等待的条件满足
- 非阻塞操作的进程在不能进行设备访问时，并不会挂起，进程要么放弃，要么等待不断查询，直到满足操作的条件

驱动程序通常需要这样的功能：

**阻塞操作**\
当应用程序进行 `read()`、`write()` 等系统调用时，若设备的资源不能获取，**而用户又希望以阻塞的方式访问设备**，驱动程序应该在设备驱动的 `xxx_read()`、`xxx_write()` 等操作中将进程阻塞直到资源可以获取\
这之后，`应用程序` 的 `read()`、`write()` 等调用才能返回，整个过程中进行了正确的设备访问，上层应用用户并没有察觉到这样一个过程

**非阻塞操作**\
若用户以非阻塞方式进行访问设备文件，则当设备源不可获取时，设备驱动的 `xxx_read()`、`xxx_write()` 等操作应该立即返回，上层应用的 `read()`、`write` 等系统调用也立即被返回，应用程序收到 `-EAGAIN` 返回值

- 阻塞访问，不能获取资源会进入 `睡眠态`，必须确保有一个地方能够唤醒这个进程，否则进程就真的 阻塞死了
  - 唤醒的位置最大可能发生在 `中断` 里面，因为硬件资源获得的同时经常伴随这一个中断
- 非阻塞进程则不断尝试，知道可以进行IO操作

</br>

**阻塞的读取串口的一个字符**

```c
char buf;
fd = open("/dev/ttyS1",O_RDWR);
... ... 
res = read(fd, &buf, 1);					/* 只有串口有输入时才会返回 */
if(res == 1)
	printf("%c\n",buf);
```

**非阻塞的读取串口一个字符**

```c
char buf;
fd = open("/dev/ttyS1",O_RDWR | O_NOBLOCK);
... ... 
while(read(fd, &buf,1) != 1)				/* 串口无输入时也返回，因此要循环尝试读取串口 */
	continue;
if(res == 1)
	printf("%c\n",buf);
```

除了在打开文件时可以指定阻塞还是非阻塞方式之外，在文件打开后，也可以通过 `ioctl()` 和 `fcntl()` 改变读取方式\
例如调用 `fcntl(fd, F_SETFL, O_NOBLOCK)` 可以设置fd对应的IO为非阻塞

</br>

## 等待队列

在Linux驱动程序中，可以使用等待队列(Wait Queue)来实现阻塞进程的唤醒\
它是以队列为基础的数据结构，与进程调度机制紧密结合，**可以用来同步对系统资源的访问**

### 等待队列操作

**定义 "等待队列`头部`"**

```c
wait_queue_head_t myqueue;
```

`wait_queue_head_t 是 __wait_queue_head 结构体的一个 typedef`

**初始化"等待队列`头部`"**

```c
init_wait_queue_head(&myqueue);
```

而 `DECLARE_WAIT_QUEUE_HEAD()` 可以作为**定义并初始化**等待队列头部的 "快捷方式"

```c
DECLARE_WAIT_QUEUE_HEAD(name);
```

**定义等待队列`元素`**

```c
DECLARE_WAITQUEUE(name, tsk);
```

用于定义并初始化一个名为 name 的等待队列元素

**添加/移除等待队列**

```c
void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);   			/* 添加队列元素 */
void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);			/* 删除队列元素 */
```

**等待事件**

```c
wait_event(queue, condition);
wait_event_interrupt(queue, condition);
wait_event_timeout(queue, condition, timeout);
wait_event_interrupt_timeout(queue, condition, timeout);
```

queue 作为等待队列头部的队列被唤醒，而且第二个参数 condition 必须满足，否则将会一直阻塞\
`wait_event_interrupt` 可以被信号打断，但是 `wait_event` 不能\
加上 timeout 意味着阻塞等待的超时时间，以 `jiffy` 为单位\
在达到超时值后，不管 condition 是否满足，都会返回

**唤醒队列**

```c
void wake_up(wait_queue_head_t *queue);
void wake_up_interruptiable(wait_queue_head_t *queue);
```

操作会唤醒 queue 作为等待队列头部中的所有进程
`wake_up` 应该与 `wait_event` 或者 `wait_event_timeout` 成对使用\
`wake_up_interruptiable` 应该和 `wait_event_interrupt` 或者 `wait_event_interrupt_timeout` 成对使用\
`wake_up` 可唤醒处于 `TASK_INTERRUPTIBLE` 和 `TASK_UNINTERRUPTIBLE` 的进程，而 `wake_up_interruptiable` 只能唤醒处于 `TASK_INTERRUPTIBLE` 的进程

**在等待队列上睡眠**

```c
sleep_on(wait_queue_head_t *q);
interruptible_sleep_on(wait_queue_head_t *q);
```

`sleep_on` 的作用时将目前进程的状态设置成 `TASK_UNINTERRUPTIBLE`，并定义一个等待队列的元素，之后把它挂到等待队列头部q指向的双向链表\
直到资源可以获得，q队列指向的链接进程被唤醒

`interruptible_sleep_on` 使用和 `sleep_on` 类似，将目前进程的状态设置成 `TASK_INTERRUPTIBLE`，并定义一个等待队列的元素，之后把它挂到等待队列头部q指向的双向链表，直到资源可以获得，q队列指向的链接进程被唤醒

`sleep_on` 函数应该和 `wake_up` 成对使用\
`interruptible_sleep_on` 函数应该和 `wake_upinterruptible` 成对使用

**在设备驱动中使用等待队列**

```c
static ssize_t xxx_write(struct file *filp, const char *buffer, size_t count, loff_t *ppos)
{
	...
	DECLARE_WAITQUEUE(wait, current);					/* 定义等待队列元素 */
	add_wait_queue(&xxx_wait, &wait);					/* 添加元素到等待队列 */
	
	/* 等待设备缓冲区可写 */
	do {
		avail = device_writable(...);
		if (avail < 0){
			if(filp->f_flags & O_NOBLOCK){				/* 非阻塞 */
				ret = -EAGAIN;
				goto out;
			}											
														/* 阻塞 */
			__set_current_state(TASK_INTERRUPTIBLE);	/* 改变进程状态 */
			schedule();									/* 调度其他进程执行 */
			if (signal_pending(current)) {
				ret = -ERESTARTSYS;
				goto out;
			}
		}
	} while( avail < 0 );
	/* 写设备缓冲区 */
	device_write(...)
	out:
	remove_wait_queue(&xxx_wait, &wait);				/* 将元素移出 xxx_wait 指引的队列 */
	set_current_state(TASK_RUNNING).					/* 设置进程的状态为 TASK_RUNNING */ 
	return ret;
}
```

- 如果是非阻塞访问，设备忙时直接返回 `-EAGAIN`
- 对于阻塞访问，会调用 `__set_current_state(TASK_INTERRUPTIBLE` 进行进程状态切换并显示通过 `schedule` 调度其他进程
- 醒来的时候需要注意，由于调度出去的时候，进程的状态是 `TASK_INTERRPUTIBLE`。即浅度睡眠，所以唤醒它的可能是信号
  - 因此首先需要通过 `signal_pending` 判断是否时信号唤醒的，
  - 如果是，则返回 `-ERESTARTSYS`
