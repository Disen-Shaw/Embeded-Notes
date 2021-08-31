# uCOSIII任务的创建和删除
## 任务的创建
uCOSIII想要使用任务，第一件事就是创建一个任务，创建任务使用函数`OSTaskCreate()`
```c
void OSTaskCreate (
					OS_TCB 			*p_tcb,
					CPU_CHAR 		*p_name,
					OS_TASK_PTR 	p_task,
					void 			*p_arg,
					OS_PRIO 		prio,
					CPU_STK 		*p_stk_base,
					CPU_STK_SIZE 	stk_limit,
					CPU_STK_SIZE 	stk_size,
					OS_MSG_QTY 		q_size,
					OS_TICK 		time_quanta,
					void 			*p_ext,
					OS_OPT 			opt,
					OS_ERR 			*p_err);
```
**\*p_tcb：指向任务的任务控制块OS_TCB。**  
\*p_name：指向任务的名字，我们可以给每个任务取一个名字  
**p_task：执行任务代码，也就是任务函数名字**  
\*p_arg：传递给任务的参数  
prio：任务优先级，数值越低优先级越高，用户不能使用系统任务使用的那些优先级！  
**\*p_stk_base：指向任务堆栈的基地址。**  
**stk_limit：任务堆栈的堆栈深度，用来检测和确保堆栈不溢出。**  
**stk_size：任务堆栈大小**  
q_size：UCOSIII中每个任务都有一个可选的内部消息队列，要定义宏OS_CFG_TASK_Q_EN>0，这是才会使用这个内部消息队列。time_quanta：在使能时间片轮转调度时用来设置任务的时间片长度，默认值为时钟节拍除以10。  
\*p_ext：指向用户补充的存储区。  
opt：包含任务的特定选项，有如下选项可以设置。  
+ OS_OPT_TASK_NONE：表示没有任何选项  
+ OS_OPT_TASK_STK_CHK：指定是否允许检测该任务的堆栈  
+ OS_OPT_TASK_STK_CLR：指定是否清除该任务的堆栈  
+ OS_OPT_TASK_SAVE_FP：指定是否存储浮点寄存器，CPU需要有浮点运算硬件并且有专用代码保存浮点寄存器。

\*p_err：用来保存调用该函数后返回的错误码。  

## 任务的删除
不想使用某个任务了，就可以将其删除，删除任务使用函数`OSTaskDel()`，函数原型如下：  

```c
void OSTaskDel(
				OS_TCB	*p_tcb,
				OS_ERR	*p_err);
```

某个任务删除后，他占用的OS_TCB和堆栈就可以再次利用来创建其他的任务。  

尽管uCOSIII郧西在系统中删除任务，但是应该尽量避免这种操作，如果这个任务可能鱼其他任务共享资源，在删除此任务之前，这个被占有的资源没有释放就会产生错误的运行结果。  


## 任务的挂起
当想暂停某个任务，但是又不想删除这个任务的时候，就可以使用函数`OSTaskSuspend()`来得到这个任务挂起，函数原型如下：  
```c
void OSTaskSuspend(	OS_TCB 	*p_tcb,
					OS_ERR	*p_err);
```

## 任务的恢复
当想要某个被挂起的任务恢复，可以调用函数`OSTaskResume()`,函数原型如下：  
```c
void OSTaskResume(	OS_TCB	*p_tcb,
					OS_ERR	*p_err);
```


