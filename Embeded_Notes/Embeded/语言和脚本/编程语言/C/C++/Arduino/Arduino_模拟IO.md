# Arduino模拟IO函数
## **analogPead()**
用于从Arduino的模拟输入引脚读取数值
Arduino控制器有多个10位数模转换通道。
这意味着Arduino可以将0－5伏特的电压输入信号映射到数值0－1023
语法：
~~~c++
analogRead(pin)
~~~
返回值：
0～1023之间的值


## **analogWrite**
将一个模拟数值写进Arduino引脚。
`这个操作可以用来控制LED的亮度, 或者控制电机的转速. `
Arduino每一次对引脚执行analogWrite()指令，都会给该引脚一个固定频率的PWM信号。
PWM信号的频率大约为490Hz.
**在使用前无需使用pinMode初始化**
语法
~~~c++
analogWrite(pin, value)；
~~~
参数：
`pin`：被读取的模拟引脚号码  
`value`：0到255之间的PWM频率值, 0对应off, 255对应on

