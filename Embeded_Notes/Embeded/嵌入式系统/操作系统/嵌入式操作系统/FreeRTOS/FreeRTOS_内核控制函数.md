# FreeRTOS内核控制
## 内核控制函数API
| 函数                          | 描述                             |
| ----------------------------- | -------------------------------- |
| taskYIELD                     | 任务切换                         |
| taskENTER_CRITICAL()          | 进入临界区，用于任务中。         |
| taskEXIT_CRITICAL()           | 退出临界区，用于任务中。         |
| taskENTER_CRITICAL_FROM_ISR() | 进入临界区，用于中断服务函数中。 |
| taskEXIT_CRITICAL_FROM_ISR()  | 退出临界区，用于中断服务函数中。 |
| taskDISABLE_INTERRUPTS()      | 关闭中断。                       |
| taskENABLE_INTERRUPTS()       | 打开中断。                       |
| vTaskStartScheduler()         | 开启任务调度器。                 |
| vTaskEndScheduler()           | 关闭任务调度器。                 |
| vTaskSuspendAll()             | 挂起任务调度器。                 |
| xTaskResumeAll()              | 恢复任务调度器。                 |
| vTaskStepTick()               | 设置系统节拍值                   |


