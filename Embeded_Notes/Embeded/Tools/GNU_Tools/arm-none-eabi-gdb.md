# ARM-GDB

## 启动arm-none-eabi-gdb

使用调试器的驱动软件指令将调试器连接目标板，并将驱动软件的GDB指令接口开启载一个设定的计算机端口(此处的端口为计算机本地的网络端口)上，一般`openOCD`的默认端口是`3333`
在调试器驱动启动端口后，开启GDB连接本地的调试器接口，就可以开始调试

### 具体实例

首先将调试器与目标板以及计算机之间的线连好

```shell
openocd -c "interface jlink" -c "target stm32f4x" 
# 连上就行
```

此时出现：
`hardware has 6 breakpoints, 4 watchpoints`\
不关闭窗口，执行`arm-none-eabi-gdb xxx.elf`\
在GDB中输入连接指令连接本地的`3333`端口

```shell
target remote localhost:3333
```

此时就将GDb与调试器连接上了，运行openOCD的终端也会收到连接信息

此时还没有完成所有初始操作，此时需要输入指令来复位、停止MCU并加载elf文件

```scritp
(gdb)monitor reset
(gdb)monitor halt
(gdb)load
```

<u>`monitor`意为监视器，向连接的外部软件发送指令</u>，此处向openOCD发送指令，因为`reset`、`halt` 等指令不是GDB内部指令，而是openOCD的指令\
随后的 `load` 指令会将启动时输入GDB的elf文件载入MCU，即下载到MCU的flash

到这里，所有的GDB连接的初始操作已经完成

## arm-none-eabi-gdb的调试指令

将`elf`我呢间加载到MCU中后，就可以进行调试操作

### 常用指令

- l</br>list的缩写，意为列出当前执行的源码</br>同时输入指令后重复按回车等效于再次输入上次的指令

- c</br>continue的缩写，不能使用run来运行代码，需要continue指令来运行

- b</br>break的缩写，用于在程序中打断点，使用方式有多种
  - b 16，在第16行代码处加断点
  - b i=1，当i=1时停止，条件式断点
  - b main，在main函数的入口打断点
  - info b，info break的缩写，显示当前断点信息
  - d break，delete break的缩写，删除所有断点
  - d break 1,删除序号为1的断点

- s</br>step的缩写，会进入子函数单步运行

- n</br>next的缩写，跳过子函数的单步运行

- u</br>until的缩写，使用时加行号</br>例如：u 16 表示运行到第16行

- finish</br>完成并跳出当前子函数

- p</br>print的缩写，使用时后面加上变量名</br>例如 p ptm 用来显示变量的数值

- display</br>使用时后面加变量名</br>例如display tmp</br>用于跟踪变量数值，在每次执行停下来时会自动显示变量值

- bt</br>查看堆栈

- q/ctrl+d</br>退出

## 开启GDb的GUI调试

进入gdb后输入`-`可以开启GUI的调试界面，进入UI界面后可以根据上面的指令进行调试
- [] 