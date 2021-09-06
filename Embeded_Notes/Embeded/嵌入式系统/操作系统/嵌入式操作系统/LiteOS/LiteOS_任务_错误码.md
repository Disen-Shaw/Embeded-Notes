# LiteOS_Task 错误码
创建任务、删除任务、挂起任务、恢复任务、延时任务等操作存在失败的可能性  
操作失败会返回对应的错误码，用于快速定位错误的原因

## 常见错误
| 定义                                | 实际数值   | 描述                                                                                 |                                     参考方案                                     |
| ----------------------------------- | ---------- | ------------------------------------------------------------------------------------ |:--------------------------------------------------------------------------------:|
| LOS_ERRNO_TSK_NO_MEMORY             | 0x03000200 | 内存空间不足                                                                         |                                        1                                         |
| LOS_ERRNO_TSK_PTR_NULL              | 0x02000201 | 传递给创建接口的参数 `initParam` 为空指针</br>传递给任务信息获取的接口的参数为空指针 |                          确保传入的指针</br>不为空指针                           |
| LOS_ERRNO_TSK_PRIOR_ERROR           | 0x02000203 | 创建任务或者设置任务优先级时</br>传入的优先级参数不正确                              |                        检查任务优先级</br>必须在0~31之间                         |
| LOS_ERRNO_TSK_ENTRY_NULL            | 0x02000204 | 创建任务时传入的任务入口函数为空指针                                                 |                                 定义任务入口函数                                 |
| LOS_ERRNO_TSK_NAME_EMPTY            | 0x02000205 | 创建任务时传入的任务名为空指针                                                       |                                    设置任务名                                    |
| LOS_ERRNO_TSK_STKSZ_TOO_SMALL       | 0x02000206 | 创建任务时传入的任务栈太小                                                           | 增大任务栈大小</br>使之不小于</br>系统设置最小任务栈</br>LOS_TASK_MIN_STACK_SIZE |
| LOS_ERRNO_TSK_ID_INVALID            | 0x02000207 | 无效的任务ID                                                                         |                                    检查任务ID                                    |
| LOS_ERRNO_TSK_ALREADY_SUSPENDED     | 0x02000208 | 任务重复挂起                                                                         |                              等待任务解挂再尝试挂起                              |
| LOS_ERRNO_TSK_NOT_SUSPENDED         | 0x02000209 | 未挂起而解挂任务                                                                     |                                 挂起任务后再尝试                                 |
| LOS_ERRNO_TSK_NOT_CREATE            | 0x0200020a | 任务未创建                                                                           |                                        2                                         |
| LOS_ERRNO_TSK_DELETE_LOCKED         | 0x0300020b | 任务处于锁定状态时删除任务                                                           |                                解锁任务再删除任务                                |
| LOS_ERRNO_TSK_DELAY_IN_INT          | 0x0300020d | 中断期间进行任务延时                                                                 |                              等待中断退出再进行延时                              |
| LOS_ERRNO_TSK_DEALY_IN_LOCK         | 0x0200020e | 任务锁定状态下延时任务                                                               |                              解锁任务之后再进行延时                              |
| LOS_ERRNO_TSK_YIELD_IN_LOCK         | 0x0200020f | 任务锁定状态下调整任务                                                               |                             解锁之后再执行Yield操作                              |
| LOS_ERRNO_TSK_YIELD_NOT_ENOUGH_TASK | 0x02000210 | Yield操作没有足够同优先级任务                                                        |                              增加与之同优先级的任务                              |
| LOS_ERRNO_TSK_TCB_UNAVAILABLE       | 0x02000211 | 创建任务时没有空闲的任务控制块可以使用                                               |                                        3                                         |
| LOS_ERRNO_TSK_OPERATE_SYSTEM_TASK   | 0x02000214 | 删除、挂起、延时系统级别的任务</br>修改系统级别任务的优先级                          |                           检查任务ID，不要操作系统任务                           |
| LOS_ERRNO_TSK_SUSPEND_LOCKED        | 0x03000215 | 挂起处于锁定状态的任务                                                               |                                任务解锁之后再尝试                                |
| LOS_ERRNO_TSK_STKSZ_TOO_LARGE       | 0x02000220 | 创建任务设置了过大的任务栈                                                           |                                    减小任务栈                                    |
| LOS_ERRNO_TSK_CPU_AFFINITY_MASK_ERR | 0x03000223 | 设置指定任务的CPU集合时</br>传入了错误的CPU集合                                      |                                检查传入哦CPU掩码                                 |
| LOS_ERRNO_TSK_TIELD_IN_INT          | 0x02000224 | 中断中对任务进行Yield操作                                                            |                            不要在中断中进行Yield操作                             |
| LOS_ERRNO_TSK_MP_SYNC_RESOURCE      | 0x02000225 | 跨核任务删除同步功能</br>自愿申请失败                                                |                                        4                                         |
| LOS_ERRNO_TSK_MP_SYNC_FAILED        | 0x02000226 | 跨核任务删除同步功能</br>任务未及时删除                                              |                                        5                                         |

1. 增大动态内存空间，有两种方式可以实现
	+ 设置更大的系统动态内存池，配置选项为 `OS_SYS_MEM_SIZE`
	+ 释放一部分动态内存  
	如果错误发生在LiteOS启动过程中的任务初始化，还可以通过减少系统支持的最大任务数来解决  
	如果错误发生在任务创建过程中，也可以减小任务栈大小来解决
	
2. 创建这个任务，这个错误可能会发生在以下操作中
	+ 删除任务
	+ 恢复/挂起任务
	+ 设置指定任务的优先级
	+ 获取指定任务的信息
	+ 设置指定任务的运行CPU集合
3. 调用 `LOS_Task_ResRecyle` 接口回首空闲的任务控制块，如果回收后依然创建失败，在增加系统的任务控制块数量
4. 通过设置更大的 `LOSCFG_BASE_IPC_SEM_LIMIT` 的值，增加系统支持的信号个数
5. 需要检查目标删除任务是否存在频繁的状态切换，导致无法在规定的时间内完成删除的动作


</br>

> 错误码定义 8～15位 表示的是所属模块，本错误码所属任务模块，值为0x02  
> 任务模块中的一些错误码序号未定义，不可用

</br>
详细错误码参考[LiteOS内核开发者手册](https://gitee.com/LiteOS/LiteOS/blob/master/doc/LiteOS_Kernel_Developer_Guide.md)