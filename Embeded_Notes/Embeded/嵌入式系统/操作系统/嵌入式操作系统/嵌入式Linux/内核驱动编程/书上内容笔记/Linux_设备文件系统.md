# Linux 设备文件系统
## devfs
devfs(设备文件系统)是由Linux2.4内核引入的，它的出现使得设备驱动能够自主地管理自己的设备文件。  

**具体来说，`devfs` 有下面的一些优点。**  
+ 可以通过程序在设备初始化在 `/dev` 目录下创建设备文件，卸载设备时将它删除。  
+ 设备驱动程序可以指定设备名，所有者和权限位，用户空间程序仍可以修改所有者和权限位。  
+ 不再需要为设备驱动程序分配设备号以处理次设备号，在程序中可以直接给 `regieter_chrdev()` 传递0主设备号一获得可用的主设备号，并在 `devfs_register()` 中指定次设备号。

驱动程序通过下面这些函数来进行设备文件的创建和撤销工作。  

### 创建设备目录
```c
devfs_handle_t devfs_mk_dir(devfs_handle_t dir, const *name, void *info)
```
### 创建设备文件
```c
devfs_handle_t devfs_register(	devfs_handle_t dir, 
								const *name, 
								unsigned ing flag,
								unsigned int major,
								unsigned int minor
								umode_t mode
								void *opts,
								void info);							
```

### 撤销设备文件
```c
void devfs_unregister(devfs_handle_t de);
```

在Linux2.4的设备驱动编程中，分别在模块加载、卸载模块中创建设备文件是被普遍值得大力推荐的好方法。  
下面清单给出了一个使用devfs的范例。  
```c
static devfs_handle_t devfs_handle;
static int __init xxx_init(void)
{
	int ret;
	int i;
	/* 在内核中注册设备 */
	ret = register_chrdev(XXX_MAJOR, DEVICE_NAME, &xxx_fops);
	if( ret < 0 ){
		printk(DEVICE_NAME "can't register major number!\n");
		return ret;
	}
	/* 创建设备文件 */
	devfs_handle = devfs_register(NULL, DEVICE_NAME, DEVFS_FL_DEFAULT, XXX_MAJOR, 0, S_IFCHR | S_IRUSR | S_IWUSR . &xxx_fops, NULL);
	...
	printk(DEVICE_NAME "initialized\n");
}

static void __exit xxx_exit(void)
{
	devfs_unregister(devfs_handle);					/* 注销设备文件 */
	unregister_chrdev(XXX_MAJOR, DEVICE_NAME); 		/* 注销设备 */
}

module_init(xxx_init);
module_exit(xxx_exit);

```

## udev 用户空间设备
### udev 和 devfs
在Linux2.6内核中，`devfs` 被认为是过时的方法，并且最终通过 `udev` 取代了它。  
大致原因：  
+ `devfs` 所做的工作被确信可以在用户态完成。
+ `devfs` 被加入内核时，人们期望它的质量可以迎头赶上。
+ 发现 `devfs` 有一些可修复和无法修复的bug。
	+ 对于可修复的bug，作者已经修复
	+ 对于不可修复的bug，在相当长一段时间内没有改观
+ 最终 `devfs` 维护者和作者对其非常失望，并且停止了对代码的维护工作。(哈哈哈)

`策略` 不能出现在内核空间，Linux设计强调的一个基本观点是 `机制` 和 `策略` 的分离。    
`机制` 指的是做事情的固定方法，步骤，而 `策略` 就是每一个步骤所采取的不同方式。  
`机制` 是相对固定的，而每个 `步骤` 采用的策略是不固定的。  
`机制` 是稳定的，而 `策略` 是灵活的  
**Linux内核中不应该实现 `策略` **
 
### udev
`udev` 完全工作在用户态，利用设备加入或者移除是内核所发送的 `热插拔事件(Hotplug Event)` 来工作。  
在热插拔时，设备的详细信息会由内核通过 `netlink` 套接字发送出来，发出的事件叫 `uevent` 。  

`udev` 的设备命名策略、权限控制和事件处理都是在 `用户态` 下完成的，它利用从内核受到的信息来进行创建设备文件节点等工作。  

内核通过 `netlink` 接收热插拔时间并冲刷掉的范例。  

