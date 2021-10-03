# Arduino 时间函数
## **millis()**
millis函数可以用来获取Arduino开机后运行的时间长度，该时间长度单位是毫秒
`最长可记录接近50天左右的时间`
如果超过时间记录上限，重新从0开始计时

格式：
xxx = millis();

返回值为unsigned long

## **micros()函数**
micros函数可以用来获取Arduino开机后运行的时间长度，单位为微秒
`最长可记录接近70分钟的时间。`
格式：
xxx = micros();

返回值为unsigned long
## **delay()函数**
delay()函数可用于暂停程序运行。
有点类似于定时器中断
单位ms
delay(1000);

## **delayMicroseconds()函数**
delayMicroseconds()函数的单位是微秒us
