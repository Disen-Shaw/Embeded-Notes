# uCOS系统移植
## 移植准备工作
### 准备基础工程
移植过程需要一个基本工程，方便里面的某些文件进行移植

### 准备uCOSII源码
从官网下载或者从其他地方下载

## uCOS移植
### 文件准备
`已准备好`
在基础工程中建立相应的文件夹：CONFIG、CORE、PORT
向uCOS中添加文件：source -> CORE
向CONFIG文件夹添加文件：从历程中的CONFIG -> CONFIG
向PORT文件夹中添加文件：PORT->PORT

### 工程文件准备
建立`uCOS_CORE`、`uCOS_PORT`、`uCOS_CONFIG`文件夹
添加对应文件夹内的文件、反复编译直到没有错误



