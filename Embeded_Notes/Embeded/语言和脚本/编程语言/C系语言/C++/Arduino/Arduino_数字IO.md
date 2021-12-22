---
date updated: '2021-10-01T07:46:31+08:00'

---

# Arduino数字IO相关函数

## **pinMode()函数**

语法：

```c++
pinMode(pin_number,status)
```

参数：

1. 引脚号
2. 状态

通过pinMode()函数，可以将Arduino的引脚配置为以下三种模式

- 输出模式(OUTPUT)
- 输入模式(INPUT)
- 输入上拉模式(INPUT_PULLUP)

`在输入上拉（INPUT\_PULLUP）模式中，Arduino将开启引脚的内部上拉电阻，实现上拉输入功能。一旦将引脚设置为输入（INPUT）模式，Arduino内部上拉电阻将被禁用`

---

## **digitalWrite()函数**

语法：

```c++
digitalWrite(pin, value)
```

将数字引脚写出高电平或者低电平\
输出模式：HIGH输出5V高电平，LOW为0V低电平\
输入模式：通过digitalWrite()语句将该引脚设置为HIGH时，这与将该引脚将被设置为输入上拉(INPUT_PULLUP)模式相同。

---

## **digitalRead()函数**

读取数字引脚的 HIGH(高电平）或 LOW（低电平）。\
语法：

```c++
digitalRead(pin)
```

返回值为引脚状态
