# LiteOS开发模式
## Linux命令行模式开发
搭建好开发环境后，可以按照下面的步骤完成编译  
+ 下载[LiteOS的源码](https://github.com/LiteOS/LiteOS.git)  
+ 拷贝开发板配置文件为根目录 `.config` 文件  
	+ 根据实际使用的开发板，拷贝 `tools/build/config` 目录下的默认配置文件 `{platform).config` 到根目录，并重命名为 `.config`  
+ 配置想要执行的 `Demo`  
	+ 在根目录执行 `make menuconfig` 命令，打开图形化配置界面  
	+ 进入菜单选项，可以通过空格键时能某个Demo  
	+ 使能后方括号中有一个 "\*"  
+ 保存配置与退出图形化配置界面  
	+ S：保存配置文件为 `.config`  
	+ Q：退出  
+ 清理工程  
	+ 执行 `make clean` 完成清理命令  
+ 编译工程  
	+ 在根目录执行 `make` 命令完成工程编译  

编译之后会在 out 文件夹生成 `elf` 文件，可以使用 `arm-none-eabi-objcopy` 将之转化为 `bin` 或者 `Hex` 文件，方便烧录(原elf文件非常大，需要裁切)  
烧录完成后重启会有串口提示符，`LiteOS` 支持shell

