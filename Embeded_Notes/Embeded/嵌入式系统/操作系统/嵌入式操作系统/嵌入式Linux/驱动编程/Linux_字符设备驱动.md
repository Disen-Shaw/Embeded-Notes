# Linux 字符设备驱动
## Linux 字符设备驱动结构
### cdev 结构体
在Linux内核中，使用 `cdev` 结构体描述一个字符设备。  

```c
struct cdev {
	struct kobject			kobj;			/* 内嵌的 kobject对象 */
	struct module 			*owner;			/* 所属模块 */
	struct file_operations 	*opts;			/* 文件操作结构体 */
	struct list_head 		list;			
	dev_t 					dev;			/* 设备号 */
	unsigned int 			count; 
};
```

`cdev` 结构体的 `dev_t` 成员定义了设备号，为32位，其中12位为主设备号，20位为次设备号。  
使用下面两个定义的宏可以获得主设备号和次设备号。  

```c
MAJOR(dev_t dev);
MINOR(dev_t dev);
```

使用下面的宏可以通过主设备号和次设备号生成 `dev_t`。

```c
MKDEV(int major, int minor);
```

`cdev` 的另一个重要的成员 `file_operations` 定义了字符设备驱动提供给虚拟文件系统的接口函数。  
Linux内核提供了一组函数以用于操作 `cdev` 结构体。

```c
void cdev_init(struct cdev *, struct file_operations *);
struct cdev *cdev_alloc(void);
int cdev_add(struct cdev *, dev_t unsigned);
void cdev_del(struct cdev *);
```
`void cdev_init()` 用于初始化 `cdev` 成员，并建立 `cdev` 和 `file_operations` 之间的连接  
其源代码如下：

```c
void cdev_init(struct cdev *cdev, struct file_operations *fops)
{
	memset(cdev, 0, sizeof *cdev);
	INIT_LIST_HEAD(&cdev->list);
	kobject_init(&cdev->kobj, &ktype_cdev_default);
	cdev->ops = fops;	/* 将传入的文件操作结构体指针赋值给cdev的ops */
}
```
`cdev_alloc()` 函数用于动态申请一个 `cdev` 内存，其源代码如下：  

```c
struct cdev *cdev_alloc(void)
{
	struct cdev *p = kzalloc(sizeof(struct cdev), GFP_KERNEL);
	if (p){
		INIT_LIST_HEAD(&p->list);
		kobject_init(&p->kobj, &ktype_cdev_dynamic);
	}
	return p;
}
```
后面的连个函数分别向系统添加和删除一个 `cdev`，完成字符设备的注册和注销。对 `cdev_add()` 的调用通常发生在 `字符设备驱动模块加载函数中`，而对 `cdev_del()` 函数的调用则通常发生在字符设备驱动模块的卸载函数中。

### 分配和释放设备号
在调用 `cdev_add()` 函数向系统注册设备之前，首先应该调用下面的函数之一向系统申请设备号。
+ register_chrdev_region() 已知起始设备的设备号
+ alloc_chrdev_region() 设备号未知，向系统动态申请未被占用的设备号

原型分别是：  
```c
int register_chrdev_region(dev_t from, unsigned count, const char *name);
int alloc_chrdev_region(dev_t *dev, unsigned baseminor, unsigned count, const char *name);
```

函数调用成功后，会把设备号放入第一个参数 `dev` 中。

相应的在调用 `cdev_del()` 函数注销字符设备之后， `unregister_chrdev_region()` 应该调用来释放原先申请的设备号。
```c
void unregister_chrdev_region(dev_t from, unsigned count);
```

### file_opeartions 结构体
`file_operations` 结构体的成员函数是字符设备驱动设计的主体内容，这些函数会在应用程序进行Linux的 `open()`、`write()`、`read()`、`close()`等系统调用时最终被内核调用。  

