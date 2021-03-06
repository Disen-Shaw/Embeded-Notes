# LiteOS 软件定时器 开发流程
## 开发流程
### 内核参数配置
通过 `make menuconfig` 配置软件定时器  
菜单路径为：Kernel —> Enable Software Timer

### 创建定时器
创建定时器LOS_SwtmrCreate，设置定时器的定时时长、定时器模式、超时后的回调函数

### 启动定时器
启动定时器LOS_SwtmrStart

### 获得软件定时器剩余Tick数
获得软件定时器剩余Tick数LOS_SwtmrTimeGet

### 停止定时器
通过 `LOS_SwtmrStop` 停止定时器

### 删除定时器
通过 `LOS_SwtmrDelete` 删除定时器

## 注意事项
- 软件定时器的回调函数中不应执行过多操作，不建议使用可能引起任务挂起或者阻塞的接口或操作，如果使用会导致软件定时器响应不及时，造成的影响无法确定。
- **软件定时器使用了系统的一个队列和一个任务资源**。
- 软件定时器任务的优先级设定为0，且不允许修改 。
- 系统可配置的软件定时器个数是指：整个系统可使用的软件定时器总个数，并非用户可使用的软件定时器个数。例如：系统多占用一个软件定时器，那么用户能使用的软件定时器资源就会减少一个。
- 创建单次不自删除属性的定时器，用户需要自行调用定时器删除接口删除定时器，回收定时器资源，避免资源泄露。
- 软件定时器的定时精度与系统Tick时钟的周期有关。
