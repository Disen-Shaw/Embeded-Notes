# openCV\_图像色彩空间转换
## 色彩空间转换函数
**cvtColor(源图像，目标图像，转换方式)函数**
改变图像的通道设置
转换方式参数：
+ COLOR_BGR2GRAY = 6 彩色到灰度
+ COLOR_GRAY2BGR = 8 灰度到彩色
+ COLOR_BGR2HSV = 40 RGB到HSY
+ COLOR_HSV2BGR = 54 HSY到RBG

## 图像保存函数
**imwrite("保存目录",Mat &img)函数**
保存图像函数
第一个参数是保存的路径
第二个对象时图像内存对象

## 具体代码
### 类代码:
#### 头文件
~~~c++
#pragma once
#include<opencv.hpp>
using namespace cv;
class function\_image
{
public:
 function\_image();
 void color\_space\_demo(Mat &image);
};
~~~
#### 类实现
~~~c++
#include "function.h"
function\_image::function\_image(){}
void function\_image::color\_space\_demo(Mat &image)
{
 Mat gray,hsv;
 cvtColor(image,hsv,COLOR\_BGR2HLS);
 cvtColor(image,gray,COLOR\_BGR2GRAY);
 namedWindow("hsv",WINDOW\_FREERATIO);
 namedWindow("gray",WINDOW\_FREERATIO);
 imshow("hsv",hsv);
 imshow("gray",gray);
 imwrite("/home/master/Pictures/hsv.jpg",hsv);
 imwrite("/home/master/Pictures/gray.jpg",gray);
}
~~~
