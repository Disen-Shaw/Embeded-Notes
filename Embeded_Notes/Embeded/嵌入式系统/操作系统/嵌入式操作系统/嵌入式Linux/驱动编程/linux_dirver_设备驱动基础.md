# Linux设备驱动基础
## 内核空间和用户空间
内核有特权，用户空间受到一定的限制，这是现代CPU的功能，它可以运行在特权模式和非特权模式之间

### 内核空间
内核驻留和运行的地址空间
内核可以访问整个系统，因为它在系统上有更高的优先级

### 用户空间
正常程序被限制运行的地址空间
用户程序运行内核空间的唯一方式就是通过系统调用
例如read、write、open、close等

## 模块
模块就像是Linux内核的插件
模块动态扩展了内核功能，可以不需要重启计算机，达成即插即用

为了支持模块，构建内核时必须启用下面的选项：CONFIG_MODULES=y

## 模块依赖
Linux内核中的模块可以提供函数或者变量，用EXPORT_SYMBOL宏导出它们就可以供其他模块使用，这些依赖被称为符号
模块B对模块A的以来指的是模块B使用从模块A的符号

**在内核构建过程中可以使用`depmod`工具生成依赖文件**
它读取/lib/modeuls/\<kernel_release>\\中的每个模块确定其应该导出哪些符号以及它需要什么符号
就是确定以来关系

## 模块的加载和卸载
模块要运行就要把它加载到内核中，可以用insmod护着modprobe来实现
前者制定模块的路径作为参数，开发期间的首选
后者更智能化，生产系统的首选

### 手动加载
手动加载要用户干预，获得root权限
开发过程中常使用insmod来加载模块，并且要给出模块的路径

insmod /path/to/modules.ko

这种模块加载形式低级，但是是其他模块加载方法的基础
系统管理员在生产系统中常使用modprobe
modprobe更加智能，它在加载指定的模块之前解析文件modules.dep来首先加载依赖关系
它会自动处理依赖关系

如果要在启动时加载模块，需要创建文件
/etc/modules-load.d/\<filename>.conf，并且添加模块名称，每行一个

### 自动加载
`depmod`程序不只是构建modules.dep和modules.dep.bin文件
内核开发人员实际编写驱动程序时几经确切知道了该驱动程序将要支持的硬件
他们把驱动程序支持的所有设备的产品和厂商ID提供给驱动程序，depmod还处理文件模块来提取和收集该信息
并在/lib/modiles/<kernel_ release>/model.alias中生成modules.alias文件

在这一步，需要一个用户空间热插拔代理(或者设备管理器)，通常是udev(或者mdev)，它将在内核中注册，以便出现新设备时得到通知
通知由内核发布，它将设备描述符(pid,vid、类、设备类、设备子类、接口以及可标识设备的所有其他信息)发送到热插拔守护进程，守护进程再调用modpobe，并向其传递描述信息
接下来modprobe解析modules.alias文件，匹配与该设备相关的驱动
在加载模块前，modprobe会在moduled.dep中查找与其有依赖关系的模块
如果发现，则在相关模块加载前加载依赖模块
否则，直接加载模块

### 模块卸载
常用的模块卸载命令是rmmod，多用这个命令卸载insmod命令加载的模块
使用该命令时，将模块名称作为参数向该模块传递
模块卸载是内核的一项功能，该功能的启用或者关闭由CONFIG_MODULE_ UNLOAD配置值决定

下面的设置开启模块卸载功能

CONFIG_MODULE_ UNLOAD=y

在运行时，如果模块会导致其他不好的影响，即使有人要求卸载，内核也会阻止

内核通过引用计数记录模块的使用次数，这样知道模块是否在用
如果内核认为删除一个模块不安全，就不会删除

可以用下面的语句改变这样的设定

MODULES_FORCE_UNLOAD=y

这样就可以强制卸载模块
rmmod -f mymodule

modeprobe是更高级的模块卸载命令，
modeprobe -r  somemodules

## 驱动程序框架
hello,world模块框架
```c
/* 包含头文件 */
#include <linux/init.h>
#include <linux/modules.h>
#include <linux/kernel.h>

static int __init helloworld(void){
	pr_info("hello,world!\n");
	return 0;
}


static void __exit helloworld__exit(void){
	pr_info("hello,world!\n");
}

module_init(helloworld_init);
module_exit(helloworld_exit);
MODULE_AUTHOR("Disen Shaw <shaodisheng1314@gmail.com>");
MODULE_LICENSE("GPL");

```
### 模块的入点和出点
内核驱动程序都有入点和出点
入点：模块加载时调用的函数
出点：模块卸载时执行的函数

