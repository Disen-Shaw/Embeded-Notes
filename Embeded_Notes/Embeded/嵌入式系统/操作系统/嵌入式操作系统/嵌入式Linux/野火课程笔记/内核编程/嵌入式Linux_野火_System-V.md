# System-V

## System-V 进程间通信的主要特点

- 独立于进程
- 没有文件名和文件描述符
- 进程间通信对象具有 KEY 和 ID

## 消息队列

### 消息队列的用法

- 定义一个 key(ftok)
- 构造消息对象(msgget)
- 发送特定类型的消息(msgsnd)
- 在其他进程接收特定类型的消息(msgrcv)
- 删除消息队列

### ftok 函数

```c
// 函数原型
key_t ftok(const char *path, int proj_id)
/* 
 * 参数
 * path：一个合法路径
 * proj_id：一个整数
 * 返回值：
 * 成功：合法键值
 * 失败：-1
*/ 
```

### msgget 函数

获取消息队列 ID

```c
int msgget(key_t key, int msgflg);
/* 
 * 参数：
 * key：消息队列键值
 * msgflg：
 *   IPC_CREAT：如果消息队列不存在，则创建
 *   mode：访问权限
 * 返回值：
 *   成功：改消息队列的 ID
 *   失败：-1
```

### msgsnd 函数

发送消息到消息队列

```c
struct msgbuf{
	long mtype;    // 消息标识
	char mtext[1]; // 消息内容
}

int msgsnd(int msqid, const void *msgp, size_t msgsz, int msgflg);
/*
 * 参数
 *   msqid：消息队列
 *   msgp：消息缓存区，一般定义一个 msgbuf
 *   msgsz：消息正文字节数
 *   msgflg：
 *     IPC_NOWAIT：非阻塞发送
 *     0：阻塞发送
 * 返回值：
 *   成功：0
 *   失败：-1
*/
```

### msgrcv 函数

从消息队列读取消息

```c
// 函数原型
ssize_t msgrcv(int msgid, void *msgp, size_t msgsz, long msgtyp, int msgflg);
/*
 * 参数
 *   msgid：消息队列 ID
 *   msgp：消息缓存区
 *   msgsz：消息正文的字节数
 *   msgtyp：要接收消息的标识
 *   msgflg：
 *     IPC_NOWAIT：非阻塞读取
 *     MSG_NOERROR：截断消息
 *     0：阻塞读取
 * 返回值：
 *   成功：0
 *   失败：-1
*/
```

### msgctl 函数

设置或者获取消息队列的相关属性

```c
int msgctl(int msgid, int cmd, struct maqid_ds *buf);
/* 
 * 参数：
 *   msgid：消息队列 ID
 *   cmd：
 *     IPC_STAT：获取消息队列的属性
 *     IPC_SET：设置消息队列的属性
 *     IPC_RMID：删除消息队列
 *   buf：相关结构体缓冲区
*/
```

## 信号量

本质就是计数器

### 作用

保护共享资源

- 同步
- 互斥

### 信号量使用方法

- 定义一个唯一的 key ([ftok](嵌入式Linux_野火_System-V.md#ftok\ 函数))
- 构造一个信号量 (semget)
- 初始化集中的信号量 (semctl SETVA)
- 对信号量进行 P/V 操作(semop)
- 删除信号量(semctl RMID)

### semget 函数

用于获得信号量 ID

```c
// 函数原型
int semget(key_t key, int nsems, int semflg);
/* 
 * 参数：
 *   key：信号量键值
 *   nsems：信号量数量
 *   semflg：
 *     IPC_CREATE：信号量不存在则创建信号量
 *     mode：信号量的权限
 * 返回值：
 *   成功：信号量ID
 *   失败：-1
*/
```

### semctl 函数

获取或者设置信号量的相关属性

```c
union semun{
  int val;
  struct semid_ds *buf;
}
// 函数原型
int semctl(int semid, int semnum, int cmd, union semun arg);
/* 
 * 参数：
 *   semid：信号量ID
 *   semnum：信号量编号
 *   cmd：
 *     IPC_STAT：获取信号量的属性信息
 *     IPC_SET：设置信号量的属性
 *     IPC_RMID：删除信号量
 *     IPC_SETVAL：设置信号量的值
 * 返回值：
 *   成功：由 cmd 的值决定
 *   失败：-1
*/
```

### semop 函数

```c
struct sembuf {
  short sem_num;  // 信号量编号
  short sem_op;   // 信号量 P/V 操作
  short sem_flg;  // 信号量行为，SEM_UNDO
}
// 函数原型
int semop(int semid, struct sembuf *sops, size_t nsops);
/* 
 * 参数：
 *   semid：信号量ID
 *   sops：信号量操作结构体
 *   nsops：信号量数量
 * 返回值：
 *   成功：0
 *   失败：-1
*/
```

## 共享内存

### 作用

高效率传输大量数据

### 使用方法

- 定义一个唯一的 key ([ftok](嵌入式Linux_野火_System-V.md#ftok\ 函数))
- 构造一个共享内存对象 (shmget)
- 共享内存映射 (shmat)
- 接触共享内存映射 (shmdt)
- 删除共享内存 (shmctl RMID)

### shmget 函数

用于获取共享内存 ID

```c
// 函数原型
int shmget(key_t key, int size, int shmflg);
/* 
 * 参数：
 *   key：共享对象键值
 *   size：共享内存大小
 *   shmflg：
 *     IPC_CREATE：共享内存不存在则创建
 *     mode：共享内存权限
 * 返回值：
 *   共享内存 ID
 *   失败：-1
*/
```

### shmat 函数

映射共享内存

```c
// 函数原型
int shmat(int shmid, const void *shmaddr, int shmflg);
/* 
 * 参数：
 *   shmid：共享内存ID
 *   shmaddr：映射地址.NULL为自动分配地址
 *   shmflg：
 *     SHM_RDONLY：只读方式映射
 *     0：可读可写
 * 返回值：
 *   成功：共享内存首地址
 *   失败：-1
*/
```

### shmdt 函数

解除共享内存映射

```c
// 函数原型
int shmdt(const void *shmaddr);
/*
 * 参数：
 *   shmaddr：映射地址
 * 返回值：
 *   成功：0
 *   失败：-1
 */
```

### shmctl 函数

获取或者设置共享内存的相关属性

```c
// 函数原型
int shmctl(int shmid, int cmd, struct shmid_ds *buf);
/*
 * 参数：
 *   shmid：共享内存id
 *   cmd：
 *     IPC_STAT：获取共享内存的属性信息
 *     IPC_SET：设置共享内存
 *     IPC_RMID：删除共享内存
 * 返回值：
 *   成功：由cmd类型决定
 *   失败：-1
 */
```
