# opencv 图像的基本操作
#opencv 

## 加载图片
```c++
cv::imread()
```
加载图像成为一个 `Mat` 对象
+ 其中第一个参数表示加载的图像文件名
+ 第二个参数表示加载的图像是什么类型
	+ IMREAD_UNCHANGED(<0)：加载原图不做任何改变
	+ IMREAD_GRAYSCALE(0)：表示把原图作为灰度图像加载进来
	+ IMREAD_COLOR(>0)：把原图作为RGB图像加载进来

> opencv支持JPG、PNG、TIFF等常见格式图像文件加载

## 显示图像
```c++
/* 创建窗口 */
cv::namedWindow()
/* 在窗口显示图片 */
cv::imshow()
```
namedWindow 创建一个 opencv 窗口，它是由 opencv 自动创建和释放的，无需销毁它
+ 常见的用法为 namedWindow("window_title", cv::WINDOW_AUTOSIZE)
	+ WINDOW_AUTOSIZE 会根据图像大小显示窗口大小，不能人为改变窗口大小
	+ WINDOW_NORMAL 在和 Qt 集成的时候会使用，允许修改窗口大小

imshow 根据窗口名称显示图像到指定窗口上去
+ 第一个参数是窗口名称
+ 第二个参数是 Mat 对象


## 修改图像
```c++
cv::cvtColor()
```
把图像从一个色彩空间转换到另一个色彩空间，有三个参数
+ 第一个参数表示源图像
+ 第二个参数表示色彩空间转换之后的图像
+ 第三个参数表示源和目标色彩空间，如
	+ COLOR_GBR2HLS
	+ COLOR_BGR2GRAY等

## 保存图像
```c++
cv::imwrite()
```
保存图像到指定目录
+ 保存条件
	+ 8位、16位的PNG、JPG、TIFF文件格式
	+ 单通道或者三通道的BGR的图像
+ 保存PNG格式的时候可以保存透明通道的图片
+ 可以指定压缩参数