对于内核模块，入点可以随意命名，不用一定定义成main
而出点由特定的出点函数中执行

modules_init()用于模块声明加载
modules_exit()用于声明模块卸载

使用insmod或者modprobe时调用加载函数
使用rmmod时调用卸载函数

#### __init和__exit
##### __init
\_\_init用于告诉编译器该代码为内核对象文件的专用部分，这部分实现为内核所知，它在加载模块和init时会被释放
这只适用于内置驱动程序，而不适用于可加载模块
内核在启动过程中第一次运行驱动程序的初始化函数

##### __exit
驱动程序不能卸载，因此下次重启之前不会再调用init函数，没有必要在init函数内记录引用次数
对于__exit也是这样，在将模块静态编译到内核或未启用模块卸载功能时，其相应的代码会被忽略，因此在这两种情况下都不会调用exit函数


##### 工作方式
涉及可执行文件ELF
执行`objdump -h module.ko`即可打印出指定内核模块的不同组成部分
+ .text：包含程序代码，称之为代码
+ .data：包含初始化数据，称之为数据段
+ .rodata：用于存储只读数据
+ .comment：注释
+ 未初始化的数据段也被称之为符号开始的块

其他部分由内核的需要添加
.modoinfo存储模块相关信息
.init.text存储以__init宏为前缀的代码

Linux内核提供一个自定义的LDS(链接)文件
它位于arch/\<arch>/kernel/vmlinux.lds.S中
对于要放置在内核LDS文件所映射的专用部分的符号中，使用\_\_init和\_\_exit进行标记

\_\_init 和 \_\_exit是Linux的指令(实际上是宏)，他们使用C编辑器属性指定符号的位置，这些指令指示编译器将以它们为前缀的代码分别放置在.init.text和.exit.text部分

#### 模块信息
内核模块使用其.modinfo来存储关于模块的信息
所有MODULE\_\*的宏都用参数传递值来更新这部分内容
例如：
```c
MODULE_AUTHOR()			// 作者
MODULE_DESCRIPTION()	// 描述
MODULE_LICENSE()		// 许可
```
内核信息的真正底层宏是
```c
MODULE_INFO(tag,info)
```
它添加信息的一般格式为
tag=info
意味着驱动作者可以添加任何要添加的内容
例如：
```c
MODULE_INFO(my_field_name,"Disen Shaw");
```
在给定模块上执行
objdump -d -j .modinfo 命令可以转储内核模块.modinfo部分的内容

modinfo部分可以看作是模块的数据表，实际格式化打印信息的用户空间工具是modinfo工具

除了自定义信息之外，还应该提供标准信息，内核为这些信息提供宏，包括许可、作者、参数描述、版本和描述


### 错误和消息打印
错误代码由内核或者用户空间应用程序(通过errno变量)解释
`错误处理很重要，不止在内核空间中。`
#### 错误处理
为了保持清楚，内核树中预定义了几乎所有的错误
一些错误在include/uapi/asm-generic/errno-base.h中定义
列表的其余错误可以在include/uapi/asm-generic/errno.h中

大多数情况下，经典的错误返回方式是
return -ERROR，特别是在响应系统调用中
对于I/O设备了来说，错误代码是-EIO，应该执行的语句是
return -EIO

错误有时候会跨越内核空间
如果返回的错误是对系统的调用(open、close、ioctl、nmap等)的响应，则该值将自动赋值给errno变量，在该变量上调用strerror(errno)可以将错误转化为可读字符串
例如
```c
#include <errno.h>
#include <string.h>
[...]
if(wite(fd,bufm1)< 0){
	printf("Some thing wrong for %s",strerror(errno));
}
[...]
```
在发生错误是，必须撤销之前的所有设置，通常的做法是用goto
```c
ptr=kmalloc(sizeof (device_t));
if(!ptr){
	ret=-ENOME;
	goto err_alloc;
}
dev=init($ptr);
if(dev){
	ret=-EIO;
	goto err_init;
}
return 0;

error_alloc:
	free(ptr);

error_init:
	return ret;
```

#### 处理空指针错误
当返回指针的函数返回错误时，通常返回的指针是NULl
内核提供三个应对指针空指针的函数
```c
void *ERR_PTR(long error);
long IS_ERR(const void *ptr);
long PTR_ERR(const void *ptr*);
```
第一个把错误值作为指针返回
例如若函数在内存中申请内存失败，则要执行
return -ENOMEM
改为
return ERR_PTR(-ENOMEM);

第二个函数用于检查返回值是否是指针错误
if(IS_ERR(foo))

最后一个函数用于返回实际的错误代码
return PTR_ERR(foo);

