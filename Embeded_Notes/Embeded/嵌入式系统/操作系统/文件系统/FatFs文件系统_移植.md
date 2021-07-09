# FatFs文件系统移植
基于STM32
## 移植到工程中
**将下载好的FatFs源码(一堆.c文件)移植到工程中**
尝试构建工程，查看错误

**先去到diskio.c文件**
代码中有一些是用不到的，需要删除
在查看dev中是否有需要驱动的设备，例如Flash
没有Flash，就
```c
/* 只有一个Flash */
#define DEV_FLASH 0
```
将没有用的函数都删掉
错误的函数可以查询网站的函数说明进行更改
有部分函数为定义却使用了，删除即可或者实现对应函数


**实现FatFs和底层的驱动的接口**
初始化检测
disk_status()函数可以使用获取设备ID的方式来重构，也可以读取寄存器的状态
```c
DSTATUS disk_status(BYTE pdrv){
	DSTATUS stat;
	switch(pdrv){
		if(sFLASH_ID != SPI_FLASH_ID())
			stat = RES_ERROR;
		else
			status = RES_OK;
	}
	return stat;
}
```
初始化驱动、读写函数
读写函数中对扇区操作要有一些换算
例如
SPI_FLASH_BufferRead(buff,sector\*4096,count\*4096)


**配置FatFs的功能**
通过ffconf.h文件，来配置FatFs的各种功能，如读写等
具体：
\#define FF_USE_MKFS 1 		//使用格式化的功能
\#define FF_CODE_PAGE 936 	//修改编码页。以支持中文
\#define FF_USE_LFN  1		// 支持长文件名
 \#define FF_MAX_SS 4096 	// 修改支持的最大的设备扇区的大小，与Flash设备对应


### 使用文件系统
1. 挂在文件系统到另一个设备上
2. 打开一个文件
3. 数据读取或者写入
4. 操作完成后，将文件关闭

**注意事项**
要注意文件指针的位置

## 使用CubeMX移植文件系统
在构建时打开Middleware，里面有FatFs系统
一些存储介质在CubeMX中没有预支持，选择哟用户定义

CubeMX说明
+ 文件系统和心文件ff.c没有修改
+ 对底层diskio.c文件借口修改，使用通用驱动接口
	+ 封装了一层Disk_drvTyeDef驱动结构体
+ ff_gen_irv.c文件与Disk_drvTyeDef结构体进行适配
+ xx_diskio.c文件用于添加底层的驱动，需要用户自己来添加，对应具体的设备驱动
+ fatfs.c文件用于上层应用开发，具体到对文件系统的使用

Disk_dryTypeDef结构体
```c
typedef struct{
	uint8_t is_initialized[_VOLUMES];
	const Diskio_dryTypeDef *dry[VOLUMES];
	uint8_t lun[_VOLUMES];
	volatile uint8_t nbr;
}
```
### 调用过程
首先调用了
FATFS_LinkDriver(Diskio_dry_TypeDef,UserPath)函数

## 对比
+ 对驱动的连接(diskio.c)文件实现不同
	+ CubeMX对其进行了一层驱动结构体的封装
	+ 用ff_gen_drv.c注册管理驱动，决定哪些驱动使用文件系统，哪些不使用文件系统






