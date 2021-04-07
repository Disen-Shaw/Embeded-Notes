# GDB 常用知识

> 调试软件

## GDB命令

| 启动/退出                                    |                                                              |
| -------------------------------------------- | ------------------------------------------------------------ |
| arm-linux-gdb[file]                          | 启动gdb,调试file                                             |
| quit                                         | 退出                                                         |
| target remote ip:port                        | 远程连接                                                     |
| **文件操作**                                 |                                                              |
| file                                         | 载入文件file，不会下载到板子上                               |
| load [file]                                  | 把文件下载到单板上，如果不指定 FILE，则下载之前指定 过的(比如 file 命令指定的，或是 gdb 运行时指定的文件) |
| **查看源程序**                               |                                                              |
| list                                         | 列出某个函数                                                 |
| list                                         | 以当前源文件的某行为中间显示一段源程序                       |
| list                                         | 接着前一次继续显示                                           |
| break *                                      | 在某个地址上设置断点，比如 break *0x84                       |
| list -                                       | 显示前一次之前的源程序                                       |
| list FILENAME:FUNCTION list FILENAME:LINENUM | 显示指定文件的一段程序                                       |
| info source                                  | 查看当前源程序                                               |
| info stack                                   | 查看堆栈信息                                                 |
| info args                                    | 查看当前的参数                                               |
| **断点操作**                                 |                                                              |
| break                                        | 在函数入口设置断点                                           |
| break FILENAME:LINENUM                       | 在指定源文件的某一行上设置断点                               |
| info br                                      | 查看断点                                                     |
| delete                                       | 删除断点                                                     |
| diable                                       | 禁止断点                                                     |
| enable                                       | 使能断点                                                     |
| **监视点操作**                               |                                                              |
| watch                                        | 当指定变量被写时，程序被停止                                 |
| rwatch                                       | 当指定变量被读时，程序被停止                                 |
| **数据操作**                                 |                                                              |
| print < EXPRESSION >                         | 查看数据                                                     |
| set varible=value                            | 设置变量                                                     |
| x /NFU ADDR                                  | 检查内存值 <br />① N 代表重复数 <br />② F 代表输出格式 x ： 16 进制整数格式 d ： 有符号十进制整数格式 u ： 无符号十进制整数格式 f ： 浮点数格式 <br />③ U 代表输出格式： b ：字节(byte) h ：双字节数值 w ：四字节数值 g ：八字节数值 比如“ x /4ub 0x0”将会显示 0 地址开始到 4 个字节 |
| **执行程序**                                 |                                                              |
| step next nexti                              | 都是单步执行： step 会跟踪进入一个函数， next 指令则不会进入函数 nexti 执行一条汇编指令 |
| continue                                     | 继续执行程序，加载程序后也可以用来启动程序                   |
| **帮助**                                     |                                                              |
| help [command]                               | 列出帮助信息，或是列出某个命令的帮助信                       |
| **其他**                                     |                                                              |
| monitor <command …>                          | 调用 gdb 服务器软件的命令，比如：“ monitor mdw 0x0” 就是调用 openocd 本身的命令“ mdw 0x0” |
|                                              |                                                              |
