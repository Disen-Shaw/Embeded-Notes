# 嵌入式Linux基础
## [GCC](../../../../../../Tools/GNU_Tools/GCC.md)
### GCC的由来
GCC来源于GNU组织、Unix系统和minux系统  
posix接口，计算机标准接口  
Internet技术  

### GCC编译工具链
+ gcc编译器(预处理、编译)
+ binutils工具链(汇编、链接)

### [arm-none-eabi-gcc](../../../../../../Tools/Embeded_Tools/arm-none-eabi-gcc.md) 交叉编译
#### ARM-GCC
编译工具链和目标程序运行在相同的平台，就叫做本地编译  
编译工具链和目标程序运行在不同的平台,就叫做交叉编译  
ARM-GCC是针对arm平台的一款编译器，是编译器工具链的一个分支   

#### ARM-GCC进一步分类
可以大致分为有底层环境和无底层环境  
linux none -> arm-none-eabi  
linux glibc -> arm-none-linux-gnueabihf  
eabi:应用二进制标准接口  
hf:表示编译器支持硬浮点平台  

## Linux系统和Hello,world
### 裸机开发中的Hello,world
第一步 编辑C语言的源文件 

```c
main()
{
	printf("hello,world");
}
```
->
```c
putc()
{
	uart_send();
}
```
->
```c
uart_send()
{
	// 窗口驱动
}
```
第二步 编译  
第三步 烧录  
第四步 上电运行  