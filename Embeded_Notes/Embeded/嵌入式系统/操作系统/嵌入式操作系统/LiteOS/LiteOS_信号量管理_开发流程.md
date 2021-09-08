# LiteOS 信号量管理 开发流程
## 开发流程
### 配置信号量内核参数
通过 `make menuconfig` 配置信号量模块  
菜单路径为 Kernel --> Enable Sem

### 创建信号量
通过 `LOS_SemCreate`，若要创建二值信号量则调用LOS_BinarySemCreate

### 申请信号量
申请信号量 `LOS_SemPend`

### 释放信号量
释放信号量 `LOS_SemPost`

### 删除信号量
删除信号量 `LOS_SemDelete`

> LiteOS 信号量没有平台差异性

## 注意事项
由于中断不能被阻塞，因此不能在中断中使用阻塞模式申请信号量