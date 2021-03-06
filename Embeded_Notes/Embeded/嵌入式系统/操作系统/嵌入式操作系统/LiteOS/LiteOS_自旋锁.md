# LiteOS 自旋锁
## 概述
**在多核环境中**，由于使用相同的内存空间，存在对同一资源进行访问的情况  
所以**需要互斥访问机制来保证同一时刻只有一个核进行操作**  
自旋锁就是这样的一种机制  

自旋锁是指当一个线程在获取锁时，如果锁已经被其它线程获取，那么该线程将循环等待，并不断判断是否能够成功获取锁，直到获取到锁才会退出循环。  
因此建议保护耗时较短的操作，防止对系统整体性能有明显的影响。

自旋锁与互斥锁比较类似，它们都是为了解决对共享资源的互斥使用问题  
无论是互斥锁，还是自旋锁，在任何时刻，最多只能有一个持有者

但是两者在调度机制上略有不同，对于互斥锁，如果锁已经被占用，锁申请者会被阻塞  
但是自旋锁不会引起调用者阻塞，会一直循环检测自旋锁是否已经被释放  

[[LiteOS_自旋锁_API]]