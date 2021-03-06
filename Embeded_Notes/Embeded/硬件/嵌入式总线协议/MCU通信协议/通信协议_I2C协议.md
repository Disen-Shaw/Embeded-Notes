# I2C协议
#IIC 
引脚少、不需要USART、CAN等通讯协议的外部收发设备,简单快乐

## I2C物理层特点
+ 支持多设备连接的总线
+ 一个I2C总线只使用两条总线线路
+ 每个连接到总线的设备都有一个独立的地址
+ 总线通过上拉电阻接到电源
  + I2C设备空闲时，会输出高阻态，由上拉电阻把总线拉成高电平
  + 输出逻辑1时通过高阻态表示，此时通过上拉电阻的高电平表达逻辑1N
  + 高阻态类似于直接断开
+ 多个主机同时使用总线，为防止冲突，会利用仲裁方式决定那个设备占用总线
+ 具有三种传输模式：多数I2C设备不支持高速
  + 标准模式：100k bit/s
  + 快速模式：400k bit/s
  + 高速模式：3.4M bit/s
+ 连接到相同的IC数量受到总线的最大电容限制

使用时，引脚设置为开漏输出，由上拉电阻上拉

## I2C协议层特点
I2C协议层规定了通讯的起始信号和停止信号、数据的有效性、响应仲裁、时钟同步和地址广播等环节


### 通讯的起始信号和停止信号

当SCL线是高电平时SDA线从高电平向低电平切换，这个情况下表示通讯的起始
当SCL是高电平时SDA线有低电平向高点评切换，表示通讯的停止
起始和停止信号一般由主机产生


### 数据有效性
I2C使用SDA信号线来传输数据，使用SCL线进行数据同步
SDA数据在SCL的每个始终周期传输一位数据


**SCL为高点平时SDA表示的数据才有效**


### 地址及数据方向

+ I2C总线的每个设备都有自己的地址，朱局发送通讯时，通过SDA信号发送设备地址来查找从机，设备地址可以是7位或者10位
+ 地址后面的一个数据位**R/W#**来表示数据的传输方向

 | MSB       |           |           |           |           |           |           | LSB  |
     | --------- | --------- | --------- | --------- | --------- | --------- | --------- | ---- |
     | 从机地址1 | 从机地址2 | 从机地址3 | 从机地址4 | 从机地址5 | 从机地址6 | 从机地址7 | R/W# |

通信到相应的地址后，硬件自动配对响应

### 响应
I2C数据或者地址的传输都带响应

   + 应答
   + 非应答

传输时主机产生时钟，**在第九个时钟时，数据发送端会释放SDA的控制权，**由数据接收端控制SDA

   + **若SDA为高电平，表示非应答**
   + **若SDA位低电平，表示应答**

