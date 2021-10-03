# [文件描述符和打开方式](https://www.bilibili.com/video/BV1JK4y1t7io?p=41&spm_id_from=pageDriver)
## 系统IO编程
直接调用Linux系统开放出来的系统调用接口
+ open
+ write
+ read
+ lseek
+ close

```c
int fd;		// 定义文件描述符
fd = open(filename,flags,mode);
// filename:文件名
// flags :打开文件的模式
// mode:设置文件权限
lseek(fd,offset,whence);
// offset读写位置的偏移量
// whence文件读写位置基准值
write(fd,buf,length);
read(fd,buf,length)
close(fd);
```
### 文件描述符
相当于一种特殊的索引
实际上就是进程中file_struct结构体成员中fd_array成员的数组下标

### 文件的打开模式
主模式：互斥
+ 只读模式 O_RDONLY
+ 只写模式 O_WRONLY
+ 读写模式 O_RDWR

副模式：
+ O_CREATE 当文件不存在，创建文件
+ O_APPEND 追加模式，写入时写到文件的末尾
+ O_DIRECT 直接IO模式 直接写磁盘
+ O_SYNC 同步模式
+ O_NOBLOCK 非阻塞模式

#### OPEN函数
**头文件**
```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
```
**函数原型**
```c
// 当文件存在时
int open(const char *pathname,int flags)
// 当文件不存在时
int open(const char *pathname,int flags,int perms)
```
**返回值**
成功：文件描述符
失败：-1
#### CLOSE函数
**头文件**
```c
#include <unistd.h>
```
**函数原型**
```c
int close(int fd);
```
**返回值**
成功：0
失败：1

#### READ函数
**头文件**
```c
#include <unistd.h>
```
**函数原型**
```c
ssize_t read(int fd,void *buff,size_t)
```
**返回值**
成功：
+ count：成功读取到全部字节
+ 0～count：
	+ 生育文件程度小于count
	+ 读取期间被异步信号打断
失败：
+ -1：读取错误

#### WRITE函数
**头文件**
```c
#include <unistd.h>
```
**函数原型**
```c
ssize_t write(int fd,void *buff,size_t count)
```
**返回值**
成功：
+ count：成功读取到全部字节
+ 0～count：
	+ 生育文件程度小于count
	+ 读取期间被异步信号打断
失败：
+ -1：读取错误
#### LSEEK函数
设置文件的读写位置
**头文件**
```c
#include <unistd.h>
```
**函数原型**
```c
off_t lseek(int fd,off_t offset,int whence)
```
+ 若whence为`SEEK_SET`，基准点为`文件开头`
+ 若whence为`SEEK_CUR`，基准点为`当前位置`
+ 若whence为`SEEK_END`，基准点为`文件末尾`

**返回值**
成功：文件偏移位置值
失败：-1

#### SYNC函数
将页缓存的内容强制写入到磁盘中
**头文件**
```c
#include <unistd.h>
```
**函数原型**
void sync(void);
返回值：无
## 标准IO编程
使用glibc库的库函数

### 标准IO函数
进入用户空间和内核空间都是需要时间的，如果频繁调用系统IO函数，会降低系统的性能

C标准库实现了一个IO缓冲区
### 常见的标准IO函数
+ fopen()
+ fclose()
+ fread()
+ fwrite()
+ fseek()
+ fflush()
	+ 强制将IO缓存区的内容写到页缓存区

![Pasted image 20210620010508](../../../../../pictures/Pasted%20image%2020210620010508.png)

## 文件IO的五大模式
+ 阻塞模式
	+ 当文件IO没办法正常读写数据是，就会出于休眠的状态
+ 非阻塞模式
	+ 即使没有正常读写，也会返回，不会出于休眠状态
+ IO多路复用
+ 异步IO
+ 信号驱动IO