```c
#include <linux/netlink.h>

static void die(char *s)
{
	write(2, s, strlen(s));
	exit(1);
}

int main(int argc, char *argv[])
{
	struct sockaddr_nl nls;
	struct pollfd pfd;
	char buf[512];
	
	/* open hotplug event netlink socket*/
	meset(&nls, 0, sizeof(struct sockaddr_nl));
	nls.nl_family = AF_NETLINK;
	nls.nl_pid = getpid();
	nls.nl_groups = -1;
	
	pfd.events = POLLIN;
	pfd.fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);
	
	if(pfd.fd == -1)
		dir("Not root\n");
		
	/* Listen to netlink socket */
	if (bind(pfd.fd, (void *)&nls, sizeof(struct sockaddr_nl)));
		die("Bind Failed\n");
	
	while( -1 != poll(&pfd,1,-1)){
		int i,len = recv(pfd.fd, buf,sizeof(buf), MSG_DONTWAIT);
		if( len==-1 )
			die("recv\n");
		/* Print the data to stdout */
		i = 0;
		while(i<len){
			printf("%s\n",buf+i);
			i+=strlen(buf+i)+1;
		}
	}
	die("poll\n");
	return 0;
}
```
编译上面的程序，并运行，把 `Apple Facetime HD Camera USB` 摄像头插入Ubuntu，该程序会 `dump` 出一些信息。  
`udev` 就是这种方式接收 `netlink` 消息，并根据它的内容和用户设置给 `udev` 的规则做匹配工作的。

`冷插拔设备`，在开机时就存在，在 `udev` 启动前就已经被插入了。  
对于 `冷插拔设备`，Linux内核提供了 `sysfs` 下面一个 `uevent` 节点。可以往该节点写一个 `add` ，导致内核重新发送 `netlink`，之后 `udev` 就可以收到冷插拔的 `netlink` 消息了。
此时还是运行上面的程序，并手动在 `/sys/modulepsmouse/uevent` 写一个 `add` 。  
此时程序的 dump 会多出一些添加的信息。

`udev` 和 `devfs` 的另一个显著区别在于：采用 `devfs`，当一个并不存在的 `/dev` 节点被打开的时候，`devfs` 能够自动加载对用的驱动，而 `udev` 不这样。  
`devfs` 的访问时加载驱动显得多余。
`udev` 设计者认为Lnux应该在设备发现的时候加载驱动，而不是当它被访问的时候。  
系统中所有的设备都应该产生 `热插拔事件`并加载对应的驱动，而 `udev` 就具备这样的功能。

## sysfs文件系统和Linux设备模型
Linux2.6之后的内核中引入了 `sysfs` 文件系统，`sysfs` 被看成是与 `proc`、`devfs`、`devpty`同类的文件类型。该文件系统是一个虚拟的文件系统，可以产生一个包括所有系统硬件的层级视图。与提供进程与状态信息的 `proc` 十分类似。

`sysfs` 把连接在系统上的设备和总线组织成一个分级的文件，它们可以由用户空间存取，向用户空间导出内核数据结构和它们的属性。  
`sysfs` 的一个目的就是展示设备驱动模型中各组建的层次关系，其顶级目录包括 
+ `block` 包含所有的块设备
+ `bus` 包含系统所有的总线类型
+ `device` 包含所有的设备，并根据设备挂载的总线类型组织成层次结构
+ `class` 包含系统中的设备类型，如网卡、声卡、屏幕等
+ `fs` 
+ `kernel`
+ `power` 
+ `firewarm`等。

在 `/sys/bus` 的 `pci` 等子目录下，又会在分出 `drivers` 和 `devices` 目录，而 `devices` 目录中的文件是对 `sys/devices` 目录中文件的符号链接。同样的，`/sys/class` 目录下也包含许多对 `/sys/devices` 下文件的链接。

![[Pasted image 20210818222746.png]]

内核中的总线和其他内核子系统会完成与设备模型的交互，这使得驱动工程师在编写底层驱动的时候只需要按照每个框架的要求填充驱动的各种回调函数就可以。

在Linux内核中，分别使用 `bus_type`，`devece_driver`和 `device` 来表述总线、驱动和设备。

**bus_type**
```c
struct bus_type {
	const char		*name;
	const char		*dev_name;
	struct device		*dev_root;
	const struct attribute_group **bus_groups;
	const struct attribute_group **dev_groups;
	const struct attribute_group **drv_groups;

	int (*match)(struct device *dev, struct device_driver *drv);
	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
	int (*probe)(struct device *dev);
	void (*sync_state)(struct device *dev);
	int (*remove)(struct device *dev);
	void (*shutdown)(struct device *dev);

	int (*online)(struct device *dev);
	int (*offline)(struct device *dev);

	int (*suspend)(struct device *dev, pm_message_t state);
	int (*resume)(struct device *dev);

	int (*num_vf)(struct device *dev);

	int (*dma_configure)(struct device *dev);

	const struct dev_pm_ops *pm;

	const struct iommu_ops *iommu_ops;

	struct subsys_private *p;
	struct lock_class_key lock_key;

	bool need_parent_lock;
};
```

