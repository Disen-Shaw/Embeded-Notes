---
date updated: '2021-10-03T09:25:17+08:00'

---

# SD卡

## SD卡简介

Nand_Flash

## SD卡物理结构

一张SD卡包括有 `存储单元` 、 `存储单元接口` 、 `电源检测` 、`卡及接口控制器` 和 `接口驱动器` 5个部分。\
![Pasted image 20210812151214](../../../pictures/Pasted%20image%2020210812151214.png)

- 存储单元是存储数据部件，存储单元通过存储单元接口与卡控制单元进行数据传输。
- 电源检测单元保证SD卡工作在合适的电压下，如出现掉电或者商店状态时，它会使控制单元和存储单元接口复位。
- 卡及接口控制器控制SD卡的运行状态，它包括8个寄存器
- 接口驱动控制SD卡引脚的输入输出。

## SD卡的操作模式以及切换

### SD卡的操作模式

SD卡系统(包括主机和SD卡)定义了两种操作模式

- 卡识别模式
- 数据传输模式

在系统复位后，主机处于卡识别模式，寻找总线上可用的SDIO设备，同时SD卡也会处于卡识别模式，直到主机被识别到，即当SD卡接收到 `SEND_RCA(CMD3)` 命令后，SD卡就会进入数据传输模式，而主机在总线上所有卡被识别后也进入数据传输模式。

在每个操作模式下，SD卡都有几种状态，通过命令控制显现卡状态的切换：

- 无效模式SD卡的状态：
  - 无效状态(Inactive State)
- 卡识别模式SD卡的状态：
  - 空闲状态(Idle State)
  - 准备状态(Ready State)
  - 识别状态(Identification State)
- 数据传输模式
  - 待机状态(Stand-by State)
  - 传输状态(Tramsfer State)
  - 发送数据状态(Sending-data State)
  - 接受数据状态(Receive-data State)
  - 编程状态(Programming State)
  - 断开连接状态(Disconnect State)

**卡识别模式**\
![Pasted image 20210822005901](../../../pictures/Pasted%20image%2020210822005901.png)

**数据传输模式**
![Pasted image 20210822010017](../../../pictures/Pasted%20image%2020210822010017.png)
