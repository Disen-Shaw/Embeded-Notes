# FreeRTOS任务的挂起和恢复
## 任务挂起和恢复的API函数
有时候需要暂停某个任务的运行，过一段时间以后再重新运行。这个时候要是使用任务删除和重建的方法的话那么任务中变量保存的值肯定丢失了  
FreeRTOS提供了解决这种问题的方法，那就是任务挂起和恢复，当某个任务要停止运行一段时间的话就将这个任务挂起，当要重新运行这个任务的话就恢复这个任务的运行  
类似uCOS中的  
+ `OSTaskSuspend()`  
+ `OSTaskResume()`  

| 函数                 | 描述                             |
| -------------------- | -------------------------------- |
| vTaskSuspend()       | 挂起一个任务(传入NULL挂起自身)   |
| vTaskResume()        | 恢复一个任务的运行               |
| xTaskResumeFromISR() | 中断服务函数中恢复一个任务的运行 | 

### 函数vTaskSuspend()
用于将某个任务设置为挂起态，进入挂起态的任务永远都不会进入运行态。退出挂起态的唯一方法就是调用任务恢复函数`vTaskResume()`或`xTaskResumeFromISR()`，函数原型如下：
```c
void vTaskSuspend( TaskHandle_t xTaskToSuspend)
```
参数：xTaskToSuspend  
要挂起的任务的任务句柄，创建任务的时候会为每个任务分配一个任务句柄  
返回值：无  
### 函数vTaskResume()
将一个任务从挂起态恢复到就绪态，只有通过函数`vTaskSuspend()`设置为挂起态的任务才可以使用`vTaskRexume()`恢复，函数原型如下:  
```c
void vTaskResume( TaskHandle_t xTaskToResume)
```
参数：  
xTaskToResume：要恢复的任务的任务句柄  
返回值：无  

### 函数xTaskResumeFromISR()
此函数是`vTaskResume()`的中断版本，**用于在中断服务函数中恢复一个任务。**  
参数：  
xTaskToResume:要恢复的任务的任务句柄  
返回值:  
+ pdTRUE:恢复运行的任务的任务优先级等于或者高于正在运行的任务(被中断打断的任务)，这意味着在退出中断服务函数以后必须进行一次上下文切换  
+ 恢复运行的任务的任务优先级低于当前正在运行的任务(被中断打断的任务)，这意味着在退出中断服务函数的以后不需要进行上下文切换  


