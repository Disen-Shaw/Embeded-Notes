---
date updated: '2021-10-01T07:49:03+08:00'

---

# Linux物理地址与虚拟地址

## 单片机裸机与Linux系统外设驱动区别

在单片机上想要操作外设可以直接操作外设所在的物理地址寄存器\
例如：

```c
unsigned int *p = 0x12345678;
*p = xxx;
```

因为 Linux 使能了 `MMU`，因此在 Linux 系统上不可以直接对物理地址直接操作，否则会产生 `段错误`
如果想要使用硬件外设，需要先将物理地址转化为虚拟地址

## 使能MMU的优势

- 让虚拟地址成为可能
- 无法直接对物理地址进行读写操作，增加了系统更加的安全性

## Linux中物理地址到虚拟地址的转化

在Linux中使用两个函数完成物理地址到虚拟地址的转化

- ioremap：将物理地址转化为虚拟地址
  - 执行成功时返回虚拟地址首地址
  - 执行失败时返回NULL
- iounmap：释放掉ioremap映射的地址

原型如下：

```c
void iomem *__ioremap(unsigned long phys_addr, unsigned long size);
void iounmap(void *addr);
```

物理地址只能映射一次，多次映射会失败\
可以使用 `cat /proc/iomem` 查看映射情况
