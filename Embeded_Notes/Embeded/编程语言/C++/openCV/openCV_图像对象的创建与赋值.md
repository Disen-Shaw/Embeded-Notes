# openCV图像的创建与赋值
## Mat对象的创建
### Mat的基本结构
Mat的数据分为两部分
一部分是头部，一部分是数据部
![[Pasted image 20210331144107.png]]
数据部是所有像素的集合
头部存储着图像的属性
### Mat的创建方法
#### 克隆
Mat m1 = src.clone();
地址不同，不是同一个图像
#### 复制
Mat m2 = src.copyTo(m2);
地址不同，不是同一个图像

#### 赋值法
Mat m3 = src;
地址不同，不是同一个图像
#### 创建空白对象
![[Pasted image 20210404031444.png]]
Mat m4 = Mat::zeros(src.size(),src.type());
Mat m5 = Mat::zeros(Size(512,512),CV_8UC3);
Mat m6 = Mat::ones(Size(512,512),CV_8UC3);
默认是黑色
```C++
void QuickDemo::mat_creation_Demo(Mat &image){
	Mat m1,m2;
	m1 = image.clone();
	image.copyTo(m2);
	
	// 创建空白图像
	Mat m3 = Mat::zer0s(Size(8,8),8UC1); // uchar 1位宽度
	// 输出
	std::cout<<m3<<std::endl;  
	// 输出宽度
	std::cout<<"width:"<<m3.cols<< \
			   "height:"<<m3.rows<< \
			   "channels"<<m3.channels()
			   <<std::endl;
	// 创建都是1的图像
	// 在多通道时，每个通道的第一位是1
	Mat m4 = Mat::ones(Size(8,8),8UC1); // uchar 1位宽度
	// 输出
	std::cout<<m3<<std::endl;  
	// 输出宽度
	std::cout<<"width:"<<m3.cols<< \
			   "height:"<<m3.rows<< \
			   "channels"<<m3.channels()
			   <<std::endl;
			   
	// 还可以使用的初始化方式
	Mat m5 = Mat::zeros(Size(8,8),CV_8UC3);
	m5 = Scalar(127,127,127);
	
}
```
**scalar()函数
参数：像素值
返回值： Mat类的一个实例
**

多个图像创建，并相互复制时，类似于指针，都指向同一个地址区域
对其中一个进行改动，另一个也会改动
例如：
~~~c++
Mat m1;
m1 = Salar(0,0,255); // 纯红
m2 = m1;
m2 = Salar(0,255,0); // 纯绿
imshow("改动输出",m1);
// 此时会输出纯绿色
使用clone()函数或者copyTo()函数会产生新的图像
~~~