# Linux 文件系统
## Linux下的文件操作

### Linux的系统调用
#### 创建文件操作
**int creat(const char \*file_name, mode_t mode)**  
+ `mode` 指定新建文件的存取权限，它同 `umask` 一起决定文件的最终权限  
+ `umask` 可以通过系统调用的方式改变。
	+ **int umask(int newmask);**
	+ 将 `umask` 设定为 `newmask`，然后返回旧的 `umask` ，它只影响读、写和执行权限。

#### 文件打开操作
**int open(const char \*pathname, int flag)**  
**int open(const char \*pathname, int flag, mode_t mode)**  
+ `pathname` 是要打开的文件名(包含路径，缺省默认当前目录下)
+ `flag` 是下面表中的一个或者几个值

| 标志      | 含义                               |
| --------- | ---------------------------------- |
| O_RDONLY  | 以只读的方式打开文件               |
| O_WRONLY  | 以只写的方式打开文件               |
| O_RDWR    | 以读写的方式打开文件               |
| O_APPEND  | 以追加的方式打开文件               |
| O_CREAT   | 创建一个文件                       |
| O_EXEC    | 如果创建的文件存在，则发生一个错误 |
| O_NOBLOCK | 以非阻塞的方式打开文件             |
| O_TRUNC   | 如果文件存在，则删除文件的内容     |

前三个只读、只写、读写的标志只能选择一个使用。  
如果使用了 `O_CREAT` 选项创建文件，则使用第二种打开的函数，这时还要指定创建文件的 `mode`。  

| 标志    | 含义                   |
| ------- | ---------------------- |
| S_IRUSR | 用户可以读             |
| S_IWUSR | 用户可以写             |
| S_IXUSR | 用户可以执行           |
| S_IRWXU | 用户可以读、写、执行   |
| S_IRGRP | 组可以读               |
| S_IWGRP | 组可以写               |
| S_IXGRP | 组可以执行             |
| S_IRWXG | 组可以读、写、执行     |
| S_IROTH | 其他人可以读           |
| S_IWOTH | 其他人可以写           |
| S_IXOTH | 其他人可以执行         |
| S_IRWXO | 其他人可以读、写、执行 |
| S_ISUID | 设置用户执行ID         |
| S_ISGID | 设置组执行ID           |

除了可以用上面的宏定义文件的权限之外，还可以用数字来表示  
Linux用5个数字表示文件的各种权限  
+ 第一位表示设置用户ID
+ 第二位表示设置组ID
+ 第三位表示自己的权限位	
+ 第四位标示组的权限位
+ 最后一位表示其他人的权限位

如果文件打开成功，则会返回一个文件描述符，之后对文件的操作就可以对操作符进行操作。  

#### 文件读操作
**int read(int fd, void \*buf, size_t length)**  
+ buf是指向缓冲区的指针，length为缓冲区的大小(字节为单位)
+ read()实现从描述符 `fd`  所制定的文件中读取 `length` 个字节到 `buf` 所指向的缓冲区返回值为实际读取的字节数。

#### 文件写操作
**int write(int fd, const void \*buf, size_t length)**  
+ 将缓冲区 `buf` 中的数据写入到文件描述符 `fd` 中，返回值为实际写入的字节数。

#### 文件定位操作
**int lseek(int fd, offset_t offset, int whence)**  
+ 将文件读写指针相对 `whence` 移动 `offset` 个字节。
+ 操作成功时，返回文件指针相对于文件头的位置
+ 参数 `whence` 可以使用下面的几个数值
	+ SEEK_SET：相对文件夹
	+ SEEK_CUR：相对文件读写指针的当前位置
	+ SEEK_END：相对文件末尾
+ `offset` 可以取负值

#### 文件关闭
**int close(int fd)**
操作完成之后，要关闭文件，此时只要调用 `close` 就可以了。

### C库文件操作
C库函数的文件操作实际上独立于集体的操作平台  
不管实在DOS、Windows、Linux还是VxWorks中都是这些函数(可移植效果好)  

#### 文件的创建和打开操作
**FILE \*fopen(const char \*path, const char \*mode) **
+ fopen 用于指定文件 `filename`，其中 `mode` 为打开方式
+ C库函数支持下面的文件打开方式

