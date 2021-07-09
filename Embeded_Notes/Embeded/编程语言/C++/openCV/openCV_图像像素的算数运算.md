# openCV图像像素的算术操作
## opencv四则运算函数
opencv中的Mat类支持普通数据类型的四则运算操作
### 加函数
add(Mat var1,Mat var2,Mat var3)
将var1和var2的图像值相加，得出结果复制给var3
### 减函数
subtract();
用法和加函数类似
### 乘函数
multiply();
用法和加函数类似
### 除函数
divide();
用法和加函数类似
  

### 其他
saturate_cast\<xxx>()函数
可以将形参束缚在xxx类型的大小范围内，如果运算后值超过最大范围，则取其最大值

## 说明
在opencv中使用普通的加减乘除符号也能对图像进行运算操作，但是opencv库中的函数对算法进行了大量的优化，速度会比新人写的操作代码更快，因此推荐使用opencv自带的函数