```c
struct file_operations {
	struct module *owner;
	loff_t (*llseek) (struct file *, loff_t, int);
	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
	int (*iopoll)(struct kiocb *kiocb, bool spin);
	int (*iterate) (struct file *, struct dir_context *);
	int (*iterate_shared) (struct file *, struct dir_context *);
	__poll_t (*poll) (struct file *, struct poll_table_struct *);
	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
	int (*mmap) (struct file *, struct vm_area_struct *);
	unsigned long mmap_supported_flags;
	int (*open) (struct inode *, struct file *);
	int (*flush) (struct file *, fl_owner_t id);
	int (*release) (struct inode *, struct file *);
	int (*fsync) (struct file *, loff_t, loff_t, int datasync);
	int (*fasync) (int, struct file *, int);
	int (*lock) (struct file *, int, struct file_lock *);
	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
	int (*check_flags)(int);
	int (*flock) (struct file *, int, struct file_lock *);
	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
	int (*setlease)(struct file *, long, struct file_lock **, void **);
	long (*fallocate)(struct file *file, int mode, loff_t offset,
			  loff_t len);
	void (*show_fdinfo)(struct seq_file *m, struct file *f);
#ifndef CONFIG_MMU
	unsigned (*mmap_capabilities)(struct file *);
#endif
	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
			loff_t, size_t, unsigned int);
	loff_t (*remap_file_range)(struct file *file_in, loff_t pos_in,
				   struct file *file_out, loff_t pos_out,
				   loff_t len, unsigned int remap_flags);
	int (*fadvise)(struct file *, loff_t, loff_t, int);
} __randomize_layout;
```

+ `llseek()` 函数用于修改一个文件的当前读写位置，并将新的位置返回，在出错时返回负值。
+ `read()` 函数用于从设备中读取数据，成功时返回读取的字节数，出错时返回一个负值。
	+ 他和用户空间的两个函数对应
		+ `ssize_t read(int fd, void *buf, size_t count)`
		+ `size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)`
+ `write()` 函数想设备发送数据，成功时该返回函数写入的字节数
	+ 如果未被实现，当用户进行 `write()` 系统调用时，将得到 `-EINVAL` 返回值。
	+ 他与用户空间的两个函数对应
		+ `ssize_t write(int fd, const void *buf, size_t count)`
		+ `size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream)`
+ `read（）` 和 `write()` 如果返回0,则暗示 EOF (end-of-file)
+ `unlocked_ioctl()` 提供设备相关的控制命令的实现(既不是读操作，也不是写操作)
	+ 当调用成功时，返回给调用程序一个非负值
	+ 它与用户空间调用的 `int fcntl(int fd, int cmd, ... /* args */)`对应
+ `mmap()` 函数将内存映射到进程的虚拟地址空间中
	+ 如果未被实现，当用户进行 `mmap()` 系统调用时，将得到 `-EINVAL` 返回值
	+ 这个函数对于缓冲帧等有特别的意义
		+ 帧缓冲被映射到用户空间后
		+ 应用程序可以直接访问它而无须在内核和应用间进行内存复制
	+ 他与用户空间的函数对应 
	+ `void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)`
+ **当用户空间调用Linux API函数 `open()` 打开设备文件时，设备驱动的 `open()` 函数最终被调用。**
+ 驱动程序可以不实现 `open()` 函数，在这种情况下，设备的打开操作永远成功
	+ 与 `open()` 对应的函数应该是 `release()` 函数
+ `poll()` 函数一般用于询问设备是否可被非阻塞地立即读写
	+ 当询问条件未触发时，用户空间进行 `select()` 和 `poll()` 系统调用将引起阻塞
+ `aio_read()` 和 `aio_write()` 函数分别对与文件描述符对应的设备进行异步读、写操作
	+ 设备实现这两个函数之后，用户空间可以对设备文件描述符使用 
		+ `SYS_io_setup`
		+ `SYS_io_submit`
		+ `SYS_io_getevents`
		+ `SYS_io_destory`
	+ 等系统调用进行读写

