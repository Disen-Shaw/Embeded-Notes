# 内核工具和辅助函数
## container_of宏
用于查找指定结构字段的容器，通过结构体成员找到结构体对象  
在 `linux/kernel.h` 中定义  

**原型**
```c
contain_of(pointer, contain_type, conrainer_field);
```
+ pointer：指向结构字段的指针
+ contain_type：包装指针的结构类型
+ conrainer_field：指针指向的结构内字段的名称

**使用**
```c
struct person {
	int age;
	char *name;
};

struct person somebody;
char *the_name_ptr = somebody.name;

struct person *the_person;
the_person = contain_of(the_name_ptr, struct person, name);
```
`the_person` 为包装此成员的整个结构的指针  
`contain_of` 考虑 `name` 从该结构开始处的偏移量，进而获得指针位置。

## 链表
如果有一个驱动程序管理多个设备，要想跟踪驱动中的每个设备，就需要链表  
开发者只实现循环双链表，这个结构能够实现 `FIFO` 以及 `LIFO`，并且内核开发者需要保持最少的代码。  
在 `linux/list.h` 中定义

```c
struct list_head {
	struct list_head *next, *prev;
};
```
定义了一个向后指针和向前指针

在内核中将数据结构表示为链表之前，必须嵌入 `struct list_head` 字段  
**例如**
```c
struct car {
	int door_number;
	char *color;
	struct list_head list;  	/* 内核链表结构 */
};
```

### 创建和初始化链表
首先需要创建表头
```c
struct list_head mylist;
```
有两种方法初始化链表
+ 动态方法
	+ 用 `INIT_LIST_HEAD` 宏来初始化
	+ INIT_LIST_HEAD(&mylist);
+ 静态方法
	+ 用 `LIST_HEAD` 宏初始化
	+ LIST_HEAD(&mylist);

方法内容都是给 `list_head` 结构体的两个成员赋值

### 创建链表节点
创建数据结构体实例，初始化嵌入在其中的 `list_head` 成员  

```c
/* 创建 */
struct car *redcar = kzalloc(sizeof(struct car), GFP_KERNEL);
/* 初始化 */
INIT_LIST_HEAD(&redcar->list);
```

### 添加链表节点
内核提供 `list_add` 用于向列表添加新项，它是内部函数 `__list_add` 的包装  

```c
list_add(&redcar->list, carlist);
```

也可以使用堆栈模式，使用 `list_add_tail(struct list_head *new, struct list_head *head`

```c
list_add_tail(&redcar->list, carlist);
```

### 删除链表节点
```c
void list_del(struct list_head *entry);
```
如果要删除 `redcar`
```c
list_del(&redcar->list);
```

### 链表遍历
使用宏 `list_for_each_entry(pos, head, member)` 进行遍历  
+ head：链表的头节点
+ member：数据结构中链表 `struct list_head` 的名称，例如 car 的 list
+ pos：用于迭代，循环游标，类似于 `for(i=0;i<foo;i++)` 中的 i

```c
struct car *acar;
list_for_each_entry(acar, carlist, list){
	if(acar->color == "red")
		printk("red car found");
}
```

## 内核的睡眠机制
进程通过睡眠机制释放处理器，使其能处理其他进程  
处理睡眠的原因可能是

+ 感知数据的可用性
+ 等待资源释放

内核调度器要管理用性的列表，被称为运行队列  
睡眠进程不再被调度，因为睡眠的进程被从运行队列中移除  
除非改变其状态(将进程唤醒)，否则这个进程永远都不会运行

### 等待队列
用于处理被阻塞的I/O，以等待特定条件成立，并感知数据资源的可用性。

```c
struct __wait_queue {
	unsigned int flags;
#define WQ_FLAG_EXCLUSIVE 0x01
	void *private;
	wait_queue_func_t func;
	struct list_head task_list;		/* 等待队列是一个链表 */
};
```
等待队列是一个链表，想要其入睡的每个进程都在该链表中排队，并进入睡眠状态，直到条件为真  
等待队列可以被看作是简单的进程链表和锁

#### 处理等待队列常用的函数
**竞态声明**
```c
DECLARE_WAIT_QUEUE_HEAD(name);
```

**动态声明**
```c
wait_queue_head_t my_wait_queue;
init_waitqueue_head(&my_wait_queue);
```

**阻塞**
```c
int wait_event_interruptible(wait_queue_head_t q, CONDITION);
```

**解除阻塞**
```c
void wake_up_interruptible(wait_queue_head_t *q);
```

`wait_event_interruptible` 不会持续轮询，只是在被调用时评估条件  
如果条件为假，则进程进入 `TASK_INTERRUPTIBLE` 状态，并从运行队列中删除。  
之后每当在等待队列中的调用`wake_up_interruptible` 时，都会重新检查。  
如果 `wake_up_interruptible` 运行时发现条件为真，则等待队列中的进程将被唤醒，并将其状态设置为 `TASK_RUNNING`。进程按照它们进入睡眠的顺序唤醒。  
要唤醒在队列中等待的所有进程，应该使用 `wake_up_interruptible_all`  

