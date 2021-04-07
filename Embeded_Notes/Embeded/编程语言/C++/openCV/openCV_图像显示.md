# openCV图像显示
## 读取图像
**imread();**
返回值为打开的文件，类似于C库中的fopen()函数
参数：
+ 图片路径
+ flag 大都以IMREAD开头
	+ 透明通道UNCHANGED

src.depth()24位默认为1
## 展示图像
**imshow();**
只能显示8位或者浮点位的图像
三个通道的顺序：BGR
参数
+ 窗口名称
+ 图像对象
执行命令后会显示imread中开启的窗口
## 窗口调整
**namedWindow("输入窗口",WINDOW_FREERATIO); **
配合imshow使用，第一个参数应保持一致


## 阻塞延时
waitKey(0);
执行后会在使窗口延时
参数单位：ms
## 其他
判断打开的图像是否为空
~~~c++
if(src.empty())
{
	// 处理函数
}
~~~