### Linux 字符设备驱动的组成
在Linux中，字符设备的驱动由以下几个部分组成
+ 字符设备驱动模块加载与卸载模块
+ 字符设备驱动的 `file_operations` 结构体中的成员函数

#### 字符设备驱动模块加载与卸载模块
在字符设备驱动模块加载函数中应该实现设备号的申请和 `cdev` 注册  
而在卸载函数应实现设备好的释放和 `cdev` 的注销  

Linux内核的编码习惯是为设备定义一个设备相关的结构体，该结构体包含设备所涉及的 `cdev` 、私有数据以及锁等信息。

```c
/* 设备结构体 */
struct xxx_dev_t {
	struct cdev cdev;
	... ...
} xxx_dev;

/* 设备驱动模块加载函数 */
static int __init xxx_init(void)
{
	...
	cdev_init(&xxx_dev.cdev, &xxx_fops);			/* 初始化cdev */
	xxx_dev.cdev.owner = THIS_MODULE;
	/* 获取字符设备号 */
	if (xxx_major) {
		register_chrdev_region(xxx_dev_no, 1, DEV_NAME);
	} else {
		alloc_chrdev_region(xxx_dev_no, 0, 1, DEV_NAME)
	}
	ret = cdev_add(&xxx_dev.cdev, xxx_dev_no, 1); 	/* 注册设备 */
	...
}
/* 设备驱动卸载模块函数 */
static void __exit xxx_exit(void)
{
	cdev_del(&xxx_dev.cdev);						/* 注销设备 */
	unregister_chrdev_region(xxx_dev_no, 1);		/* 释放占用的设备号 */
}
```

#### 字符设备驱动的 file_operations 结构体中的成员函数
`file_operations` 结构体中的成员函数是字符设备驱动与设备驱动内核虚拟文件系统的接口，是用户空间对Linux内核进行系统调用最终的落实者。  
大部分设备驱动会实现
+ read()
+ write()
+ ioctl()函数

常见的字符设备驱动的函数形式如下所示：
```c
/* 读设备 */
ssize_t xxx_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
{
	...
	copy_to_user(buf, ... ...);
	...
}
/* 写设备 */
ssize_t xxx_write(struct file *flip, char __user *buf, size_t count, loff_t *f_pos)
{
	...
	copy_from_user(buf,... ...);
	...
}
/* ioctl函数 */
long xxx_ioctl(struct file *flip, unsigned int cmd, unsigned long arg)
{
	...
	switch(cmd) {
		case XXX_CMD1:
			...
			break;
		case XXX_CMD2:
			...
			break;
		default:
			return -ENOTTY;			/* 不能支持的命令 */
	}
	return 0;
}
```
+ `filp` 是文件结构体指针
+ `buf` 是用户空间内存的地址(该地址在内核空间不宜直接读写)
+ `count` 是要读写的字节数
+ `f_pos` 是写的位置相对于文件开头的偏移

用户空间不能直接访问内核空间的内存，因此借助 `copy_to_user` 和 `copy_from_user` 完成内核与用户空间数据的复制，这两个函数的原型分别是：
+ `unsigned long copy_from_user(void *to, const void __user *form, unsigned long count)`
+ `unsigned long copy_to_user(void __user *to, const void *from, unsigned long count)`

两个函数返回值都是不可以被复制的字节数，因此如果完全复制成功，返回值为0  
如果复制失败，则返回值为负值  

如果要复制的内存是简单类型，如 `char`，`int`、`long`等  
则可以使用简单的 `put_user()` 和 `get_user()`  

例如：

```c
int val;							/* 内核空间整型变量 */
...
get_user(val, (int *)arg);			/* 用户 -> 内核，arg是用户的空间地址 */
...
put_user(val, (int *)arg);			/* 内核 -> 用户，arg是用户的空间地址 */
```

