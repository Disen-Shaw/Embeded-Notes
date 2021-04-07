# STM32_FLASH串行文件系统
1. 将文件夹拷贝到工程中，将src文件夹整个拷贝到USER文件夹下，并改名为FATFs
2. 打开工程,并将 FatFs 组件文件添加到工程中需要添加有
	+ ff.c
	+ diskio.c
	+ cc936.c

	三个文件
3. 配置包含关系，完善工程
4. 如果现在编译工程,可以发现有两个错误,一个是来自 diskio.c 文件,提示有一
些头文件没找到,diskio.c 文件内容是与底层设备输入输出接口函数文件,不同硬
件设计驱动就不同,需要的文件也不同;另外一个错误来自 cc936.c 文件,提示该
文件不是工程所必需的,这是因为 FatFs 默认使用日语,我们想要支持简体中文
需要修改 FatFs 的配置,即修改 ffconf.h 文件。至此,将 FatFs 添加到工程的框架
已经操作完成,接下来要做的就是修改 diskio.c 文件和 ffconf.h 文件


## FatFs 底层设备驱动函数
FatFs 文件系统与底层介质的驱动分离开来,对底层介质的操作都要交给用户去实现,它仅仅是提供了一个函数接口而已
FatFs 移植时用户必须支持的函数如下：

|函数|条件|备注|
|---|---|---|
|disk_status</br>disk_initialize</br>disk_read|总是需要|底层设备驱动函数|
|disk_write</br>get_fattime</br>disk_ioctl(CTRL_SYNC)|_FS_READONLY == 0|底层设备驱动函数|
|disk_ioctl (GET_SECTOR_COUNT)</br>disk_ioctl (GET_BLOCK_SIZE)|_USE_MKFS == 1|底层设备驱动函数|
|disk_ioctl (GET_SECTOR_SIZE)|_MAX_SS != _MIN_SS|底层设备驱动函数|
|ff_convert</br>ff_wtoupper|_USE_LFN != 0|Unicode 支持,为支持简体中文 , 添加cc936.c 到工程即可|
|ff_cre_syncobj</br>ff_del_syncobj</br>ff_req_grant</br>ff_rel_grant|_FS_REENTRANT == 1|FatFs 可重入配置,需要多任务系统支持</br>(一般不需要)|
|ff_mem_alloc</br>ff_mem_free|_USE_LFN == 3|长文件名支持,缓冲区设置在堆空间 </br>(一般设置_USE_LFN = 2 )|

底层设备驱动函数是存放在 diskio.c 文件
我们的目的就是把 diskio.c 中的函数接口与SPI Flash 芯片驱动连接起来
总共有五个函数,分别为
+ 设备状态获取(disk_status)
+ 设备初始化(disk_initialize)
+ 扇区读取(disk_read)
+ 扇区写入(disk_write)
+ 其他控制(disk_ioctl)

使用SPI编程
1. 初始化通讯使用的引脚和时钟
2. 使能SPI外设
3. 配置SPI的外设模式、地址、速率等参数，并使用SPI外设
4. 编写SPI发送函数
~~~c
/* 为每个设备定义一个物理编号 */
#define ATA 0   	// 预留 SD 卡使用
#define SPI_FLASH 1	// 外部 SPI Flash
~~~
**FatFs 是支持多物理设备的,必须为每个物理设备定义一个不同的编号**
SD 卡是预留接口，可以读写SD卡内存芯片

设备状态读取
~~~c
DSTATUS disk_status (
	BYTE pdrv /* 物理编号 */
)
{
	DSTATUS status = STA_NOINIT;
	switch (pdrv) 
	{
		case ATA: /* SD CARD */
		break;
		case SPI_FLASH:
		/* SPI Flash 状态检测:读取 SPI Flash 设备 ID */
		if (sFLASH_ID == SPI_FLASH_ReadID()) 
		{
			/* 设备 ID 读取结果正确 */
			status &= ~STA_NOINIT;
		} 
		else
		{
			/* 设备 ID 读取结果错误 */
			status = STA_NOINIT;;
		}
		break;
		default:
		status = STA_NOINIT;
	}
	return status;
}
~~~

