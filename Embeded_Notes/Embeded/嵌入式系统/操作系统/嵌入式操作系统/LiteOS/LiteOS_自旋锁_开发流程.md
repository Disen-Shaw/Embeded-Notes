# LiteOS 自旋锁 开发流程
## 配置开发流程
### 配置内核参数
通过 `make menuconfig` 进行配置，参数如 [[LiteOS_自旋锁_API]] 的最后一项  
菜单路径为 Kernel-->Enable Kernel SMP

### 创建自旋锁
使用 `LOS_SpinInit` 动态初始化自旋锁，或者使用 `SPIN_LOCK_INIT` 初始化静态内存的自旋锁

### 申请自旋锁
使用接口 `LOS_SpinLock/LOS_SpinTrylock/LOS_SpinLockSave` 申请指定的自旋锁

+ 申请成功就继续往后执行锁保护的代码
+ 申请失败在自旋锁申请中忙等，直到申请到自旋锁为止

### 释放自旋锁
使用 `LOS_SpinUnlock/LOS_SpinUnlockRestore` 接口释放自旋锁。  
锁保护代码执行完毕后，释放对应的自旋锁，以便其他核申请自旋锁

## 注意事项
- 同一个任务不能对同一把自旋锁进行多次加锁，否则会导致死锁。
- 自旋锁中会执行本核的锁任务操作，因此需要等到最外层完成解锁后本核才会进行任务调度。
- `LOS_SpinLock` 与 `LOS_SpinUnlock` 允许单独使用，即可以不进行关中断，但是用户需要保证使用的接口只会在任务或中断中使用。
	- 如果接口同时会在任务和中断中被调用，请使用
		- LOS_SpinLockSave
		- LOS_SpinUnlockRestore  
		因为在未关中断的情况下使用 `LOS_SpinLock` 可能会导致死锁。
- 耗时的操作谨慎选用自旋锁，可使用互斥锁进行保护。
- 未开启SMP的单核场景下，自旋锁功能无效，只有 `LOS_SpinLockSave` 与 `LOS_SpinUnlockRestore` 接口有关闭恢复中断功能。
- 建议 `LOS_SpinLock` 和 `LOS_SpinUnlock`，`LOS_SpinLockSave` 和 `LOS_SpinUnlockRestore` 配对使用，避免出错。


