---
date updated: '2021-10-01T07:35:23+08:00'

---

## setTimeout 说明

setTimeout函数用于设置设备等待数据流的最大时间间隔。

当设备在接收数据时，是以字符作为单位来逐个字符执行接收任务。由于设备无法预判即将接收到的信息包含有多少字符，因此设备会设置一个等待时间\
**默认情况下，该等待时间是1000毫秒。**

在setup函数处初始化，单位是ms,数据类型为long

语法：

```c++
stream.setTimeout(time) 
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换。
Serial.setTimeout(time)
wifiClient.setTimeout(time)
```
