# uCOS系统内部任务
## uCOSIII系统函数
### 空闲任务
在os_cfg_app.c中有定义
空闲任务特点:
+ uCOSIII创建的第一个任务
+ 空闲任务是uCOSIII必须创建的
+ 空闲任务优先级总是为OS_CFG_PRIO_MAX-1
+ 空闲任务不能调用任何可使空闲任务进入等待状态的函数

### 时钟节拍任务
用来跟踪任务延时和任务等待超时，任务函数为OS_TickTask()，是**uCOSIII必须创建的一个任务**，任务优先级用宏OS_CFG_TICK_TASK_PRIO来定义，一般时钟节拍任务的任务应该设置一个相对较高的任务

### 统计任务
uCOSIII中统计任务用来统计CPU的使用率、各个任务的CPU使用率和各个任务的堆栈使用情况，默认情况下统计任务是不会创建的。如果要开启统计任务的话需要做以下几点：
1. 将宏OS_CFG_STAT_TASK_EN置1
2. 必须在main函数创建的以一个任务也是唯一的一个应用里面调用函数`OSSrtatTaskCPUUsageInit()`
3. 统计任务的优先级通过宏OS_CFG_TASK_PRIO来设置，一般设置OS_CFG_PRIO_MAX-2,也就是倒数第二个优先级


### 定时任务
uCOSIII提供软件定时器功能，定时任务是可选的，将宏`OS_CFG_TMR_EN`设置为1就会时能定时任务，在OSInit()中会调用函数OS_TmrInit()来创建定时任务。
定时任务的优先级通过宏OS_CFG_TMR_TASK_PRIO定义，原子设置的是2。

### 终端服务管理任务
吧os_cfg.h文件中的宏OS_CFG_ISR_POST_DEFERRED_EN置1就会使能中断服务管理任务，当ISR(中断服务函数)调用uCOSIII提供的“POST”函数时，要发送的数据和发送的目的都会存入一个特别的缓冲队列中，当所有嵌套的ISR都执行完成以后，uCOSIII会做任务切换，运行**中断服务管理任务**，该任务吧缓存队列中存放的信息重发给相应的任务，这样的好处就是可以**减少中断关闭的时间**，否则，在ISR中还需要把任务从等待列表中删除，并把任务放入就绪表，以做一些其他的耗时操作。
**中断服务管理任务的优先级永远为0,不可以更改**

## uCOSIII钩子函数
用于给任务添加额外功能，用法类似于CallBack函数，在os_app_hooks.c中定义
一般主要用来扩展其他函数(任务)功能的，钩子函数有以下几个：
1. `OSIdleTaskHook()`，空闲任务调用这个函数，可以用来让CPU进入低功耗模式
2. `OSInitHook()`，系统初始化函数OSInit()调用这个函数
3. `OSStatTaskHook()`，统计任务每秒中都会调用这个函数，此函数允许向统计任务中添加自己的应用函数
4. `OSTaskCreateHook()`，任务创建的钩子函数
5. `OSTaskDelHook()`，任务删除的钩子函数
6. `OSTaskReturnHook()`，任务意外返回时调用的钩子函数，比如删除某个任务
7. `OSTaskSwHook()`，任务切换时调用的钩子函数
8. `OSTimeTickHook()`，滴答定时器调用的钩子函数