**device_driver**
```c
struct device_driver {
	const char		*name;
	struct bus_type		*bus;

	struct module		*owner;
	const char		*mod_name;	/* used for built-in modules */

	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
	enum probe_type probe_type;

	const struct of_device_id	*of_match_table;
	const struct acpi_device_id	*acpi_match_table;

	int (*probe) (struct device *dev);
	void (*sync_state)(struct device *dev);
	int (*remove) (struct device *dev);
	void (*shutdown) (struct device *dev);
	int (*suspend) (struct device *dev, pm_message_t state);
	int (*resume) (struct device *dev);
	const struct attribute_group **groups;
	const struct attribute_group **dev_groups;

	const struct dev_pm_ops *pm;
	void (*coredump) (struct device *dev);

	struct driver_private *p;
};
```

**device**
```c
struct device {
	struct kobject kobj;
	struct device		*parent;

	struct device_private	*p;

	const char		*init_name; /* initial name of the device */
	const struct device_type *type;

	struct bus_type	*bus;		/* type of bus device is on */
	struct device_driver *driver;	/* which driver has allocated this
					   device */
	void		*platform_data;	/* Platform specific data, device
					   core doesn't touch it */
	void		*driver_data;	/* Driver data, set and get with
					   dev_set_drvdata/dev_get_drvdata */
#ifdef CONFIG_PROVE_LOCKING
	struct mutex		lockdep_mutex;
#endif
	struct mutex		mutex;	/* mutex to synchronize calls to
					 * its driver.
					 */

	struct dev_links_info	links;
	struct dev_pm_info	power;
	struct dev_pm_domain	*pm_domain;

#ifdef CONFIG_ENERGY_MODEL
	struct em_perf_domain	*em_pd;
#endif

#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
	struct irq_domain	*msi_domain;
#endif
#ifdef CONFIG_PINCTRL
	struct dev_pin_info	*pins;
#endif
#ifdef CONFIG_GENERIC_MSI_IRQ
	struct list_head	msi_list;
#endif
#ifdef CONFIG_DMA_OPS
	const struct dma_map_ops *dma_ops;
#endif
	u64		*dma_mask;	/* dma mask (if dma'able device) */
	u64		coherent_dma_mask;/* Like dma_mask, but for
					     alloc_coherent mappings as
					     not all hardware supports
					     64 bit addresses for consistent
					     allocations such descriptors. */
	u64		bus_dma_limit;	/* upstream dma constraint */
	const struct bus_dma_region *dma_range_map;

	struct device_dma_parameters *dma_parms;

	struct list_head	dma_pools;	/* dma pools (if dma'ble) */

#ifdef CONFIG_DMA_DECLARE_COHERENT
	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
					     override */
#endif
#ifdef CONFIG_DMA_CMA
	struct cma *cma_area;		/* contiguous memory area for dma
					   allocations */
#endif
	/* arch specific additions */
	struct dev_archdata	archdata;

	struct device_node	*of_node; /* associated device tree node */
	struct fwnode_handle	*fwnode; /* firmware device node */

#ifdef CONFIG_NUMA
	int		numa_node;	/* NUMA node this device is close to */
#endif
	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
	u32			id;	/* device instance */

	spinlock_t		devres_lock;
	struct list_head	devres_head;

	struct class		*class;
	const struct attribute_group **groups;	/* optional groups */

	void	(*release)(struct device *dev);
	struct iommu_group	*iommu_group;
	struct dev_iommu	*iommu;

	enum device_removable	removable;

	bool			offline_disabled:1;
	bool			offline:1;
	bool			of_node_reused:1;
	bool			state_synced:1;
	bool			can_match:1;
#if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
    defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) || \
    defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
	bool			dma_coherent:1;
#endif
#ifdef CONFIG_DMA_OPS_BYPASS
	bool			dma_ops_bypass : 1;
#endif
};


```

在Linux内核中，设备和驱动是分开注册的，注册一个设备的时候不需要驱动已经存在，反之一样。是 `bus_type` 的 `match()` 成员函数将两者捆绑在一起。  
一旦配对成功，`xxx_driver` 的 `probe()` 就会被执行(xxx是总线名，如platform、pci、i2c、spi等)


> 总线、驱动和设备最终都会落实为 `sysfs` 中的一个目录，因为进一步追踪代码会发现，它们实际上都可以认为是 `kobject` 的派生类， `kobject` 可以看做是所有总线、设备和驱动的抽象基类，一个 `kobject` 对应 `sysfs` 中的一个目录。


总线、设备和驱动中的各个 `attribute` 直接落实为 `sysfs` 中的一个文件， `attribute` 会伴随着 `show()` 和 `store()` 这两个函数，分别用于读写 `attribute` 对应的 `sysfs` 文件。

**attribute**
```c
struct attribute {
	const char 					*name;
	umode_t 					mode;
#ifdef CONFIG_DEBUG_LOCK_ALLOC
	bool 						ignore_lockdep:1;
	struct lock_class_key		*key;
	struct lock_class_key		skey;
#endif
};
```

