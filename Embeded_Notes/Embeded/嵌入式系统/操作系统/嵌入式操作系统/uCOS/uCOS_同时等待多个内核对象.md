# uCOSIII同时等待多个内核对象
uCOSIII中允许任务同时等待多个信号量和多个消息队列，**也就是说uCOSIII不支持同时等待`多个事件标志组`或`互斥信号量`**
一个任务可以等待任意数量的信号量和消息队列，**第一个信号量或消息队列发布会导致该任务进入就绪态**

## API函数  
**`OSPendMulti()函数`**
一个任务可以调用函数`OSPendMulti()`来等待多个对象，并且可以根据需要指定一个等待超时值，`函数OSPendMulti()`原型如下：
```c 
OS_OBJ_QTY OSPendMulit(	
						OS_PEND_DATA	*p_pend_data_tbl,
						OS_OBJ_QTY		tbl_size,
						OS_TICK			timeout,
						OS_OPT			opt,
						OS_ERR			*p_err)

```
**在调用函数OSPendMulti()之前需要初始化OS_PEND_DATA数组**，数组大小取决于多任务同时等待的内核对象的总数量。


