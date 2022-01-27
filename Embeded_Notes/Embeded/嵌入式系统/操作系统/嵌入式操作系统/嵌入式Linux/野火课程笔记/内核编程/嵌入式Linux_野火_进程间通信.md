# 进程间通信 ipc

- 数据传输
- 资源共享
- 事件通知
- 进程控制

## Linux 系统下的进程间通信

- 早期 Unix系统进程间通信
  - 管道：数据传输
  - 信号：主要事件通知
  - FIFO：数据传输功能
- system-v( unix 主分支) 进程间通信
  - system-v 消息队列
  - system-v 信号量
  - system-v 共享内存
- socket(BSD) 进程间通信
  - 不同机器之间进行通信
- posix(IEEE) 进程间通信
  - posix 消息队列
  - posix 信号量
  - posix 共享内存

## 无名管道

```c
// 头文件
#include<unistd.h>
// 函数原型
int pipe(int pipefd[2]);
/*
 * 返回值
 * 成功：0
 * 失败：1
 */
```

### 无名管道特点

- 特殊文件，没有名字，无法使用 `open()` 函数，但是可以使用 `close()`
- 只能通过子进程继承文件描述符的形式使用
- `write()` 和 `read()` 操作可能阻塞进程
- 所有 文件描述符 被关闭后，无名管道被销毁

### 无名管道使用步骤

- 父进程 `pipe` 无名管道
- `fork()` 子进程
- `close()` 无用端口
- `write/read()` 读写端口
- `close` 读写端口

```c
// 头文件
#include <error.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
// 定义数据长度
#define MAX_DATA_LEN 256

int main(int argc, char *argv[]) {
  pid_t pid;
  int pipe_fd[2];
  int status;
  char buf[MAX_DATA_LEN];
  const char data[] = "Pipe test program";
  int real_read, real_write;

  memset((void *)buf, 0, sizeof(buf));

  /* 创建管道 */
  if (pipe(pipe_fd) < 0) {
    printf("pipe create error\n");
    exit(1);
  }

  /* 创建一个子进程 */
  if ((pid = fork()) == 0) {
    /* 子进程关闭写描述符 */
    close(pipe_fd[1]);
    /* 子进程读取管道内容 */
    if ((real_read = read(pipe_fd[0], buf, MAX_DATA_LEN)) > 0) {
      printf("%d bytes read from the pipe is %s\n", real_read, buf);
    }
    /* 关闭子进程读描述符 */
    close(pipe_fd[0]);

    exit(0);
  } else if (pid > 0) {
    /* 父进程关闭读描述 */
    close(pipe_fd[0]);
    if ((real_write = write(pipe_fd[1], data, strlen(data))) != 1) {
      printf("Parent write %d bytes : %s\n", real_write, data);
    }
    /* 关闭父进程写描述符 */
    close(pipe_fd[1]);

    /* 收集子进程退出信息 */
    wait(&status);
    exit(0);
  }
  return 0;
}
```

## 有名管道

```c
// 头文件
#include<sys/type.h>
#include<sys/state.h>
// 函数原型
int mkfifo(const char *filename, mode_t mode);
/* 
 * 返回值
 * 成功 0
 * 失败 1
*/
```

### 有名管道特点

- 有文件名，可以使用 `open()` 函数打开
- **任意进程** 之间通信
- `write()` 和 `read()` 操作可能会 **阻塞进程**
  - 读数据时，管道内 没有数据 会阻塞
  - 写数据时，缓存区写满
- `write()` 操作具有 [原子性](../../内核驱动编程/书上内容笔记/Linux_设备驱动中的并发控制#原子操作)

### 有名管道使用步骤

+ 第一个进程 `mkfifo()` 有名管道
+ `open()` 有名管道
+ 第二个进程 `open()` 有名管道，`read/write()` 数据
+ `close()` 有名管道