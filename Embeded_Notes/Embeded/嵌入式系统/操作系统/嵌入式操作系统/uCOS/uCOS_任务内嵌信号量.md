# uCOSIII任务内嵌信号量
在uCOSIII中每个任务都有自己的内嵌信号量，这种功能不仅能够简化代码，而且比使用独立信号量更有效。
任务信号量是直接内嵌在uCOSIII中的，相关代码在os_task.c中

## API
| 函数名               | 作用                   |
| -------------------- | ---------------------- |
| OSTaskSemPend()      | 等待一个任务信号量     |
| OSTaskSemPendAbort() | 取消等待任务信号量     |
| OSTaskSemPost()      | 发布任务信号量         |
| OSTaskSemSet()       | 强行设置任务信号量计数 |

不需要创建信号量结构体


