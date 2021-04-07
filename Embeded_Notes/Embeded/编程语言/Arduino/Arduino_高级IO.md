# Arduino_高级IO
## **tone()函数和noTone()函数**
tone()函数可以产生固定频率的PWM信号来驱动扬声器发声
发声时间长度和声调都可以通过参数控制
### 定义发声时间长度有两种方法
第一种是通过tone()函数的参数来定义发声时长
另一种是通过noTone()函数来停止发声

如果在tone中定义发声，在没有noTone的情况下，Arduino会一直发声

Arduino一次只能产生一个声音。假如Arduino的某一个引脚正在通过tone()函数产生发声信号，那么此时让Arduino使用另外一个引脚通过tone()函数发声是不行的。
需要使用多个Arduino引脚发声，要在每个引脚输出声音信号前调用noTone()函数来停止当前的声音信号。
`应该是定时器中断`

语法：
tone(pin, frequency)
tone(pin, frequency, duration)
noTone(pin)
参数
pin: 发声引脚/不发声引脚（该引脚需要连接扬声器）
frequency: 发声频率（单位：赫兹） – 无符号整数型
duration: 发声时长（单位：微秒，此参数为可选参数) – 无符号长整型
****
## **shiftOut()函数**
将一个字节的数据通过移位输出的方式逐位输出。
`模拟I2C`
数据可以从最高位（最左位）或从最低位（最右位）输出

在输出数据时，当一位数据写入数据输出引脚时，时钟引脚将输出脉冲信号，指示该位数据已被写入数据输出引脚等待读取

如果输出始终脉冲信号，应该先通过digitalWrite(clockPin, LOW)来初始化引脚
将时钟引脚设置为LOW以确保输出数据的准确

语法：
~~~c++
shiftOut(dataPin, clockPin, bitOrder, value)
~~~
参数：
dataPin – 数据引脚  
clockPin – 时钟引脚  
bitOrder – 移位顺序 ( 高位先出 或 低位先出)  
val – 数据

使用shiftOut()函数前，数据引脚（dataPin）和时钟引脚（clockPin）必须先通过pinMode()指令设置为输出OUTPUT模式。

shiftOut一次只能输出1字节（8位）数据。如果需要输出大于255的数值，需要通过多次使用shiftOut()输出数据。

## **shiftIn()函数**
将一个字节的数据通过移位的方式逐位输入。

语法
~~~c++
byte incoming = shiftIn(dataPin, clockPin, bitOrder)
~~~

参数
dataPin – 数据引脚  
clockPin – 时钟引脚  
bitOrder – 移位顺序 ( 高位先入 或 低位先入)

****

## **pulseln()函数**
读引脚的脉冲信号, 被读取的脉冲信号可以是 HIGH 或 LOW
要检测HIGH脉冲信号, Arduino将在引脚变为高电平时开始计时, 当引脚变为低电平时停止记时，并返回脉冲持续时长（时间单位：微秒）
如果在超时时间内没有读到脉冲信号的话, 将返回0.
语法
~~~c++
pulseIn(pin, value)  
pulseIn(pin, value, timeout)
~~~
参数：
pin 引脚编号  
state 脉冲状态  
timeout 超时时间(单位：微秒)  
如果Arduino在超时时间(timeout)内没有读到脉冲信号的话, 该函数将返回0.超时时间参数是可选参数，其默认值为1秒
返回值：
脉冲的时长
超时返回0
****