例如：
```c
static struct iio_dev *indiodev_setup(){
	[...]
	strust iio_dev *indio_dev;
	indio_dev = devm_device_alloc(&data->client->dev,sizeof(data));
	if(!indio_dev){
		return ERR_PTR(-ENOMEM);
	[...]
	return indio_dev;
	}
}

static int foo_probe([...]){
	[...]
	struct iio_dev *my_indio_dev = indiodev_setup();
	if(IS_ERR(my_indio_dev))
		return PTR_ERR(data->acc_indio_dev);
	[...]
}

```

#### 注意
如果函数名称是动作或者命令的动作，则函数返回的错误代码应该是整数
如果函数的名称是谓词，则函数应该返回布尔值

### 消息打印printk
类似于用户空间的printf
执行dmseg命令可以显示printk写入的行

根据所打印消息重要性的不同，可以选用include/linux/kern_levels.h中定义的八个级别的消息日志
每个级别对应一个字符串格式的数字，优先级与对应的数字相反
例如0拥有最高的优先级
```c
#define 	KERN_SOH			"\001" 			/* ASCII头开始 */
#define 	KERN_SOH_ASCII 		'\001'
#define 	KERN_EMERG		KERN_SOH	"0"  	/* 系统不可用 */
#define 	KERN_ALERT		KERN_SOH	"1"		/* 必须立即采取行动 */
#define 	KERN_CRIT		KERN_SOH	"2"		/* 重要条件 */
#define 	KERN_ERR		KERN_SOH	"3"		/* 错误条件 */
#define 	KERN_WARNING	KERN_SOH	"4"		/* 警报条件 */
#define 	KERN_NOTICE		KERN_SOH	"5"		/* 正常但重要的情况 */
#define 	KERN_INFO		KERN_SOH	"6"		/* 信息 */
#define		KERN_DEBUG		KERN_SOH	"7"		/* 调试级别信息 */
```
打印内核消息和日志
```c
printk(KERN_ERR,"This is an ERROR\n");
```

如果省略调试级别(printk("This is an Error\n"))
则根据内核将提供CONFIG_DEAFULT_MESSAGE_LOGLEVEL配置选项(默认内核的日志级别)向函数提供一个调试级别

实际上可以使用下面的宏，其名称更有意义，是对前面所定义内容的包装
pr_emerg
pr_alert
pr_crit
pr_err
pr_warning
pr_notice
pr_info
pr_debug

```c
pr_err("This is the same error\n");
```

对于新开发的驱动程序，最好使用这些包装

检查日志级别参数
cat /proc/sys/kernel/printk
第一个值为当前日志级别
第二个值是按照CONFIG_DEFAULT_MESSAGE_LOGLEVEL选项设置的默认值

printk永远不会阻塞，即使在原子操作上下文也足够安全

## 模块参数
模块也可以接受命令行参数，可以根据参数来改变模块的行为

为了实现这样的功能，首先应该设置接受命令行参数的变量，并在每个变量上使用module_param()宏
位于`include/linux/moduleparam.h`中
使用#include<linux/moduleparam.h>加载
其中定义了
```c
module_param(name,type,perm)
```
+ name：用作参数的变量名称
+ type：参数的类型
	+ | bool | charp | byte | short | ushort | int | uint | long | ulong |
	+ charp代表指针
+ perm：代表/sys/module/\<module>/parameters/\<param>文件的权限
	+ | S_IWUSR | S_IRUSR | S_IXUSR | S_IRGRP | S_WGRP | S_IRUGO |
		+ | S_I：前缀 | R：读 | W：写 | X：执行 |
		+ | USR：用户 | GRP：用户组 | UGO：用户、组和其他 |

可以使用|来设置多个权限
如果perm为0,则不会创建sysfs中的文件参数
当使用模块时，应使用`MODULE_PARM_DESC`描述每个参数
这个宏把参数的描述信息存入模块信息部分

例子：
```c
#include <linux/moduleparm.h>
[...]
static char *mystr = "hello,word";
static int myint = 1;
static int myarr[3] = {0,1,2};

module_param(myint,int,S_IRUGO);
module_param(myint,charp,S_IRUGO);
module_param_array(myarr,int,NULL,S_IWUSR|S_IRUSR);

MODULE_PARM_DESC(myint,"This is my int variable");
MODULE_PARM_DESC(mystr,"This is my char pointer variable");
MODULE_PARM_DESC(myarr,"This is my array of int");

static int foo(){
	pr_info("mystring is a string: %s\n",mystr);
	pr_info("Array elements: %d\t%d\t%d\t\n",myarr[0],myarr[1],myarr[2]);
}
```
如果要加载模块,要提供相关参数，例如
```shell
insmod hellomodule-params.ko mystring="Cao" myint=15 myArray=1,2,3
```
在模块加载前，执行modinfo可以显示模块支持的参数

