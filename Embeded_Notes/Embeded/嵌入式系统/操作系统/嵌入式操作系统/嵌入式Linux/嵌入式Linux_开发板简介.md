# 开发板简介
## 开发板外设简介
开发板使用的是野火iMX6ULLPro开发板
![Pasted image 20210524212555](../../../../../pictures/Pasted%20image%2020210524212555.png)
+ 由于外设众多，因此只用USB供电无法满足最小电流
+ 采用DC12V供电方式
+ USB串口通过CH340来连接MCU的串口
+ 两个DB9插头，一个公头，一个母头，用于232通信
+ 中间有两路485串口通信接口
+ 左上角两路CAN通信接口和EBF接口
+ 8位播码开关设置四种常用的启动方式
	+  从eMMC启动
	+  从Nand Flash启动
	+  从USB启动
	+  从SD卡启动
+ 中间两路百兆以太网接口
+ SPDIF
+ JTAG接口进行程序的仿真
+ WM8960编解码芯片实现音频的输入输出
+ 黑色的红外接受模块
+ 温室度接口
+ 蜂鸣器
+ 摄像头接口
+ 四个USB接口
+ MicroUSB接口
+ RTC可以装纽扣电池
+ 有商检AP6236,同时支持蓝牙和wifi
	+ SD卡不能与WiFi共用

+ HDMI接口

## SD卡烧录Debian镜像
### Etcher工具
镜像烧录工具
[工具下载网站](https://www.balena.io/etcher/)
野火Debian镜像可以在野火大学堂下载
设置连接开发板Debian的终端
通过软件MobaXterm连接终端，波特率为115200
野火的镜像文件
帐号为：debian
密码为：tempwd

剩下的步骤就是linux的内容了

fire-config工具
野火iMX6ULL自带的一个系统配置工具，通过串口终端可以方便地使用其来使能或关闭系统配置
命令为：
```shell
sudo fire-config
```
`Device Tree Overlays`找时间了解一下


## 刷机
### 使用fire-config工具刷机
目的：将Debian系统刷进Emmc，类似与安装ARCH系统的过程
将系统镜像烧录进SD卡

进入开发板登录
输入
sudo fire-config
命令
执行flash那个，将其enable，然后finish重启开发板
重启后自动进行flash的刷机
完成后RGB灯开始闪烁
执行
sudo fire-config
关闭刷机使能
然后输入poweroff关机
调整开发板的启动方式，调整为2457on。从emmc启动
长按On/off键开机，开机完成刷机


### 连接WiFi
首先要烧录镜像，不可以同时使用WiFi和SD卡模块
关机状态下调整跳线帽的位置
![Pasted image 20210526173717](../../../../../pictures/Pasted%20image%2020210526173717.png)

开机登录
用echo改变配置文件，屏蔽WiFi的串口打印输出
执行
sudo echo "1 4 1 7" > /proc/sys/kernel/printk
如果运行不了就使用root用户
root的密码为root

在fire-config工具中选择WiFi，并使能
finish后重启
等待重启完成就可以扫描WiFi

再执行fire-config命令
选择WiFi scan扫描WiFi

执行WiFi setting
输入帐号密码，并ok

Finish退出，使用ifconfig命令查看是否正确分配ip地址

如果还是不行，可以执行命令

udhcpc -b -i wlan0

路由器会动态给分配一个ip地址



