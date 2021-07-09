# FatFS文件系统
## 简介
FatFs是面向小型嵌入式系统的一种通用的FAT文件系统，它完全由ASCII c语言编写并且完全独立于底层的I/O介质，因此它可以很容易地不加修改地移植到其他的处理器中
例如8051、PIC、AVR、SH、Z80、H8、ARM等

FatFs支持FAT12、FAT16、FAT32等格式

利用写好的SPI Flash芯片驱动，把FatFs文件系统代码移植到工程中，就可以利用文件系统的各种函数，对SPI Flash芯片以"文件格式"进行读写操作了
[官网](http://elm-chan.org/fsw/ff/00index_e.html)

## 源码文件结构
源码包下载后并解压后有以下文件
+ documents：帮助文档
+ source：系统源代码
+ LICENSE.txt：许可协议

### 帮助文档
doc和res两个文件夹里是编译好的html文档，里面有FatFs里面各个函数的使用方法
00index_e.html是关于FatFs的介绍
### FatFs源码
#### diskio.c
包含底层存储介质的操作函数，这些函数需要用户自己实现，主要添加底层驱动函数

#### ff.c
FatFs核心文件，文件管理的实现方法
独立于底层介质操作文件的函数，利用这些函数实现文件的读写

#### ffunicode.c
在option目录下，是简体中文支持所需要添加的文件，包含了简体中文的GBK和Unicode相互转换功能函数

#### ffconf.c
包含了对FatFs功能配置的宏定义，通过修改这些红定义就可以裁剪FatFs的功能
例如如果需要支持简体中文，就要把ffconf.h中的_CODE_PAGE的宏改成936并把上面的cc636.c文件加入到工程中

#### ffsystem.c
支持RTOS，提供FatFs功能的县城安全保障功能

## FatFs在程序中的关系网络
![[Pasted image 20210612021531.png]]
用户应用程序由用户编写，想实现什么功能就写什么程序
一般只用到下面几个程序
f_mount()、f_open()、f_write()、f_read()
就可以实现文件的读写操作
这些应用层函数使用方法与标准C的文件操作函数类似

FatFs组件时FatFs的主体，文件都在源码source文件夹中，只需要修改ffconf.h和diskio.c两个文件，实现上层应用与底层驱动设备的交互

底层设备输入输出要求实现存储设备的读写操作函数、存储设备信息获取函数等

## 移植用户需要修改的函数
### 底层设备驱动函数
#### 总是需要
+ disk_status()
+ disk_initialize()
+ disk_read()

#### \_FS\_READONLY == 0
+ disk_write()
+ disk_attime()
+ disk_ioctl(CTRL_SYNC)

#### \_USE\_MKFS == 1
+ disk_isctl(GET\_SECTOR\_COUNT)
+ disk_isctl(GET\_BLOCK\_SIZE_)

#### \_MAX\_SS != \_MIN\_SS
+ disk_isctl(GET\_SECTOR\_SIZE)

### Unicode支持
为添加简体中文支持，添加ffunicode.c到工程中即可
#### \_USE\_LFN != 0
+ ff_uni2oem()
+ ff_owm2nui
+ ff_wtoupper

### FatFs可重入配置
需要多任务系统支持，裸机环境下不需要
#### \_FS\_REENTRANT == 1
+ ff_cre_syncobj()
+ ff_del_syncobj()
+ ff_req_grant()
+ ff_rel_grant()

### 长文件名支持
缓冲区设置在堆空间
一般设置\_USE\_LFN = 2，在栈中
#### \_USE\_LFN == 3
+ ff_men_alloc()
+ ff_mem_free()
