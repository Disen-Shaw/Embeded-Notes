# LiteOS任务操作API
## 创建和删除任务

| 接口名                     | 描述                                                                                            |
| -------------------------- |:----------------------------------------------------------------------------------------------- |
| LOS_TaskCreateOnly()       | 创建任务，并使该任务进入挂起状态</br>如果需要调度，可以调用 `LOS_TaskResume` 使该任务进入就绪态 |
| LOS_TaskCreate()           | 创建任务，并使之进入就绪态                                                                      |
| LOS_TaskCreateOnlyStatic() | 创建任务，**任务栈由用户传入**，并使该任务进入挂起状态                                          |
| LOS_TaskCreateStatic()     | 创建任务，**任务栈由用户传入**，并使之进入就绪态                                                |
| LOS_TaskDelete()           | 删除指定的任务                                                                                  |

## 状态任务控制
| 接口名            | 描述                                                        |
| ----------------- | ----------------------------------------------------------- |
| LOS_TaskResume()  | 恢复挂起的任务，并使之进入就绪态                            |
| LOS_TaskSuspend() | 挂起指定的任务，然后进行任务调度                            |
| LOS_TaskDelay()   | 任务延时，让出CPU挂起一定时间，到事件后重新进入就绪态       |
| LOS_TaskYield()   | 当前任务释放CPU，并将其转移到具有相同优先级的就绪队列的末尾 |

## Task状态
`LiteOS` 任务的大多数状态由内核维护，唯有自删除状态对用户是可见的，需要在用户创建任务时传入

| 定义                      | 实际数值 | 描述           |
| ------------------------- | -------- | -------------- |
| LOS_TASK_STATUS_DETEACHED | 0x0101   | 任务是自删除的 |

用户在调用创建任务接口时，可以将创建任务的 `TSK_INIT_PARAM_S` 参数的 `uwResved` 域设置为 `LOS_TASK_STATUS_DETEACHED`，即自删除状态，设置成自删除状态的任务会在完成后执行自删除操作

</br>

> 自删除状态受 `LOSCFG_COMPAT_POSIX` 影响
> + 开关打开，只有将任务设置为 `LOS_TASK_STATUS_DETEACHED` 才能实现自删除，否则任务完成不会自删除
> + 开关关闭，任务完成时都会自删除，不管 `TSK_INIT_PARAM_S` 参数的 `uwResved` 域是否设置



## 任务调度控制
| 接口名         | 描述                                   |
| -------------- | -------------------------------------- |
| LOS_TaskLock() | 锁任务调度，但是任务仍然可以被中断打断 |
| LOS_TaskUnlock | 解锁任务调度锁，重新开始任务调度       |

## 任务优先级控制
| 接口名              | 描述                 |
| ------------------- | -------------------- |
| LOS_CurTaskPriSet() | 设置当前任务的优先级 |
| LOS_TaskPriSet()    | 设置指定任务的优先级 |
| LOS_TaskPriGet()    | 获取指定任务的优先级 |

## 设置任务亲和性
**LOS_TaskCpuAffiSet()**  
设置指定任务的运行CPU集合(**只在SMP下支持**)


## 回收任务栈资源
**LOS_TaskResRecycle()**  
回收所有待回收的任务栈资源

## 获取任务信息
| 接口名               | 描述                                                                                                     |
| -------------------- | -------------------------------------------------------------------------------------------------------- |
| LOS_CurTaskIDGet()   | 获取当前任务ID                                                                                           |
| LOS_TaskInfoGet()    | 获取指定任务信息<br>任务状态<br>优先级<br>任务栈大小<br>栈顶指针SP<br>任务入口函数<br>已使用任务栈大小等 |
| LOS_TaskCpuAffiGet() | 获取指定任务的运行CPU的集合(在SMP模式下支持)                                                             |

## 任务信息维测
**LOS_TaskSwitchHookReg()**  
注册任务上下文切换的钩子函数  
只有开启了 `LOSCFG_BASE_CORE_TSK_MONITOR` 宏开关之后  
这个钩子函数才在任务发生上下文切换时被调用

</br>

>可以通过 `make menuconfig` 配置 LOSCFG_KERNEL_SMP使能多核模式  
>`Kernel->Enable Kernel SMP`  
>在SMP的子菜单中还可以设置核的数量、使能多任务的核间同步、使能函数跨核调用
>
>在多核模式下，创建任务时可以传入 `usCpuAffiAMask()` 来配置任务的CPU亲和性  
>该标志位采用1bit-1core的对应方式，详细可以看 `TSK_INIT_PARAM_S` 结构体
>
>各个任务的任务栈大小，在创建任务时可以进行针对性的设置，若设置为0，则使默认任务栈大小  
>`LOSCFG_BASE_CORE_TSK_DEFAULT_STACK_SIZE` 作为任务栈大小

</br>

如果在任务操作中出现错误，可以参考 [[LiteOS_任务错误码]]

## 任务内核配置项

| 配置项                                  |                                                      含义                                                      |      取值范围      | 默认值             | 依赖 |
| --------------------------------------- |:--------------------------------------------------------------------------------------------------------------:|:------------------:| ------------------ | ---- |
| LOSCFG_BASE_CORE_TSK_LIMIT              |                                              系统支持的最大任务数                                              | 0～OS_SYS_MEM_SIZE | 不同平台默认值不同 | 无   |
| LOSCFG_TASK_MIN_STACK_SIZE              |                                       最小任务栈大小</br>一般使用默认值                                        | 0～OS_SYS_MEM_SIZE | 不同平台默认值不同 | 无   |
| LOSCFG_BASE_CORE_TKS_DEFAULT_STACK_SIZE |                                                 默认任务栈大小                                                 | 0～OS_SYS_MEM_SIZE | 梧桐平台默认不同   | 无   |
| LOSCFG_BASE_CORE_TKS_IDLE_STACK_SIZE    |                                       IDLE任务栈大小</br>一般使用默认值                                        | 0～OS_SYS_MEM_SIZE | 不同平台默认值不同 | 无   |
| LOSCFG_BASE_CORE_TKS_DEFAULT_PRIO       |                                      默认任务优先级，</br>一般使用默认值                                       |       0～31        | 10                 | 无   |
| LOSCFG_BASE_CORE_TIMESLICE              |                                                 时间片调度开关                                                 |       YES/NO       | YES                | 无   |
| LOSCFG_BASE_CORE_TIMESLICE_TIMEOUT      |                                        同优先级任务最长执行时间/(Tick)                                         |      0~65535       | 不同平台默认值不同 | 无   |
| LOSCFG_OBSOLETE_API                     | 使能后任务参数用旧方式</br>UINTPTR auwArgs[4]</br>否则使用新的任务参数</br>VOID \*pArgs</br>推荐关闭，使用新的 |       YES/NO       | YES                | 无   |
| LOSCFG_LAZY_STACK                       |                                                使能惰性压栈功能                                                |       YES/NO       | 不同平台默认值不同 | 无   |
| LOSCFG_BASE_CORE_TSK_MONITOR            |                                            任务栈溢出检查和轨迹开关                                            |       YES/NO       | YES                | 无   |
| LOSCFG_TASK_STATIC_ALLOCATION           |                                        支持创建任务时</br>由用户传入任务栈                                        |       YES/NO       | NO                 | 无   |


