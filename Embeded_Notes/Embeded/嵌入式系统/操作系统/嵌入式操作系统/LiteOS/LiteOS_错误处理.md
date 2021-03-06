# LiteOS错误处理
## 基本概念
错误处理指程序运行错误时，调用错误处理模块的接口函数，上报错误信息，并调用注册的钩子函数进行特定处理，保存现场以便定位问题。  
通过错误处理，可以控制和提示程序中的非法输入，防止程序崩溃

## 运作机制
错误处理是一种机制，用于处理异常状况。当程序出现错误时，会显示相应的错误码。  
此外，如果注册了相应的错误处理函数，则会执行这个函数。

![[Pasted image 20210907104428.png]]

## 错误码简介
调用API接口时可能会出现错误，此时接口会返回对应的错误码，以便快速定位错误原因。  

错误码是一个32位的无符号整型数，31~24位表示错误等级，23~16位表示错误码标志（当前该标志值为0），15~8位代表错误码所属模块，7~0位表示错误码序号。

| 错误等级 | 数值 | 含义 |
| -------- | ---- | ---- |
| NORMAL   | 0    | 提示 |
| WARN     | 1    | 警告 |
| ERR      | 2    | 严重 |
| FATAL    | 3    | 致命 |


