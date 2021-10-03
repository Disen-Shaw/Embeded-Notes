# Arduino外部中断
## attachInterrupt()
语法：
~~~c++
attachInterrupt(digitalPinToInterrupt(pin), ISR(中断服务函数), mode);
~~~
参数：
pin: 中断引脚号  
ISR: 中断服务程序名  
mode：中断模式

中断模式形式
LOW： 当引脚为低电平时触发中断服务程序  
CHANGE： 当引脚电平发生变化时触发中断服务程序  
RISING： 当引脚电平由低电平变为高电平时触发中断服务程序  
FALLING： 当引脚电平由高电平变为低电平时触发中断服务程序

示例程序：
~~~c++
const byte ledPin = 13;

//用2号引脚作为中断触发引脚
const byte interruptPin = 2;  

volatile byte state = LOW;

void setup() {
  pinMode(ledPin, OUTPUT);

  //将中断触发引脚（2号引脚）设置为INPUT_PULLUP（输入上拉）模式
  pinMode(interruptPin, INPUT_PULLUP); 

  //设置中断触发程序
  attachInterrupt(digitalPinToInterrupt(interruptPin), blink, CHANGE);
}

void loop() {
  digitalWrite(ledPin, state);
}

//中断服务程序
void blink() {
  state = !state;
}
~~~

## detachInterrupt()
detachInterrupt()可用于取消中断。
语法：
~~~c++
detachInterrupt(digitalPinToInterrupt(pin));
~~~
参数：
pin：中断引脚号