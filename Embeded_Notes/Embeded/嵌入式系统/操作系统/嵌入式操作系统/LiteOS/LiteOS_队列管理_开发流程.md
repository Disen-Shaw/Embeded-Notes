# LiteOS 队列管理 开发流程
## 开发流程
### 配置内核队列模块
Kernel --> Enable Queue

### 创建消息队列

### 写队列

### 读队列

## 获取队列信息

### 删除队列

> 队列功能没有平台的差异性

## 注意事项
- 系统支持的最大队列数是指：整个系统的队列资源总个数，而非用户能使用的个数。
	- 例如：系统软件定时器多占用一个队列资源，那么用户能使用的队列资源就会减少一个。
- **创建队列时传入的队列名和flags暂时未使用，作为以后的预留参数。**
- 队列接口函数中的入参timeout是相对时间。
- LOS_QueueReadCopy和LOS_QueueWriteCopy及LOS_QueueWriteHeadCopy是一组接口，LOS_QueueRead和LOS_QueueWrite及LOS_QueueWriteHead是一组接口，两组接口需要配套使用。
- 鉴于LOS_QueueWrite和LOS_QueueWriteHead和LOS_QueueRead这组接口实际操作的是数据地址，用户必须保证调用LOS_QueueRead获取到的指针所指向的内存区域在读队列期间没有被异常修改或释放，否则可能导致不可预知的后果。
- 鉴于LOS_QueueWrite和LOS_QueueWriteHead和LOS_QueueRead这组接口实际操作的是数据地址，也就意味着实际写和读的消息长度仅仅是一个指针数据，因此用户使用这组接口之前，需确保创建队列时的消息节点大小，为一个指针的长度，避免不必要的浪费和读取失败。
-  当队列使用结束后，如果存在动态申请的内存，需要及时释放这些内存。