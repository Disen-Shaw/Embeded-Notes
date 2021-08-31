# uCOS时间片轮转调度
## 时间片轮转调度器
### 时间片轮转函数
用于时间片轮转调度，为函数`OS_SchedRoundRobin()`，此函数由`OSTimeTick`或者`OS_IntQTask()`调用，在os_core.c中定义  
想要使用uCOSIII的时间片轮转调度的话不仅要将宏`OS_CFG_SCHED_ROUND_ROBIN_EN`置1,还需要调用函数`OSSchedRoundRobinCfg()`，函数原型如下：  

```c
void OSSchedRoundRobinCfg(	CPU_BOOLEAN		en,
							OS_TICK			dflt_time_quanta,
							OS_ERR			*p_err);
```
宏定义位于文件`os_cfg.h`中

### 放弃时间片轮转函数
当一个任务要放弃时间片调用`OSSchedRoundRobinYield()`  
原型如下：  

```c
void OSSchedRoundRobinYield(OS_ERR *p_err);
```

使用的时候一般添加条件判断，后面加`OSSchedRoundRobinYield(&err)`  
如果出现任务没有运行完就执行了下一个任务，可以适当增加时间片的大小  