实际上主要函数是 `wait_event()`，`wake_up` 和 `wake_up_all`  
它们以独占等待的方式处理队列中的进程，因为它们不能被信号中断，它们只能用于关键任务  
可中断函数只是可选的。

如果调用了 `wake_up` 或 `wake_up_interruptible`，并且条件依然是 `FALSE` 则什么都不会发生。如果没有调用 `wake_up` ，进程将永远不会被唤醒

## 延迟和定时器管理
时间是内存之后最常用的资源之一，它用于执行几乎所有事情：

+ 延迟工作
+ 睡眠
+ 调度
+ 超时以及其他任务

时间有两类  
内核使用绝对时间来了解具体时间，也就是一天的日期和时间，而相对时间则被内核调度程序使用。  
对于绝对时间有一个实时时钟(RTC)的硬件芯片  
为了处理相对时间，内核依赖被称为定时器的 CPU功能(外设)，从内核角度看，它是内核定时器

内核定时器分为两个不同的部分：

+ 标准定时器
+ 高精度定时器

### 标准定时器
#### Jiffy和HZ
标准定时器是内核定时器，它以 `Jiffy` 为粒度运行  
`Jiffy` 是 `linux/jiffies.h` 中声明的内核时间单位  
`HZ` 是 `jiffies` 在1s内递增的次数，每个增量被称为一个 `Tick`   
`HZ` 代表 `Jiffy` 的大小，`HZ` 取决于硬件和内核版本，也决定了时钟中断触发的频率。  
这在某些体系结构上是可配置的，而在另一些机器上则是固定的

`jiffies` 每秒增加 HZ 倍，如果 HZ=1000，则递增1000次(每1/1000秒一次tick)，定义之后，可以编程中断定时器(PIT，一个硬件组件)发生中断时，可以用该值变成PIT，以增加 Jiffy 值

根据平台不同，`Jiffies` 可能会导致溢出

+ 在32位系统中，HZ=1000只会导致大约50天的持续时间
+ 在64位系统中，HZ=1000的持续时间大约是6亿年

将Jiffy存储在64位变量中，就可以解决这个问题

#### 定时器API
定时器在内核中表示为 `timer_list` 的一个实例
```c
#include <linux/timer.h>

struct timer_list {
	struct list_head entry;
	unsigned long expires;
	struct tvec_t_base_s *base;
	void (*function)(unsigned long);
	unsigned long data;
};
```
+ expires：以 jiffies为单位绝对值
+ entry：双向链表
+ data：可选的传递给回调函数的参数

**设置定时器**
```c
void setup_timer(struct timer_list *timer, \
		   void (*function)(unsigned long), \
		   unsigned long data);
```
也可以使用  
```c
void init_timer(struct timer_list *timer);
```
`setup_timer` 是对 `init_timer` 的包装

**设置过期时间**
当定时器初始化时，需要在启动回调之前设置它的过期时间
```c
int mod_timer(struct timer_list *timer, unsigned long expires);
```

**释放定时器**
定时器使用过之后需要释放
```c
void del_timer(struct timer_list *timer);
int del_timer_sync(struct timer_list *timer);
```
无论是否已经停用挂起的定时器，`del_timer()` 的返回值总是 `void`。
+ 对于不活动定时器，它返回0
+ 对于活动定时器，它返回1

最后一个 `del_timer_sync` 等待处理程序(即使在另一个CPU上运行)执行完成。不应该有阻止处理程序完成的锁，这样会导致死锁。应该在模块清理例程中释放定时器  
可以独立检查定时器是否在运行
```c
int timer_pending(const struct timer_list *timer);
```

### 高精度定时器(HRT)
标准定时器不够精确，不适合实时应用，在内核配置中的 `CONFIG_HIGH_RES_TIMERS` 选项启用  
其精度可以达到微秒级(取决于平台，最高可以达到纳秒级别)，而标准定定时器的精度则为毫秒  
+ 标准定时器取决于 HZ，因为它们依赖于jiffies
+ HRT的实现是基于ktime

在系统上使用HRT时，**要确认内核和硬件支持它**

#### HRT设置初始化步骤
**初始化hrtimer**
`hrtimer` 初始化之前，需要设置 ktime，它代表持续时间
```c
void hrtimer_init(struct hrtimer *timer, clockid_t which_clock, enum hrtimer_mode mode);
```

**启动hrtimer**
```c
int hrtimer_start(struct hrtimer *timer, ktime_t time, const enum hrtimer_mode mode);
```

**取消hrtimer**
```c
int hrtimer_cancel(struct hrtimer *timer);
int hrtimer_try_to_cancel(struct hrtimer *timer);
```
两个函数在定时器没有被激活时都返回0,激活时返回1  
如果定时器处于激活状态运行这个函数，`hrtimer_try_to_cancel` 函数会返回 -1，而`hrtimer_cancel` 将等待回调完成

**检查hrtimer的回调函数是否仍在运行**
```c
int hrtimer_callback_running(struct hrtimer *timer);
```

`hrtimer_try_to_cancel` 的内部会调用 `hrtimer_callback_running`  
为了防止定时器自动重启，hrtimer回调函数必须返回 `HRTIMER_NORESTART`