| 标志         | 含义                                                           |
| ------------ | -------------------------------------------------------------- |
| r、rb        | 以只读的方式打开                                               |
| w、wb        | 以只写的方式打开，如果文件不存在，则创建文件，否则文件被截断   |
| a、ab        | 以追加的方式打开，如果文件不存在，则创建文件                   |
| r+、r+b、rb+ | 以读写的方式打开                                               |
| w+、w+b、wh+ | 以读写方式打开，如果文件不存在时，创建新的文件，否则文件被截断 |
| a+、a+b、ab+ | 以读和追加的方式打开，如果文件不存在，则创建新的文件                                                               |
+ `b` 用于区分二进制文件和文本文件

#### 文件读写操作
C库函数支持以字符、字符串等为单位，支持按照某种格式可哦面向哦模糊文件的读写  
**int fgetc(FILE \*stream)**  
**int fputc(int c, FILE \*stream)**  
**char fgets(char \*s, int n, FILE \*stream)**  
**int fputs(const char \*s, FILE \*stream)**  
**int fprintf(FILE \*stream, const char \*format, ... )**  
**int fscanf(FILE \*stream, const char \*format, ...  )**  
**size_t fread(void \*ptr, size_t size, size_t n, FILE \*stream)**  
**size_t fwrite(void \*ptr, size_t size, size_t n, FILE \*stream)**  

+ `fread()` 实现从 `流stream` 中读取n个字段，每个字段为 `size` 字节并将读取到的字段放入 `str` 所指的字符数组中，返回实际已读取的字段数。
+ 当读取的字段数小于n时，可能是函数调用时出现了错误，也可能是读取到了文件的结尾，此时要调用 `feof()` 和 `ferror()` 进行判断。

+ `write()` 实现从缓冲区 `ptr` 中所指的数组中把n个字符写到 `流stream` 中，每个字段长 `size` 个字节，返回实际写入的字段数。 

#### 定位操作
**int fgetpos(FILE \*stream, fpos_t \*pos)**  
**int fsetpos(FILE \*stream, const fpos_t \*pos)**  
**int fseek(FILE \*stream, long offset, int whence)**

#### 关闭文件
**int fclose(FILE \*stream)**

## Linux 文件系统
### Linux 文件系统目录结构
[[Linux_目录结构]]

### Linux 文件系统与设备驱动
下图是Linux中虚拟文件系统、磁盘/Flash文件系统以及一般的设备文件与设备驱动之间的关系。  

![[Pasted image 20210818085441.png]]

应用程序和 `VFS` 之间的接口是系统调用，而 `VFS` 与文件系统以及设备文件之间的接口是 `file_operations` 结构体成员函数，这个结构体包含对文件进行打开、关闭、读写、控制的一系列成员函数，关系如下图所示：

![[Pasted image 20210818090217.png]]

由于字符设备上层没有类似于磁盘的 `ext2` 等文件系统，所以字符设备的 `file_operations` 成员函数就直接由驱动提供了。  
**`file_operations` 是字符设备驱动的核心。**

块设备有两种访问方法，
+ 不通过文件系统，直接访问裸设备
	+ 在Linux 内核实现了统一的 `def_blk_fops` 这样一个 `file_operations` 
		+ 源代码位于 `fs/block_dev.c` 

	+ 运行类似与 `dd if=/dev/sdb1 of=sdb1.img` 的命令的时候把整个裸分区复制到 `sdb1.img` + 
	+ 此时走的是 `def_blk_fops` 这个 `file_operations`
+ 通过文件系统访问块设备
	+ `file_operations` 的实现位于文件系统内，文件系统会把针对于文件的读写转化为针对块设备原始扇区的读写。
	+ ext2、fat、Btrfs等文件系统中会实现针对 `VFS` 的 `file_operations` 成员函数
	+ 设备驱动层将看不见 `file_operations` 的存在。

### 设备驱动程序的设计中关心到的两种结构体
####  file 结构体
`file` 结构体代表一个打开的文件，系统中每个打开的文件在内核空间都有一个关联 `struct file`。  
它由内核在打开文件时创建，并传递给在文件上操作的任何函数。在文件的所有实例都关闭后，内核释放这个数据结构。  
`在内核和驱动源代码中，struct file 的指针通常被命名为file或者filp`