`__user` 是一个宏，表明其后面的指针指向用户空间，实际上更多的充当代码注视的作用。  
```c
#ifndef __CHECKER__
# define __user __attribute__((noderef, address_space(1)))
#else
# define __user
#endif
```

内核空间虽然可以访问用户空间的缓冲区，但是在访问之前，一般需要先检查其合法性，通过 
`access_ok(type, addr, size)` 进行判断，以确定传入的缓冲区确实属于用户空间

在字符设备驱动中，需要定义一个 `file_operations` 的实例  
将具体的设备驱动赋值给 `fil_operation` 的成员

```struct file_operations xxx_f_ops = {
	.owner = THIS_MODULE,
	.read = xxx_read,
	.write = xxx_write,
	.unlocked_ioctl = xxx_ioctl,
	...
};
```
`file_operation` 和 `cdev` 最终在 `cdev_init` 函数中建立连接，对应本文笔记188行。

![[Pasted image 20210820104359.png]]

## globalmem虚拟设备实例描述
`globalmen` 意味着 "全局内存"，在 `globalmen` 设备进行字符设备驱动中，会分配一片大小为 `GLOBALMEN_SIZE` 的内存空间，并在驱动中提供对该片内存的读写、控制和定位函数，以供用户空间的进程能通过Linux系统调用获取或者设置这片内存的内容。

实际上，这个虚拟的 `globalmen` 几乎没有任何的实用价值，仅仅是一种为了讲解问题的方法而凭空制造出来的设备。

## globalmen 设备驱动
### 头文件、宏及设备结构体
在 `globalmen` 字符设备驱动中，应该包含它要使用的头文件，定义 `globalmen` 设备结构体以及相关宏。  
例如：  

```c
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

#define GLOBALMEM_SIZE 0x1000
#define MEM_CLEAR 0x1
#define GLOBALMEM_MAJOR 230

static int globalmem_major = GLOBALMEM_MAJOR;
module_parm(globalmem_major, int, S_IRUGO);

struct globalmem_dev {
	struct cdev cdev;
	unsigned char mem[GLOBALMEN_SIZE];
};

struct globalmen_dev *globalmem_devp;
```

设备结构中包含字符设备结构体和其对应的内存空间，这样定义的好处在于借用了面向对象中`封装`的思想

### 加载与卸载设备驱动
与之前的类似，现实中工作的代码和之前的完全一致

```c
/* 建立全局虚拟设备 */
static void globalmem_setup_cdev(struct globalmem_dev, *dev, int index)
{
	int err, devno = MKDEV(globalmem_major, index);
	
	cdev_init(&dev->cdev, globalmem_fops);
	dev->cdev.owner = THIS_MODULE;
	err = cdev_add(&dev->cdev, devno, 1);
	if(err)
		printk(KERN_NOTICE "Error %d adding globalmem%d", err, index);
}

/* init */
static int __init globalmem_init(void)
{
	int ret;
	dev_t devno = MKDEV(globalmem_major, 0);
	
	if(globalmem_major)
		ret = register_chrdev_region(devno, 1, "globalmem");
	else {
		ret = alloc_chrdev_region(&devno, 0, 1, "globalmem");
		globalmem_major = MAJOR(devno);
	}
	if (ret<0)
		return ret;
		
	globalmem_devp = kzalloc(sizeof(struct globalmem_dev), GFP_KERNEL);
	if(!globalmem_devp) {
		ret = -ENOMEM;
		goto fail_malloc;	
	}
	
	globalmem_setup_cdev(globalmem_devp, 0);
	return 0;
	
	fail_malloc:
	unregister_chrdev_region(devno, 1);
	return ret;
}
module_init(globalmem_init);
```

`globalmem_setup_cdev()` 函数完成了 `cdev` 的初始化和添加。  
ret 变量完成了 设备号的申请  
`kzalloc()` 函数申请了一份 `globalmem_dev` 结构体的内存并清零。

与 `globalmem` 的 `cdev` 关联的 `file_operations` 结构体代码如下：