执行下面的操作可以检查系统是否可以使用 HRT
+ 查看内核配置文件，其中应该包含这样的配置内容
	+ CONFIG_HIGH_RES_TIMERS=y
	+ 通过 `cat /proc/configs.gz | grep CONFIG_HIGH_RES_TIMERS`
+ 查看 `cat /proc/timer_list` 或者 `cat /proc/timer_list | grep resolution`
	+ .resolution 项必须显示1 nsecs，事件处理程序必须显示 `hrtimer_interrupts`
+ 使用 `clock_getres` 系统调用
+ 在内核代码中，使用 `#ifdef CONFIG_HIGH_RES_TIMERS`

在系统启用 HRT 的情况下，睡眠和定时器系统调用的精度不再依赖于 `jiffes`，但他们会像HRT一样精确。这就是有些系统不支持 `nanosleep()` 之类的原因

#### 动态Tick/Tickless
使用之前的HZ选项，即使处于空闲状态，内核也会每秒钟中断HZ次以再次调度任务。如果将HZ设置为1000,则每秒会有1000此内核中断，阻止CPU长时间处于空闲状态，因此影响CPU的功耗。

**无定义/无预定义Tick的内核**  
在需要执行某些任务之前禁用Tick，这样的内核称为 `Tickless` 内核/无Tick内核。  
实际上，Tick激活是依据下一个操作安排的，其正确的名字应该是 `动态Tick内核`  

内核负责系统中任务调度，并维护可运行任务列表(运行队列)。当没有任务需要调度时，调度器切换到空闲线程，它启用动态Tick的方法是，在下一个定时器过期前(新任务排队等待处理)，禁用周期性Tick

内核还维护一个任务超时列表(它知道什么时候要休眠以及要休眠多久)。在空闲状态下，如果下一个Tick比任务超时列表超时中的最小超时更远，内核则使用该超时值对定时器进行编程。  
当超时器到期时，内核重新启用周期Tick并调用调度器，它调度与超时相关的任务

通过以上方式，Tickless内核移除周期性Tick，节省电量

#### 内核中的延迟和睡眠
延迟有两种类型，取决于代码运行的上下文，原子的或非原子的。  
处理内核延迟需要包含的头文件是 `linux/delay.h`

**原子上下文**
原子上下文中的任务(例如ISR)不能进入睡眠状态，无法进行调度  
内核提供 `Xdelay` 系列函数，在繁忙循环中消耗足够长时间(基于`jiffies`)，得到所需的延迟

+ ndelay(unsigned long nsecs);
+ udelay(unsigned long usecs);
+ mdelay(unsigned long msecs);

应该始终使用 `udelay()`，因为 `ndelay()`，的精度取决于硬件定时器的精度(嵌入式SoC不一定如此)，不建议使用 `mdelay()`

定时器处理程序(回调函数)在原子上下文中执行，这意味着根本不允许进入睡眠，这指的可能是导致调用程序进入睡眠的所有功能
+ 分配内存
+ 锁定互斥锁
+ 显示调用 `sleep()` 函数等

**非原子上下文**
在非原子上下文中，内核提供 `sleep[_range]` 系列函数，使用哪个函数取决于需要延迟多长时间
+ udelay(unsigned long usecs)
	+ 基于繁忙等待--等待循环
	+ 如果需要睡眠数微秒(小于等于10us左右)，应该使用这个函数
+ usleep_range(unsigned long min, unsigned long max)
	+ 依赖于 `hrtimer`，睡眠数微秒到数毫秒时使用
	+ 避免使用 `udelay()` 的繁忙--等待循环
+ msleep(unsigned long msecs)
	+ 由 `jiffies`/传统定时器支持，对于数毫秒以上的睡眠(10ms+)，应使用这个函数


## 内核的锁机制
锁机制有助于不同线程或者进程之间共享资源。共享资源可以是数据或者设备，它们至少可以被两个用户同时或者非同时访问  

锁机制可以防止过度访问，内核提供了几种锁机制
+ 互斥锁
+ 信号量
+ 自旋锁

[[Linux_设备驱动中的并发控制]]

## 工作延迟机制
延迟是将所要做的工作安排在将来执行的一种方式，这种方法推后发布操作  
内核的三项功能

+ SoftIRQ：执行在原子上下文
+ Tasklet：执行在原子上下文
+ 工作队列：执行在进程上下文

### Softirq 和 Ksoftirqd
`Softirq` 这种延迟机制仅用于快速处理，因为它在禁用调度器下运行(在中断上下文运行)  
很少(几乎从不)直接使用 `Softirq`，只有网络设备和快设备子系统使用 `Softirq` 

`Tasklet` 是 `Softirq` 的实例，几乎每种需要使用 `Softirq` 的情况下，有 `Tasklet` 就足够

大多数情况下，`Softirq` 在硬件中断中被调度，这些中断发生的很快，快过对他们的服务速度，内核会对它们排队以便稍后处理，`Ksoftirqd` 负责后期执行  

`Ksoftirqd` 是单CPU内核线程，用于处理未服务的软件中断