```c
struct file {
	union {
		struct llist_node	fu_llist;
		struct rcu_head		fu_rcuhead;
	} f_u;
	struct path		f_path;
	#define f_dentry	f_path.dentry
	struct inode	*f_inode;  					/* cached value */
	const struct file_operations *f_ops;			/* 和文件相关的操作 */
	/*
	 * Protects f_ep_links, f_flags.	
	 * Must not br taken from IRQ context
	*/
	spinlock_t				f_lock;
	atomic_long_t 			f_count;
	unsigned int 			f_flags;			/* 文件标志 如O_RDONLY那些 */
	fmode_t					f_mode;				/* 文件读写模式 */
	struct mutex			f_pos_lock;	
	loff_t 					f_pos;				/* 当前读写位置 */
	struct fown_struct		f_owner;
	const struct cred 		*f_cred;
	struct file_ra_statef	f_ra;
	
	u64 					f_version;
	#ifdef CONFIG_SECURITY
	void 					*f_security;
	#endif
	/* needed for tty driver, and maybe others */
	void 					*private_data; 		/* 文件私有数据 */
	
	#ifdef CONFIG_EPOLL
	/* Used by fs/eventpool.c to link all the hooks to thie file */
	struct list_head		f_ep_links;
	struct list_head		f_tfile_llink;
	#endif
	
	struct address_space 	*f_mapping;
} __attribute__((aligned(4)));
```

文件读、写模式 `f_mode` 、标志 `f_flags` 都是设备驱动关心的内容，而私有数据指针 `private_data` 在设备驱动中被广泛使用，大多被志向社别驱动自定义以用于描述设备的结构体。  
下面的代码可以用于判断以阻塞方式还是非阻塞方式打开设备文件。

```c
if(file->f_flags & O_NONBLOCK) 			/* 非阻塞 */
	pr_debug("open: nonblocking \n");
else
	pr_debug("open: blocking \n");
```

#### inode结构体
`VFS inode` 包含了文件访问权限、属主、组、大小、生成时间、访问时间、最后修改时间等信息。  
他是Linux管理文件西容的最基本单位，也是文件系统连接任何子目录、文件的桥梁。  

```c
struct inode{
	...	
	umode_t 						i_mode;			/* inode 的权限 */
	uid_t 							i_uid;			/* inode 拥有者的权限 */
	gid_t							i_gid;			/* inode 所属群 */
	dev_t							i_rdev;			/* 若是设备文件， 此字段将记录设备的设备号 */
	loff_t 							i_size;			/* inode 所代表的文件大小 */
	struct timespace 				i_atime;		/* inode 最后一次存取时间 */
	struct timespace 				i_mtime;		/* inode 最后一次修改时间 */
	struct timespace 				i_ctime;		/* inode 产生时间 */
	
	unsigned int 					i_blkbits;		
	blkcnt_t						i_blocks;		/* inode所使用的blokc数，一个block为512字节* /
	union {
		struct pipe_inode_info		*i_pipe;
		struct block_device 		*i_bdev;
		struct cdev 				*i_cdev;
		/* 如果是块设备，为其对应的 block_device 结构体指针 */
		/* 如果是字符设备，为其对应的 cdev 结构体指针 */
	}
	...
}
```
对于表示设备文件的 `inode` 结构，`i_rdev` 字段包含设备编号。  
**Linux内核设备编号分为主设备编号和次设备编号，前者为 `dev_t` 高12位，后者为 `dev_t` 的低20位。 **   
下面的操作用于从一个 `inode` 中获取主设备号和此设备号

```c
unsigned int iminor(struct inode *inode);
unsigned int imajor(struct inode *inode);
```

查看 `/proc/devices` 文件可以获知系统中注册的设备  
第一列是主设备号，第二列为设备名
查看 `/dev` 目录可以获知系统中包含的设备文件

主设备号是驱动对应的概念，同一类的设备一般使用相同的主设备号，不同的类设备一般使用不同的主设备号。因为同一个驱动可以支持多个同类设备，因此用此设备号来描述驱动的设备的序号，序号一般从0开始。

