# 信号

## 信号简介

### 信号的基本概念

软件模拟中断，进程接受信号后做出相应的响应

### 产生信号的方式

#### 硬件

- 执行非法指令
- 访问非法内存
- 驱动程序问题
- ...

#### 软件

- 控制台
  - ctrl+c：中断信号
  - ctrl+|：退出信号
  - ctrl+z：停止信号
- kill 指令
- 程序调用 `kill()` 函数

### 信号的处理方式

- 忽略：进程对信号进行忽略
- 捕获：进程会调用相应的处理函数，进行相应的处理
- 默认：使用系统默认处理方式来处理信号

## 常用信号分析

| 信号名     | 信号编号 | 产生原因        | 默认处理方式     |
| ------- | ---- | ----------- | ---------- |
| SIGHUP  | 1    | 关闭中断        | 终止         |
| SIGINT  | 2    | ctrl+c      | 终止         |
| SIGQUIT | 3    | ctrl+\\     | 终止+转储      |
| SIGABRT | 6    | abort()     | 终止+转储      |
| SIGPE   | 8    | 算术错误        | 终止         |
| SIGKILL | 9    | kill -9 pid | 终止，不可捕获/忽略 |
| SIGUSR1 | 10   | 自定义         | 忽略         |
| SIGSEGV | 11   | 段错误         | 终止+转储      |
| SIGUSR2 | 12   | 自定义         | 忽略         |
| SIGALRM | 14   | alarm()     | 终止         |
| SIGTERM | 15   | kill pid    | 终止         |
| SIGCHLD | 16   | (子)状态变化     | 忽略         |
| SIGTOP  | 19   | ctrl+z      | 暂停，不可捕获/忽略 |

## signal_kill_raise 函数

### signal 函数

```c
// 头文件 
#include<signal.h>
// 函数原型
typedef void (*sighandler_t)(int);
sighandler_t signal(int signum, sighandler_t handler);
/*
 * 参数：
 * signum：要设置的信号
 * handler：
 *     SIG_IGN：忽略
 *     SIG_DFL：默认
 *     void (*sighandler_t)(int)：自定义
 * 返回值：
 * 成功：上一次设置的 handler
 * 失败：SIG_ERR
*/
```

### kill 函数

```c
// 头文件
#include<sys/type.h>
#include<signal.h>
// 原型函数
int kill(pid_t pid, int sig);
/* 
 * 参数：
 * pid：进程id
 * sig：要发送的信号
 * 返回值：
 * 成功：0
 * 失败：1
*/ 
```

### raise 函数

```c
// 头文件
#include<signal.h>
// 原型函数
int raise(int sig);
```

## 信号集处理函数

### 屏蔽信号集

屏蔽某些信号，是一个64位的位图

- 手动
- 自动

### 未处理信号集

信号如果被屏蔽，则记录在未处理信号集中

- 非事实信号(1~31)，不排队，只留一个
- 事实信号(31~64)，排队，全部保留

### 信号集相关API

```c
// 将信号集合初始化为0
int sigemptyset(sigset_t *set);
// 将信号集合初始化为1
int sigfillset(sigset_t *set);
// 将信号集合某一位置设1
int sigaddset(sigset_t *set, int signum);
// 将信号集合某一位设0
int sigdelset(sigset_t *set, int signum);
// 使用设置好的信号集去修改信号屏蔽集
int sigprocmask(int how, const sigset_t *set, sigset_t *oldest);
// 参数 how
//   SIG_BLOCK：屏蔽某个信号(屏蔽信号集 | set)
//   SIG_UNBLOCK：打开某个信号 (屏蔽信号集 & ~set)
//   SIG_SETMASK：屏蔽集 = set
// 参数 oldest
//   保存旧的屏蔽集的值，NULL 表示不保存
```