```c
static const struct file_operations globalmem_fops = {
	.owner = THIS_MODULE,
	.llseek = globalmem_llseek,
	.read = globalmem_read,
	.write = globalmem_write,
	.unlocked_ioctl = globalmem_ioctl,
	.open = globalmem_open,
	.release = globalmem_release
};
```

### 读写函数
`globalmem` 设备驱动函数的读写函数主要是让设备结构体的 `mem[]` 数组与用户空间交互数据，并随着访问字节数变更更新文件读写偏移位置。读和写函数的实现分别下面的代码所示。

```c
static ssize_t globalmem_read(struct file *filp, char __user *buf, size_t size, loff_t *ppos)
{
	unsigned long p = *ppos;
	unsigned int count = size;
	int ret = 0;
	struct globalmem_dev *dev = filp->private_data;
	
	if( p>= GLOBALMEM_SIZE)
		return 0;
	if( count > GLOBALMEM_SIZE -p )
		count = GLOBALMEM_SIZE - p;
	
	if(copy_to_user(buf, dev->mem + p, count)){
		ret = -EFAULT;
	} else {
		*ppos += count;
		ret = count ;
		
		printk(KERN_INFO "read %u byte(s) from %lu\n",count, p);
	}
	return ret;
}
```

\*ppos是要读取的位置相对于文件开头的偏移，如果该偏移大于或者等于 `GLOBALMEM_SIZE`，就意味着已经达到文件的末尾(EOF)。

```c
static ssize_t globalmem_write(struct file *filp, char __user *buf, size_t size, loff_t *ppos)
{
	unsigned long p = *ppos;
	unsigned int count = size;
	int ret = 0;
	struct globalmem_dev *dev = filp->private_data;
	
	if( p >= GLOBALMEM_SIZE)
		return 0;
	if( count > GLOBALMEM_SIZE -p )
		count = GLOBALMEM_SIZE - p;
	
	if(copy_from_user(buf, dev->mem + p, count)){
		ret = -EFAULT;
	} else {
		*ppos += count;
		ret = count ;
		
		printk(KERN_INFO "written %u byte(s) from %lu\n",count, p);
	}
	return ret;
}
```
和 `read` 函数的结构基本一致

### seek函数
seek函数对文件定位的起始位置可以时文件开头(SEEK_SET, 0)、当前位置(SEEK_CUR, 1)和文件末尾(SEEK_END, 2)，假设 `globalmem` 支持从文件开头和当前位置的相对偏移。

在定位的时候，应该检查用户请求的合法性，若不合法，函数返回 `-EINVAL`，合法时更新文件的当前位置并返回该位置。

如下代码所示

```c
static loff_t globalmem_llseek(struct file *filp, loff_t offset, int orig)
{
	loff_t ret = 0;
	switch(orig){
	case 0: /* 从文件开头位置 */
		if(offset < 0){
			ret = -EINVAL;
			break;
		}
		if ((unsigned int)offset > GLOBALMEM_SIZE) {
			ret = EINVAL;
			break;
		}
		filp ->f_ops = (unsigned int )offset;
		ret = filp->f_pos;
		break;
	case 1: /* 从文件当前位置 */
		if(filp->f_ops + offset > GLOBALMEM_SIZE){
			ret = -EINVAL;
			break;
		}
		if(filp->f_ops + offset < 0){
			ret = -EINVAL;
			break;
		}
		
		filp ->f_ops += (unsigned int )offset;
		ret = filp->f_pos;
		break;
	default:
		ret = -EINVAL;
		break;
	}
	return ret;
}
```

### ioctl函数
#### globalmem 设备驱动的 ioctl()函数
`globalmem` 设备驱动的 `ioctl()` 函数接受 `MEM_CLEAR` 命令，这个命令会把全局内存的有效长度清零。  
对于设备不支持的命令，`ioctl()` 函数应该返回 `-EINVAL`

