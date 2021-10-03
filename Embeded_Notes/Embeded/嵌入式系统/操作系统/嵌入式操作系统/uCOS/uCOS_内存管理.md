# uCOSIII内存管理
## 内存管理
### uCOSIII存储控制
作为一个RTOS操作系统，内存管理是必备的功能，uCOSIII 也有内存管理的能力。通常可以调用ANSC C或者GNU C编译器的`malloc()`和`free()`函数来动态分配和释放内存\
<u>但是在嵌入式实时操作系统中最好不这么做，多次这种操作会把原来很大的一块连续的存储区逐渐的分割成许多非常小，并且彼此不相邻的存储区域，就是存储碎片</u>。

uCOSIII中提供了一种替代malloc()和free()函数的方法，uCOSIII中将存储空间分为区和块，每个存储区有数量不等大小相同的存储块，在一个系统中可以有很多的存储区。

> 不推荐用uCOS的内存管理，推荐自己写一个内存管理的API

一般存储区是固定的，在程序可以用数组表示一个存储区，比如`uint8_t buffer[20][10]`，就表示一个拥有20个存储块，每个存储块10个字节的存储区。
![Pasted image 20210712165235](../../../../../pictures/Pasted%20image%2020210712165235.png)


### 存储控制块
uCOSIII中用存储控制块表示存储区，存储控制块为`OS_MEM`
```c
struct os_mem{
	OS_OBJ_TYPE		Type;
	void 			*AddrPtr;
	CPU_CHAR		*NamePtr;
	void 			*FreelistPtr;
	OS_MEM_SIZE		BlkSize;
	OS_MEM_QTY		NbrMax;
	OS_MEM_QTY		NbrFree;
#if OS_CFG_DBG_EN > 0U
	OS_MEM			*DbgPrevPtr;
	OS_MEM			*DbgNextPtr;
#endif
};
```

### 创建好的存储区
![Pasted image 20210712165912](../../../../../pictures/Pasted%20image%2020210712165912.png)
OS_MEM为存储控制块

## 存储管理相关的API函数
| 函数名        | 作用                         |
| ------------- | ---------------------------- |
| OSMemCreate() | 创建一个存储分区             |
| OSMemGet()    | 从存储分区中获得一个存储块   |
| OSMemPut()    | 将一个存储块归还到存储分区中 |

存储区中存储块的数量大于2,且存储区的大小为4的倍数
申请内存要判断内存是否申请成功


