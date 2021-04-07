# Arduino_数学函数
## min()函数
取两者之间最小值
参数类型可以是任意数据类型
****
## max()最大值
取两者之间最大值
参数类型可以是任意数据类型
****
## abs() 区绝对值
求绝对值

参数为计算绝对值的数字
****
## constrain() 数值限制
将一个数值限制到某一区间
语法：
constrain（x,a,b）
x: 被限制到某一区间的数值（可以是任何数据类型）
a: 限制区间下限（可以是任何数据类型）
b: 限制区间上限（可以是任何数据类型）
****
## **map()映射函数**
map()可以用来将某一数值从一个区间等比映射到一个新的区间。
语法：
~~~c++
map (x, in_min, in_max, out_min, out_max)
~~~
参数：
x： 要映射的值  
in_min： 映射前区间最小值  
in_max： 映射前区间最大值  
out_min： 映射后区间最小值  
out_max 映射后区间最大值
****
## pow()指数函数
指数运算
pow (float base, float exponent)
参数：
base: 底数(float型)
exponent:指数 (float型)
返回值
指数运算结果

****
## sqrt()开方函数
执行开放运算
sqrt (double x);

## sin()正弦运算
计算角度的正弦值
浮点型数据

## cos()弦运算
计算角度的余弦值
浮点型数据

## ta()正弦运算
计算角度的正切值
浮点型数据

## random()随机数
函数可用来产生随机数

语法：
~~~c++
random(max)
random(min, max)
~~~

单独使用random（）函数。每次程序运行所产生的随机数字都是同一系列数字。并非真实的随机数，而是所谓的伪随机数。
如果希望每次程序运行时产生不同的随机数值。应配合使用

## randomSeed()函数
randomSeed()函数可用来产生随机种子
语法：
randomSeed(seedVal)，配合radom函数可以产生真的随机数
