# Linux 指令
## 常用指令
+ pwd：查看当前目录
+ ls：查看当前路径文件
+ cd：切换路径
+ mkdir：新建目录
+ rm：删除
+ touch：新建文件
+ cp：复制命令
+ cat：现实文件内容
+ clear：清屏

## shell
shell是一个应用程序，可以通过键盘、串口给它发送命令，回车后它就会去执行这些命令。

## 添加路径PATH
在~/.bashrc的最后一行加入要添加的指令
~~~shell
export PATH="xxxxx:$PATH"
~~~
在编辑完成后使用命令
source .bashrc
来完成刷新
## 测试指令运行时间
time + 指令
用户态、系统态和真实运行时间

