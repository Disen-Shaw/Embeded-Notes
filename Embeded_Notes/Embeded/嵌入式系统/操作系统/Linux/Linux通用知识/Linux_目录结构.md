# Linux目录
根目录由`/`表示
根目录下有一些子目录，维持着Linux的各项功能的正常运行
+ bin：所有用户都可以使用
+ boot：启动文件，比如内核等
+ dev：设备文件，Linux特有的
+ etc：配置文件
+ home：家目录，用户的家目录所在
+ lib：库，链接到的是`usr/lib`
+ media：插上u盘等外设会挂载到该目录下
+ mnt：用来挂载其他文件系统
+ opt：可选的程序 optional
+ proc：用来挂载虚拟的proc文件系统
+ root：root用户的家目录
+ sbin：基本的系统命令，管理员才可以使用
+ sys：用来挂载虚拟的sys文件系统，可以查看系统的信息：比如设备信息
+ tmp：临时目录，存放临时文件
+ usr：Unix Software Resource，存放可分享的与**不可变动的数据**
	+ bin：绝大部分用户可以使用的指令都放在这，软件的快捷方式文件夹？
	+ games：游戏
	+ include：各种库的头文件
	+ lib：库
	+ local：系统管理员在本机自行安装、下载的软件
	+ sbin：非系统正常运作所需要的命令
	+ share：共享文件
	+ src：源码

+ var：主要针对常态性变动的文件，包括缓存(cache)、log文件等

