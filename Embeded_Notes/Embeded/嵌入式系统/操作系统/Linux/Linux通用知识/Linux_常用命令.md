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
+ tar：压缩与解压命令

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

## TAR工具
使用参数：
+ -c：表示创建用来生成文件包
+ -x：表示从文件包中提取
+ -t：可以查看压缩的文件
+ -z：使用gzip方式进行处理，它与’c‘结合就表示压缩，与'x'结合就是解压缩
+ -j：使用bzip2方式进行处理，它与’c‘结合就表示压缩，与'x'结合就是解压缩
+ -v：详细报告tar处理信息
+ -f：表示文件，后面接文件名
+ -c：指定目录，解压到指定目录

参数有没有-效果相同
### tar打包、gzip压缩
#### 压缩
```shell
tar -czvf 压缩文件名 目录名
#例如
tar czvf haha.tar.gz 要打包的文件夹
```
#### 查看
```shell
tar tvf xxx.tar.gz
```

#### 解压
```shell
tar xzvf 压缩文件名 -c 指定目录
```

### tar打包、bzip2压缩
操作基本相同，把z改成j

bzip2压缩大文件更有优势