**bus_attribute**
```c
struct bus_attribue	{
	struct attribute 			attr;
	ssize_t (*show)(struct bus_type *bus, char *buf);
	ssize_t (*store)(struct bus_type *bus, const char *buf, size_t count);
};
```

**driver_attribute**
```c
struct driver_attribute {
	struct attribute 			attr;
	ssize_t (*show)(struct device_driver *driver, char *buf);
	ssize_t (*store)(struct device_driver *driver, size_t count);
}
```

**device_attribute**
```c
struct device_attribute{
	struct attribute			attr;
	ssize_t (*show)(struct device *dev, struct device_attribute *attr, char *buf);
	ssize_t (*store)(struct device *dev, struct device_attribute *attr, const char *buf size_t count);
}
```

`sysfs` 中的 `目录` 来源于 `bus_type`，`device_driver`，`device`，而目录中的文件则来源于 `attribute`。  
Linux内核也定义了一些快捷方式以方便 `attribute` 的创建工作。  

```c
#define DRIVER_ATTR(_name, _mode, _show, _store) struct driver_attribute driver_attr_##_name = __ATTR(_name, _mode, _show, _store)
#define DRIVER_ATTR_RW(_name) struct driver_attribute driver_attr_##_name = __ATTR_RW(_name)
#define DEVICE_ATTR_RO(_name) struct driver_attribute driver_attr_##_name = __ATTR_RO(_name)
#define DEVICE_ATTR_WO(_name) struct driver_attribute driver_attr_##_name = __ATTR_WO(_name)

#define DEVICE_ATTR(_name, _mode, _show, _store) struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
#define DEVICE_ATTR_RW(_name) struct device_attribute driver_attr_##_name = __ATTR_RW(_name)
#define DEVICE_ATTR_RO(_name) struct device_attribute driver_attr_##_name = __ATTR_RO(_name)
#define DEVICE_ATTR_WO(_name) struct device_attribute driver_attr_##_name = __ATTR_WO(_name)

#define BUS_ATTR(_name, _mode, _show, _store) struct bus_attribute bus_attr_##_name = __ATTR(_name, _mode, _show, _store)
#define BUS_ATTR_RW(_name) struct bus_attribute bus_attr_##_name = __ATTR_RW(_name)
#define BUS_ATTR_RO(_name) struct bus_attribute bus_attr_##_name = __ATTR_RO(_name)
```

### udev 规则文件
udev的规则文件以行为单位，以 `#` 代表注释行。其余的每一行代表一个规则。  
每个规则分成一个或者多个 `匹配部分` 和 `赋值部分`  
匹配部分用匹配专用的关键字来表示，相应的赋值部分用赋值专用的关键字表示。  

`匹配关键字` 包括：
+ ACTION 行为
+ KERNEL 匹配内核设备名
+ BUS 总线类型
+ SUBSYSTEM 匹配子系统名
+ ATTR 属性等

`赋值关键字` 包括：
+ NAME 创建设备文件名
+ SYMLINK 符号创建链接名
+ OWNER 设置设备的所有者
+ GROUP 设置设备的组
+ IMPORT 调用外部程序
+ MODE 节点访问权限

例如
```udev
SUBSYSTEM=="net",
ACTION=="add",
DRIVERS=="?*",
ATTR{address}=="08:00:27:35:be:ff",
ATTR(dev_id)=="0x0",
ATTR{type}=="1",
KERNEL=="eth",
NAME=eth1
```
前五行为 `匹配部分` ，最后一行为 `赋值部分`  

当系统出现新硬件属于 `net` 子系统范畴时，系统对该硬件采取的动作是 `add` 这个新的硬件，且这个硬件的地址是 `08:00:27:35:be:ff`，`dev_id` 的属性是 `0x0`，`type` 的属性为1等，此时，对这个硬件在 `udev` 层施行的动作时创建 `/dev/eth` 。

`udev规则` 的写非常灵活，在 `匹配部分` 可以采用 \*、? 和 其他的一些通配符来灵活匹配多个项目。
+ \* 类似于 `shell` 中的 \* 通配符，代替任意长度的任意字符串。
+ ？ 代表一个字符
+ %k 就是 `KERNEL`
+ %n 是设备 `KERNEL` 的序号


下面指令可以用于查找设备规则文件。
```shell
udevadm info -a -p /sys/devices/platform/serial8250/tty/ttyS0/
```

如果 `/dev/` 下面的节点已经被创建，但是不知道它对应的 `/sys` 具体节点路径，可以采用 
```shell
udevadm info -a -p $(udevadm info -q path -n /dev/<节点名>)
```
的方式反向查询。

在嵌入式系统中也可以采用 `udev` 的轻量版本 `mdev`，`mdev` 集成于 `busybox` 中，在编译 `busybox` 的时候，选中 `mdev` 相关项目即可。

