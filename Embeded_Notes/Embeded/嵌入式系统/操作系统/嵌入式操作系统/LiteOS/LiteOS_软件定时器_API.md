# LiteOS 软件定时器 API
## 使用场景
- 创建一个单次触发的定时器，超时后执行用户自定义的回调函数
- 创建一个周期性触发的定时器，超时后执行用户自定义的回调函数


## 定时器创建和删除
| 接口名          | 描述                                                                 |
| --------------- | -------------------------------------------------------------------- |
| LOS_SwtmrCreate | 创建定时器，设置定时器定时时长、定时器模式、回调函数，并返回定时器ID |
| LOS_SwtmrDelete | 删除定时器                                                           |

## 定时器启动和停止
| 接口名         | 描述       | 
| -------------- | ---------- |
| LOS_SwtmrStart | 启动定时器 |
| LOS_SwtmrStop  | 停止定时器 |

## 获取软件定时器剩余Tick数
**LOS_SwtmrTimeGet**  
获得软件定时器剩余的 Tick 数

## 软件定时器内核参数
| 配置项                                | 含义                     | 取值范围                                       | 默认值 | 依赖                   |
| ------------------------------------- | ------------------------ | ---------------------------------------------- | ------ | ---------------------- |
| LOSCFG_BASE_CORE_SWTMR                | 软件定时器裁剪开关       | YES/NO                                         | YES    | LOSCFG_BASE_IPC_QUEUE  |
| LOSCFG_BASE_CORE_SWTMR_LIMIT          | 最大支持的软件定时器数   | <65535                                         | 1024   | LOSCFG_BASE_CORE_SWTMR |
| LOSCFG_BASE_CORE_SWTMR_IN_ISR         | 在中断中直接执行回调函数 | YES/NO                                         | NO     | LOSCFG_BASE_CORE_SWTMR |
| LOSCFG_BASE_CORE_TSK_SWTMR_STACK_SIZE | 软件定时器任务栈大小     | \[LOSCFG_TASK_MIN_STACK_SIZE, OS_SYS_MEM_SIZE) | 24567  | LOSCFG_BASE_CORE_SWTMR | 

菜单路径为：Kernel --> Basic --> Task

如果上述API调用发生错误，应参考：
[[LiteOS_软件定时器_错误码]]

