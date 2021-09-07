# LiteOS 异常管理 使用方法
## 功能
异常接管对系统运行期间发生的芯片硬件异常进行处理，不同芯片的异常类型存在差异，具体异常类型可以查看芯片手册。

## 定位流程
异常接管一般的定位步骤如下：
+ 打开编译后生成的镜像反汇编（asm）文件
+ 搜索PC指针（指向当前正在执行的指令）在asm中的位置，找到发生异常的函数
+ 根据LR值查找异常函数的父函数
+ 重复步骤3，得到函数间的调用关系，找到异常原因

## 注意事项
要查看调用栈信息，必须添加编译选项宏 `-fno-omit-frame-pointer` 支持stack frame，否则编译时FP寄存器是关闭的

## 实例
在某ARM32平台上通过错误释放内存，触发系统异常。  
系统异常被挂起后，能在串口中看到异常调用栈打印信息和关键寄存器信息，如下所示，其中excType表示异常类型，此处值为4表示数据终止异常，其它数值可以查看芯片手册。  

```
excType: 4
taskName = MNT_send
taskId = 6
task stackSize = 12288
excBuffAddr pc = 0x8034d3cc
excBuffAddr lr = 0x8034d3cc
excBuffAddr sp = 0x809ca358
excBuffAddr fp = 0x809ca36c
*******backtrace begin*******
traceback 0 -- lr = 0x803482fc
traceback 0 -- fp = 0x809ca38c
traceback 1 -- lr = 0x80393e34
traceback 1 -- fp = 0x809ca3a4
traceback 2 -- lr = 0x8039e0d0
traceback 2 -- fp = 0x809ca3b4
traceback 3 -- lr = 0x80386bec
traceback 3 -- fp = 0x809ca424
traceback 4 -- lr = 0x800a6210
traceback 4 -- fp = 0x805da164
```

通过这些信息可以定位到异常所在函数和其调用栈关系，为分析异常原因提供第一手资料
### 定位步骤如下
打开编译后生成的 `.asm` 文件，一般放在 `out` 文件夹内  
搜索PC指针 0x8034d3cc 在文件中的位置(搜索时去掉0x)  

PC地址指向发生异常时程序正在执行的指令。在当前执行的二进制文件对应的asm文件中，查找PC值8034d3cc，找到当前CPU正在执行的指令行，得到如下图所示结果。

![[Pasted image 20210907103618.png]]

从图中可以看到:
+ 异常时CPU正在执行的指令是ldrh r2, \[r4, \#-4\]
+ 异常发生在函数osSlabMemFree中

结合ldrh指令分析，此指令是从内存的(r4-4)地址中读值，将其load到寄存器r2中。再结合异常时打印的寄存器信息，查看此时r4的值。下图是异常时打印的寄存器信息，可以看到，r4此时值是0xffffffff

![[Pasted image 20210907103728.png]]

r4的值超出了内存范围，故CPU执行到该指令时发生了数据终止异常。根据汇编知识，从asm文件可以看到，r4是从r1 mov过来，而r1是函数第二个入参，于是可以确认，在调用osSlabMemFree时传入了0xffffffff（或-1）这样一个错误入参

接下来，需要查找谁调用了osSlabMemFree函数

根据 LR链接寄存器值 查找调用栈

从异常信息的backtrace begin开始，打印的是调用栈信息。在asm文件中查找backtrace 0对应的LR，如下图所示

![[Pasted image 20210907103904.png]]

可见，是LOS_MemFree调用了osSlabMemFree。  
依此方法，可得到异常时函数调用关系如下：  
MNT_buf_send(业务函数) -> free -> LOS_MemFree -> osSlabMemFree。

最终，通过排查业务中MNT_buf_send实现，发现其中存在错误使用指针的问题，导致free了一个错误地址，引发上述异常。