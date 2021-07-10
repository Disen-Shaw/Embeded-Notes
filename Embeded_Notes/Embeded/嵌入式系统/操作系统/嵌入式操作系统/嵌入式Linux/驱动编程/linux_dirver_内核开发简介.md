# 内核开发简介
## 环境设置
linux开发环境，拥有arm-none-linux-gnueabihf的工具链


## 获取源代码
得益于Linus Torvalds的Github仓库
```shell
git clone https://github.com/torvalds/linux
git check v4.1
ls
```
文件内容如[[Linux_Code]]所示

## 内核配置
Linux内核是一个基于Makefile的大工程，有1000多个选项和驱动程序
配置内核可以使用
+ 基于ncurse的接口命令：make menuconfig
+ 也可以使用基于x的接口命令make xconfig

一旦选择，所有的选项就会在源代码根目录下的.config目录下

大多数情况下不需要冲头配置这些。每个ARCH目录下都有默认的配置文件可以使用，可以把这些文件作为配置的起点

对于基于ARM的CPU，这些配置文件位于arch/arm/configs/下
对于i.MX6的处理器，位于arch/arm/configs/imx_v6_v7_defconfig
对于x86架构的处理器，可以arm/x86/configs下找到

![[Pasted image 20210607211848.png]]

`对于x86架构的CPU，内核的配置：`
make x86_64_defconfig
make zImage -j16
make modules
makeINSTALL_MOD_PATH \</where/to/install> modules_install

`对于基于imx6u的主板`
可以执行
ARCH=arm make imx_v6_v7_defconfig 
ARCH=arm make menuconfig

在执行xconfig的过程中可能会遇到Qt的错误，安装对应的包就可以了

## 构建自己的内核
ARCH=arm make imx_v6_v7_defconfig
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make zImage -j16

执行后开始构建
![[Pasted image 20210607212545.png]]
内核构建完成在arch/arm/boot下生成一个单独的二进制映像文件
使用下面的命令构建模块
ARCH=arm CROSS_COMLILE=arm-linux-gnueabihf- make modules_install
modules_install目标需要指定一个环境变量INSTALL_MOD_PATH，指出模块的安装目录，如果没有制定，则模块会被安装到/lib/modules/下 $(KERNELRELEASE)/kernel/目录下

iMX6处理器支持设备树，设备树是一些文件，可以用来描述硬件

运行下面的命令可以编译所有的ARCH设备树

ARCH=arm CROSS_COMPILER=arm-linux-gnueabihf- make dtbs

dtbs选项不一定适用于支持设备树的平台，要构建一个单独的DTB，应该执行下面的命令
ARCH=arm CROSS_COMPILER=arm-linux-gnueabihf- make imx6d- sabrelite.dbt





