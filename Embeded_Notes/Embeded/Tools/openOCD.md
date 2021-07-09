# OPENOCD

## openocd简介

**什么是openocd**

开源调试器，针对嵌入式设备的调试

功能在**仿真器**的辅助下完成(小盒子jlink，stlink)

仿真器有时候被封装成独立的加密狗，称为硬件加密狗。

一些开开发板上直接集成了硬件借口加密狗，可以通过USB直接调试

对于一些芯片有专门的仅支持擦写Flash的编程下载器，不支持调试和边界扫描。

openocd不支持这种下载器。

## openocd运行

**基本知识**

```shell
# 使用命令
openocd -f config1.cfg -f config2.cfg -f config3.cfg
```

配置文件和脚本按照以下顺序搜索：

1. 当前工作目录
2. 命令选项 -s 后面的地址目录
3. 使用 `add_script_search_dir` 命令定义的目录地址
4. 家目录/.openocd
5. `OPENOCD_SCRIPTS`环境变量设置
6. `pkgdatadir/site`站点中的脚本
7. `pkgdatadir/scripts`OpenOCD支持的脚本库

**简单启动**

如果找到了适用于 JTAG适配器或目标板子的脚本，可以通过如下几条命令连接上JTAG适配器，并启动调试功能。

```shell
openocd -f interface/ADAPTER.cfg -f board/MYBOARD.cfg
openocd -f interface/ftdi/ADAPTER.cfg -f board/MYBOARD.cfg
```

如果要进行复位信号的配置，可以使用 `-c 'rreset_configtrst_and_srsteset_config'`命令。

如果一切正常，则看到如下信息：

```shell
Info : JTAG tap: lm3s.cpu tap/device found: 0x3ba00477
(mfg: 0x23b, part: 0xba00, ver: 0x3)
```

## 配置文件解析


## 使用详解
### -c命令
openocd -c "命令"
#### 选择接口
命令为 -c "interface +xxxlink"		// 使用jlink
~~~shell
openocd -c "interface +xxxlink"
~~~
#### 选择传输方式
加上 -c "transport select swd"		// 查找并使用SWD
~~~shell
openocd -c "interface +xxxlink" -c "transport select swd"
~~~
#### 配置时钟
再加上 -c "adapter_khz 1000"		// 设置为1000hz
~~~shell
openocd -c "interface +xxxlink" -c "transport select swd" -c "adapter_khz 1000"
~~~
到这里直接进入调试运行平台 

#### 写文件
-c "program xxx.hex"
## -f指令
使用配置文件
~~~shell
openocd -c "interface +xxxlink" -c "transport select swd" -c "adapter_khz 1000" -f "targetstm32f4x.cfg"
~~~


## openocd 指令

**常用命令**

~~~shell
halt 					# 停止CPU
reg						# 查看寄存器
rdw 0					# Memory Display Word 查看内存
mww 0					# Memory Write Word 写内存
load_image file.bin	0 	# 下载程序到0地址，然后可以使用mdw，看看是不是程序的bin
bp						# 设置断点
bp 0x6c 4 hw			# 在0x6c的地址位置设置断点，硬件断点
rbp 0x6c 				# 取消断点
~~~

**目标板状态处理命令**

~~~shell
poll 					# 查看板子当前状态
halt					# 中断板子当前运行
resume [address]		# 恢复目标板子运行，如果指定了address，就从address开始
step [address]			# 单步执行一条指令，如果给地址，就执行地址的指令
reset 					# 复位目标板
~~~

**断点命令**

~~~shell
bp  [address] [length] [hw] # 在地址 addr 处设置断点，指令长度为 length， hw 表示硬件断点
rbp [address] 				# 删除地址 addr 处的断点 内存访问指令
~~~

**内存访问指令**

~~~shell
mdw ['phys'] <addr> [count] 显示从(物理)地址 addr 开始的 count(缺省是 1)个字(4 字节)
mdh ['phys'] <addr> [count] 显示从(物理)地址 addr 开始的 count(缺省是 1)个半字(2 字节)
mdb ['phys'] <addr> [count] 显示从(物理)地址 addr 开始的 count(缺省是 1)个字节
mww ['phys'] <addr> <value> 向(物理)地址 addr 写入一个字，值为 value
mwh ['phys'] <addr> <value> 向(物理)地址 addr 写入一个半字，值为 value
mwb ['phys'] <addr> <value> 向(物理)地址 addr 写入一个字节，值为 value
~~~

**内存装载命令**

~~~shell
load_image <file> <address> [‘bin’|‘ihex’|‘elf’]
======将文件<file>载入地址为 address 的内存，格式有‘bin’、 ‘ihex’、 ‘elf’
dump_image <file> <address> <size>
======将内存从地址 address 开始的 size 字节数据读出，保存到文件<file>中
verify_image <file> <address> [‘bin’|‘ihex’|‘elf’]
======将文件<file>与内存 address 开始的数据进行比较，格式有‘bin’、 ‘ihex’、 ‘elf’
~~~

**CPU架构命令**

~~~shell
reg 打印寄存器的值
arm7_9 fast_memory_access ['enable'|'disable']
=======使能或禁止“快速的内存访问”
arm mcr cpnum op1 CRn op2 CRm value 修改协处理器的寄存器
=======比如： arm mcr 15 0 1 0 0 0 关闭 MMU
arm mrc cpnum op1 CRn op2 CRm 读出协处理器的寄存器
=======比如： arm mcr 15 0 1 0 0 读出 cp15 协处理器的寄存器 1
arm920t cp15 regnum [value] 修改或读取 cp15 协处理器的寄存器
=======比如 arm920t cp15 2 0 关闭 MMU
~~~

**其他**

~~~shell
script <file> 执行 file 文件中的命令	# 脚本
~~~