## 构建第一个模块
可以在两个地方构建模块，取决于用户能够自己使用内核配置界面启用该模块

### makefile文件
几乎在每个内核中的makefile文件都至少会有obj-\<X>变量的一个实例，对应于某种模式
X可以选为y、m、n或者空白
+ m：使用变量obj-m，并将mymodule.o构建为模块
+ y：使用变量obj-y，并将mymodule.o构建为内核的一部分
+ n：使用变量obj-n，不会构建mymodule.o

因此经常用到
```makefile
obj-$(CONFIG_XXX)
# 其中CONFIG_XXX是内核中配置选项的一部分
```
在内核配置中可以设置它或者不设置它，例如
obj-$(CONFIG_MYMODULE) += mymodule.o
$(CONFIG_MYMODULE)根据内核配置期间的值计算y或者m(使用make menuconfug)

如果CONFIG_MYMODULE不是y或者m，则文件不会被编译或者链接
`y表示内置，在内核配置中代表yes`
`m代表模块`

另外
obj-\<X> += somedir/
表示kbuild应该进入somedir目录，查找其中所有的makefile并将之处理，以此来决定应该构建哪些对象

下面makefile中的内容将用语构建模块
```makefile
obj-m := helloworld.o
KERNELDIR ?= /lib/modules/$(shell uname -r)/build

all default: modules
install: modules_install

modules modules_install help clean:
$(MAKE) -C $(KERNELDIR) M=$(shell pwd) $@
```

+ obj-m := helloworld.o：obj-o要列出的模块
+ KERNELDIR := /lib/modules/$(shell uname -r)/build:KERNELDIR：预构建内核源码的位置
+ M=$(shell pwd)：与内核的构建相关
+ all default: modules：此行指示实用程序make执行modules目标，在构建用户应用程序时，无论all还是default都是传统目标
+ modiles modules_install help clean:：代表makefile中列出的目标有效
+ \$(MAKE) -C \$(KERNELDIR) M=\$(shell pwd) $@：为上面列举的每个目标所执行所执行的规则

### 内核树内
在内核树中构建驱动程序之前，应该先`确定驱动程序的哪个目录用于存放.c文件`
假如文件名是mychardev.c，它包含特殊字符驱动程序的源代码，应该把它放在内核源码的drivers/char目录中
驱动程序的每个字目录都有makefile和kconfig文件，此时要将下面的内容加到该目录中的kconfig中
```cfg
config PACK_MYDEV
	tristate "Our packetpub special Character driver"
	default m
	help
		Say Y here if you want to suppose the /dev/mycdev devie
		The /dev/mycdev device is used to access packetpub
```
在同一个目录的makefile中添加
```makefile
obj-$(CONFIG_PACKT_MYCDEV) += mychardev.o
```

更新makefile时.o文件必须与.c文件保持一致
要把驱动程序构建成模块，则要在arch/arm/configs目录下的开发板defconfig中添加下
CONFIG_PACKT_MYCDEV=m

也可以运行`make menuconfig`来从UI中选择它，然后运行`make`构建内核，在运行`make modules`构建模块
为了将驱动程序编译到内核，只需要用y替换为m
CONFIG_PACKT_MYCDEV=m

内核源码树中包含的模块安装在`/lib/modules/$(KERNELRLEASE)/kernel/`中
在Linux系统中，它是/lib/modules/$(uname -r)/kernel/
运行下面的命令安装模块：
```shell
make modules_install
```


### 内核树外
在构建外部模块之前，需要一个完整的、预编译的内核源码树
内核源码树版本必须与将加载和使用的模块的内核相同
有两种方法可以获得预构建的内核版本
+ 自己构建
+ 从发行版的库中安装linux-headers- \*包

```shell
sudo apt install linux-headers-$(uname -r)
```
这样只会安装头文件，而不是整个源码树
头文件将会被安装在`/usr/srcc/linux-headers-$(uname -r)`下

`在我的arch中位于/lib/modules/5.12.9-arch1-1下，这应该是在wakefile中指定为内核目录的路径`


### 构建模块
在修改完`makefile`文件后，只需要切换到源码目录，并运行`make`命令或者`make modules`命令
本地构建不用对`ARCH`和`CROSS_COMPILE`进行定义
如要在ARM板上构建，则要声明`ARCH=arm` `CROSS_COMPILE=arm-none-linux-gnueabi-`