设备初始化
~~~c
DSTATUS disk_initialize (
	BYTE pdrv 	/* 物理编号 */
)
{
	uint16_t i;
	DSTATUS status = STA_NOINIT;
	switch (pdrv) 
	{
		case ATA:
		{
			/* SD CARD */
			break;
		}
		case SPI_FLASH:		/* SPI Flash */
		{
			/* 初始化 SPI Flash */
			SPI_FLASH_Init();
			/* 延时一小段时间 */
			i=500;
			while (--i);
			/* 唤醒 SPI Flash */
			SPI_Flash_WAKEUP();
			/* 获取 SPI Flash 芯片状态 */
			status=disk_status(SPI_FLASH);
			break;
		}	
		default:
			status = STA_NOINIT
	}
	return status;
}
~~~
读取扇区
~~~c
DRESULT disk_read (

	BYTE pdrv,		/* 设备物理编号(0..) */
	BYTE *buff,		/* 数据缓存区 */
	DWORD sector, 	/* 扇区首地址 */
	UINT count 		/* 扇区个数(1..128) */
)
{
	DRESULT status = RES_PARERR;
	switch (pdrv) 
	{
		case ATA: /* SD CARD */
			break;
		case SPI_FLASH:
		{
			/* 扇区偏移 2MB,外部 Flash 文件系统空间放在 SPI Flash 后面 6MB 空间 */
			sector+=512;
			SPI_FLASH_BufferRead(buff, sector <<12, count<<12);
			status = RES_OK;
			break;
			default:
			status = RES_PARERR;
		}
	}
	return status;
}
~~~
扇区写入
~~~c
DRESULT disk_write (

	BYTE pdrv,			/* 设备物理编号(0..) */
	const BYTE *buff, 	/* 欲写入数据的缓存区 */
	DWORD sector,		/* 扇区首地址 */
	UINT count			/* 扇区个数(1..128) */

)
{
	uint32_t write_addr;
	DRESULT status = RES_PARERR;
	if (!count) 
	{
		return RES_PARERR;
		/* Check parameter */
	}
	switch (pdrv) 
	{
		case ATA: /* SD CARD */
			break;
		case SPI_FLASH:
		{
			/* 扇区偏移 2MB,外部 Flash 文件系统空间放在 SPI Flash 后面 6MB 空间 */
			sector+=512;
			write_addr = sector<<12;
			SPI_FLASH_SectorErase(write_addr);
			SPI_FLASH_BufferWrite((u8 *)buff,write_addr,count<<12);
			status = RES_OK;
			break;
		}
		default:
			status = RES_PARERR;
	}
	return status;
}
~~~
其他控制
~~~c
DRESULT disk_ioctl (
	BYTE pdrv,	/* 物理编号 */
	BYTE cmd,	/* 控制指令 */
	void *buff	/* 写入或者读取数据地址指针 */
)
{
	DRESULT status = RES_PARERR;
	switch (pdrv) 
	{
		case ATA: /* SD CARD */
			break;
		case SPI_FLASH:
		{
			switch (cmd) 
			{
				/* 扇区数量:1536*4096/1024/1024=6(MB) */
				case GET_SECTOR_COUNT:
				{
					*(DWORD * )buff = 1536;
					break;
				}
				/* 扇区大小 */
				case GET_SECTOR_SIZE :
				{
					*(WORD * )buff = 4096;
					break;
				}
				/* 同时擦除扇区个数 */
				case GET_BLOCK_SIZE :
				{
					*(DWORD * )buff = 1;
					break;
				}
			status = RES_OK;
			break;
			}
		}
		default:
			status = RES_PARERR;
	}
	return status;
}
~~~

时间戳获取
~~~c
__weak DWORD get_fattime(void)
{
	/* 返回当前时间戳 */
	return 	((DWORD)(2015 - 1980) << 25) 	/* Year 2015 */
			| ((DWORD)1 << 21)				/* Month 1 */
			| ((DWORD)1 << 16)				/* Mday 1 */
			| ((DWORD)0 << 11)				/* Hour 0 */
			| ((DWORD)0 << 5)				/* Min 0 */
			| ((DWORD)0 >> 1);				/* Sec 0 */
}
~~~
+ bit31:25 ——从 1980 至今是多少年,范围是 (0..127)
+ bit24:21 ——月份,范围为 (1..12)
+ bit20:16 ——该月份中的第几日,范围为(1..31)
+ bit15:11——时,范围为 (0..23)
+ bit10:5 ——分,范围为 (0..59)
+ bit4:0 ——秒/ 2,范围为 (0..29)

## FATFs功能配置
~~~c
#define	_USE_MKFS		1
#define	_CODE_PAGE		936
#define _USE_LFN		2
#define _VOLUMES		2
#define _MIN_SS			512
#define _MAX_SS			4096
~~~
+ \_USE_MKFS:格式化功能选择,为使用 FatFs 格式化功能,需要把它设置为 1
+ \_CODE_PAGE:语言功能选择,并要求把相关语言文件添加到工程宏
+ \_USE_LFN:长文件名支持,默认不支持长文件名,这里配置为 2,支持长文件名,并指定使用栈空间为缓冲区
+ \_VOLUMES:指定物理设备数量,这里设置为 2,包括预留 SD 卡和 SPI Flash 芯片
+ \_MIN_SS、\_MAX_SS:指定扇区大小的最小值和最大值。SD 卡扇区大小一般都
为 512 字节,SPI Flash 芯片扇区大小一般设置为4096字节,所以需要把_MAX_SS 改为 4096
