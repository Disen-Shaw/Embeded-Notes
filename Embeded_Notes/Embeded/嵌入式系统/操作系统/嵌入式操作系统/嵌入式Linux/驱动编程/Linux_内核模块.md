# Linux 内核模块
## Linux 内核模块
Linux内核的整体架构非常庞大，包含的组件也非常多。  
把需要的部分包含在内核中一般有两种方法：  
+ 将需要的功能编译进Linux的内核中。
+ 编译出 `模块`，动态加载到内核。

第一种方法的有一些问题，将各种功能编译进入内核，会导致内核过于臃肿，并且如果需要新增或者删除某个功能，就需要重新编译内核。

模块有以下特点：  
+ 本身不被编译进内核，有效的控制了内核的大小
+ 模块一旦被加载，那么就和内核中的其他部分完全一样

以简单的 "hello world" 模块为例子：  

```c 
/*
 *Licensed under GPLv2 or later
 */

#include <linux/init.h> 
#include <linux/module.h>

static int __init hello_init(void)
{
	printk(KERN_INFO "hello world \n");
	return 0;
}
module_init(hello_init);

static int __exit hello_exit(void)
{
	printk(KERN_INFO "Module Exit\n");
}
module_exit(hello_exit);

MODULE_AUTHOR("Disen-Shaw <shaodisheng1314@gmail.com>");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("A Simple Hello World");
MODULE_ALIAS("A Simple Hello World");
```

### 模块的相关指令
模块加载通过 `insmod` 命令完成，模块卸载通过 `rmmod` 命令完成。  
`hello` 模块加载后，可以在 `/var/log/kern.log` 中找到相应的输出。  

使用 `lsmod` 命令可以获得系统中已加载的所有模块以及模块间的依赖关系。  
该命令实际上是读取 `/proc/modules` 文件。

内核加载模块的信息也处于 `/sys/module` 目录下，加载 `hello.ko` 之后，内核将包含 `/sys/module/hello` 目录。

`modprobe` 要比 `insmod` 命令强大，它在加载模块的时候，会同时加载模块所依赖的模块，使用 `modprobe` 命令加载的模块以 `modprobe -r module_name` 的方式卸载掉，并同时卸载依赖的模块。  

使用 `modinfo <模块名>` 可以获得模块信息，包括模块作者、模块的使用说明、模块支持的参数以及 `vermagic`

## Linux 内核模块程序结构
一个 Linux 内核模块主要有以下几个部分组成：  
+ 模块加载函数
+ 模块卸载函数
+ 模块许可证声明
	+ 如果不声明 LICENSE，模块加载时会收到 `内核污染` 的警告。
+ 模块参数(可选)
+ 模块导出符号(可选)
+ 模块作者信息(可选)


## 模块加载函数
Linux内核模块加载函数一般以 `__init` 的标识声明。  

模块加载函数一般以 `module_init(模块名)` 的形式被指定(如例子hello模块)，它返回整型值，若加载成功，则返回0,若加载失败，则返回 `错误码`，错误码在 `linux/errno.h` 中定义。  
返回相应错误编码是一个好习惯，这样可以根据编码信息打印出对应的错误字符串。  

在Linux内核中，可以使用 `request_module(const char *fmt...)` 函数加载模块，驱动开发人员可以调用下面的代码： `request_module(module_name)`。

在Linux中，所有标识为 `__init` 的函数如果过直接编译进入内核，成为内核镜像的一部分，在链接的时候，都会放在 `.init.text` 这个区段内。

```c
#define __init __attribute__((__section__ (".init.text")))
```

所有的 `__init` 函数在区段 `.initcall.init` 中还保存着一份函数指针，在初始化时内核会通过这些函数指针调用这些 `__init` 函数，并且在初始化完成之后，释放 `init` 区段的内存。

除了函数以外，数据也可以被定义成 `__initdata`。  
对于只是初始化阶段需要的数据，内核在初始化完成之后，也可以释放它们占用的内存。

## 模块的卸载函数
Linux内核模块的卸载函数一般以 `__exit` 标识声明。

模块卸载函数在调用时不返回任何值，且必须以 `module_exit(函数名)` 的形式指定。
通常来说，模块卸载函数要完成与模块加载函数相反的功能。

采用 `__exit` 来修饰模块卸载函数，可以告诉内核如果相关的模块被直接编译进内核，就不可能卸载它，卸载函数也就没有存在的必要了。

除了函数以外，只是推出阶段采用的数据也可以用 `__exitdata` 来形容。

## 模块参数
可以用 `module_param(参数名，参数类型，参数读写权限)` 为模块定义一个参数。  
例如：  
```c
static char *name = "Disen-Shaw";
module_param(name,charp,S_IRUGO);

static int age = 10;
module_param(age,int,S_IRUGO);
```

在装载内核模块时的形式为：  

```shell
insmod <模块名> 参数名=参数值 
```
如果模块内置，就无法 `insmod` 了，但是 `bootloader` 可以通过在 `boottargs` 里设置模块名.参数名=值

参数类型可以是 byte、short、ushort、int、uint、long、ulong、charp、bool或者invbool(布尔取反)。
除此之外，模块也可以拥有参数数组，并使用分号分隔输入的数组元素。  

在 `/sys/module/模块名/parameters` 中可以找到定义的参数。

## 导出符号
Linux的 `/proc/kallsyms` 文件对应着内核符号表，它记录着符号以及符号所在的内存地址。  
模块可以使用下面的宏导出符号到内核符号中去
+ EXPORT_SYMBOL(符号名);
+ EXPORT_SYMBOL_GPL(符号名);

导出的符号可以被其他模块使用，使用之前声明一下即可。
`EXPORT_SYMBOL_GPL`只适用于包含GPL许可权的模块。  

## 模块的声明与描述
在Linux内核模块中，可以使用以下声明
+ MODULE_AUTHOR(作者) 
+ MODULE_DESCRIPTION(描述) 
+ MODULE_VERSION(版本) 
+ MODULE_DEVICE_TABLE(设备表)
+ MODULE_ALIAS(别名)

## 模块的使用计数
Linux2.4内核中，模块自身通过 
+ MOD_INC_USE_COUNT
+ MOD_DEC_USE_COUNT

宏来管理自己被使用的次数

2.6以后的内核中，提供了模块计数管理接口 `try_module_get(&module)` 和 `module_put(&module)` ，从而取代了2.4内核中的模块使用计数管理宏。  
模块的使用计数一般不用模块自身管理，而且模块计数管理还考虑了 `SMP` 与 `PREESMP` 机制的影响。

```c
int try_module_get(struct module *module);
```
用于增加模块的使用计数  
如果返回0,则表示调用失败。  

```c
void module_put(struct module *module)
```
用于减少模块的使用计数

## 模块的编译
可以使用下面的模板编写一个简单的Makefile  
```makefile
KVERS = $(shell uname -r)

# Kernel modules
obj-m += hello.c

# Specify flags for the module compilation
# EXTRA_CFLAGS = -g -O0

build:kernel_modules

kernel_modules:
	make -C /lib/modules/$(KVERS)/build M=$(CURDIR) modules
	
clean:
	make -C /lib/modules/$(KVERS)/build M=$(CURDIR) clean
```

该Makefile与hello.c位于同一个文件夹中。  
如果一个模块包含多个.c文件，则应该以下面的方式编写Makefile。

```makefile
obj-m += modulename.o
modulename := file1.o file2.o
```
