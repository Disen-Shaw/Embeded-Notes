# 嵌入式Linux基本知识
## 为什么学习Linux开发
### Linux的应用场景
#### 服务器
+ 提供计算服务设备
+ 网上社交、购物等的互联网应用

[了解不同服务器的运行环境](https://www.netcraft.com)

#### 智能家居
智能灯泡、智能门锁、智能插座、门禁感应、环境感应器等
背后需要Linux网管来实现互联

#### 工业控制
+ 机械臂
+ 喷涂机
+ 螺丝机等

#### 消费电子
+ 手机、笔记本等

#### 汽车仪表
+ 行车记录仪
+ 导航仪等

## Linux的职业发展方向
### 服务器运维
主要负责公司服务器的高效稳定

### 应用软件开发
+ 服务器软件
+ 桌面应用软件
+ 嵌入式应用软件

### 嵌入式系统开发
+ 系统开发 uboot/kernel
+ 驱动开发 
	+ 基础：gpio/key/lcd/sd-card/iic/spi
	+ 复杂：usb/vedio/wifi等

### 优秀开源项目
picoc 三到五年资历可以研究研究
write-a-c-interpreter
都是C语言的解释器


### 技术研究
深入了解语言底层机制
掌握业务相关算法
熟悉客户业务需求
芯片功能
RTOS任务调度


## 如何学习Linux开发
### Linux传统学习路线
1. linux基本操作+c语言进阶
2. ARM裸机开发
3. Linux系统移植(u-boot移植、kernel移植、构建文件系统)
4. Linux驱动开发
5. Linux应用编程
6. 实战

### 韦东山
先应用基础
再驱动基础
项目反馈

### 树莓派
卡片电脑，一个小电脑

## 嵌入式开发有哪些内容
嵌入式Linux系统，就相当于一套完整的PC软件系统
![Pasted image 20210707004737](../../../../../pictures/Pasted%20image%2020210707004737.png)
开发嵌入式linux基本开发linux的四个部分

### Windows
采用BIOS启动windows，识别C盘中的操作系统

### Linux
采用bootloader启动linux内核，识别跟文件系统运行操作系统
bootloader长采用u-boot

#### linux内核
+ 内核本身
+ 驱动程序

#### 根文件系统
+ 系统必备的app
+ 用户app

