# Arduino基础结构语句
## 基本语言
Arduino程序分为三个主要部分：结构、数值和函数
### 结构
#### setup()函数
当Arduino程序开始运行时会调用setup()函数。通常我们setup()函数其中初始化一些变量、引脚状态及一些调用的库等。当Arduino控制器通电或复位后，setup函数会运行一次。
#### loop()函数
setup()函数对程序完成了初始化后，loop()函数将会运行。loop函数是一个循环体，在Arduino启动后，loop()函数中的程序将会不断运行。通过loop()函数你可以利用你的程序来控制Arduino，并使Arduino根据你的程序进行相应的反应

### 控制语句
和C语言和c++的语法基本一致
[[C语言流程控制语句]]

## 数值
#### HIGH
HIGH的含义取决于Arduino的引脚设置。当引脚设置为为输入模式(INPUT)或为输出模式(OUTPUT)时，HIGH的含义有所不同。
##### 输入模式
大于3V时返回的值，逻辑1
##### 输出模式
输出5V的高电平
#### LOW
LOW的含义取决于Arduino的引脚设置，当引脚设置为为输入模式 (INPUT)或为输出模式(OUTPUT)时，LOW的含义有所不同。
##### 输入模式
输入电压小于2V，逻辑0
##### 输出模式
输出0V电平

### INPUT
当引脚设置为输入（INPUT）模式时，引脚为高阻抗状态（100兆欧）。此时该引脚可用于读取传感器信号或开关信号。
_**当Arduino引脚设置为输入（INPUT）模式或者输入上拉（INPUT\_PULLUP）模式，不可以将该引脚与负压或者高于5V的电压相连，否则可能会损坏Arduino控制器。**_
`我的开发版好像是这样坏的`

### INPUT_PULLUP
Arduino 微控制器自带内部上拉电阻。如果你需要使用该内部上拉电阻，可以通过pinMode()将引脚设置为输入上拉（INPUT\_PULLUP）模式，多用于判断引脚按键是否按下
_**当Arduino引脚设置为输入（INPUT）模式或者输入上拉（INPUT\_PULLUP）模式，请勿将该引脚与负压或者高于5V的电压相连，否则可能会损坏Arduino控制器。了解更多如何使用上拉电阻或者下拉电阻的内容，请参阅本站相关内容。**_

### true和false
在Arduino内有两个常量用来表示真和假：true和 false。
#### true
true通常被定义为数值1。但true具有更广泛的定义。在布尔含义(bo0lean)里任何 非零 整数 都是true。
所以在布尔含义内 -1，2 和 -200 等非零数值都被定义为ture。


### 数据类型
拥有比C++多的数据类型，多出来的有
[[C语言数据类型]](C++有string类型)
#### boolean
判断类型，1bit
#### byte
字节型
可存储8位无符号数，其存储数值范围是 0 – 255
#### word
字型
一个存储一个16位无符号数的字符，取值范围从0到65535。
#### 数组
数组是一种可通过索引号访问的同类型变量集合。
#### 数据类型转换
类似于c/c++中的语句

### 变量和函数作用域
一个程序内的全局变量是可以被所有函数所调用的。而局部变量只在声明它们的函数内可见。在Arduino的环境中，任何在函数外声明的变量，都是全局变量。
例如在setup(),loop()等函数外声明的函数都是全局变量。

当程序变得更大更复杂时，声明局部变量是一种更加有效的变量声明方式。因为局部变量只有在声明它的函数中有效，而其它函数是不能调用它的。这样做可以防止因为粗心而错误的改变变量数值问题。

### static-静态变量
static静态变量只对声明该变量的函数有效。静态变量和局部变量不同的是，局部变量在每次调用时都会被创建，在调用结束后被销毁。而静态变量在函数调用后仍然保持着原来的数据。

### volatile
Volatile这个关键字是变量修饰符，常用在变量类型的前面，以告诉编译器和接下来的程序怎么对待这个变量。

### const-常量
const关键字代表常量 (Constant)。它用于修改变量性质，使其变为只读状态。常量可以像任何相同类型的其他变量一样使用，但不能改变其数值。也就是说，常量的数值在建立时一旦确定以后，如果在后续的程序中尝试改变常量数值，那么程序编译时将会报错。

## 函数
### 通信
#### Stream
当使用ESP8266开发板或者Arduino开发板来开发项目时，可以使用基于Stream类的库来处理Stream数据。
以下列表中的库都是基于Stream类所建立的。

|库|类|
|-----|----|
|Serial|Serial|
|SoftwareSerial|SoftwareSerial|
|Ehternet|EthernetClient|
|SD|File|
|Wire|Wire|
|GSM|GSMClient|
|WifiClient|WifiClient|
|WiFiServer|WiFiServer|
|WiFiUDP|WiFiUDP|
|WiFiClientSecure|WiFiClientSecure|


#### Serial串行通信
所有Arduino控制器都有至少一个串行端口（也称为UART或者USART）。个人电脑可以通过USB端口与Arduino的引脚0(RX)和引脚1(TX) 进行通信。
当Arduino的引脚0和引脚1用于串行通信功能时，Arduino的引脚0和引脚1是不能做其他用的。
可以通过Arduino开发环境软件中的串口监视器来与Arduino 控制器进行串口通信
##### 函数
[[Arduino_Serial]]函数包含有：
available()
begin()
end()
find()
findUntil()
flush()
peek()
print()
println()
parseInt()
parseFloat()
read()
readBytes()
readBytesUntil()
write()
readString()
readStringUntil()
#### 数字IO
[[Arduino_数字IO]]
pinMode()函数
digitalWrite()函数
digitalRead()函数

#### 模拟IO
[[Arduino_模拟IO]]
analogRead()
analogWrite()--PWM
#### 高级IO
[[Arduino_高级IO]]
tone()
noTone()
shiftOut()
shiftIn()
pulseIn()

#### 时间
[[Arduino_时间函数]]
millis()
micros()
delay()
delayMicroseconds()

#### 数学
[[Arduino_数学函数]]
min()		取最小值
max()		取最大值
abs()		绝对值
constrain()	数值限制
map()		映射函数
pow()		指数函数
sqrt()		开方函数

#### 外部中断
[[Arduino_外部中断]]
attachInterrupt()
用于为Arduino开发板设置和执行ISR（中断服务程序）用的

|Arduino控制板|支持的中断|
|--|--|
|Uno, Nano, Mini|2, 3|
|Mega, Mega2560, MegaADK|2, 3, 18, 19, 20, 21|
|Micro, Leonardo|0, 1, 2, 3, 7|
|Zero|除4号引脚以外的所有数字引脚|
|MKR1000 Rev.1|0, 1, 4, 5, 6, 7, 8, 9, A1, A2|
|Due|所有数字引脚|

进入中断
在ISR（中断服务程序）函数中，delay()函数是不工作的，而且millis()函数返回值也不再增长。在ISR（中断服务程序）运行期间Arduino开发板接收到的串口数据也可能丢失。另外ISR函数里所使用的变量应声明为volatile类型。详情请见以下”关于ISR（中断服务程序）”部分。

在中断服务程序中，不能使用delay()函数和millis()函数。
因为他们无法在中断服务程序中正常工作。
**delayMicroseconds()可以在中断服务程序中正常工作。**
中断服务程序应尽量保持简单短小。否则可能会影响Arduino工作。
中断服务程序中涉及的变量应声明为volatile类型。
中断服务程序不能返回任何数值。所以应尽量在中断服务程序中使用全局变量。