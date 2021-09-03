# LiteOS内核启动流程以及使用约束
## 内核启动流程
![[Pasted image 20210903101529.png]]

## 使用约束
+ LiteOS提供一套自有的OS接口，同时也支持 `POSIX` 和 `CMSIS` 接口
	+ 不要混用这些接口，可能导致不可预知的错误
	+ 例如用 `POSIX` 接口申请信号量，但使用 `LiteOS` 接口释放信号量
+ 开发驱动只能使用 `LiteOS` 的接口，上层APP建议使用 `POSIX` 接口

