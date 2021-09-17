# opencv 图像处理
#opencv 

## 读写图像
`imread` 可以指定加载为灰度或者RGB图像  
`imwrite` 可以保存图像文件，类型由拓展名决定


## 读写像素
### 灰度图像的像素值(CV_8UC1)
```c++
Scalar intensity = img.at<uchar>(y, x)
```

### RGB像素点的像素值(cv_8UC3)
```c++
Vec3f intensity = img.at<Vec3f>(y, x);
float blue = intensity.val[0];
float green = intensity.val[0];
float red = intensity.val[0];
```

### 通过修改像素值来对图像进行反向
```c++
int main(int argc, char *argv[]){
    cv::Mat src, src_gray;
    src = cv::imread("/home/master/Pictures/goal.png", cv::IMREAD_UNCHANGED);
    if (src.empty()) {
      std::cout<<"open image failed!"<<std::endl;
    }

    cv::namedWindow("src", cv::WINDOW_AUTOSIZE);

    int width = src.cols;
    int height = src.rows;
    for (int h = 0; h<height; h++) {
      for(int w = 0; w<width; w++) {
        int b = src.at<cv::Vec3b>(h, w)[0];
        int g = src.at<cv::Vec3b>(h, w)[1];
        int r = src.at<cv::Vec3b>(h, w)[2];
        src.at<cv::Vec3b>(h, w)[0] = 255 - b;
        src.at<cv::Vec3b>(h, w)[1] = 255 - g;
        src.at<cv::Vec3b>(h, w)[2] = 255 - r;
      }
    }
    cv::imshow("src", src);
    cv::waitKey(0);
    return 0;
 }
```

### opencv反相API
```c++
bitwise_not(src, dst);
```

### Vec3b和Vec3F
+ Vec3b对应的三通道顺序为B、G、R的 `unsigned char` 类型的数据
+ Vec3F对应的是三通道的 `float` 类型的数据
+ 把 `CV_8UC1` 转化为 `CV32F1` 的实现如下：
	+ `src.convertTo(dst, CV_32_F)`


## 调整图像亮度和对比度
### 理论知识
图像变换可以看做：
+ 像素变换：点操作
+ 邻域操作：区域

调整图像亮度和对比度属于像素变换，是点操作  
$g(i,j)=\alpha f(i,j)+\beta$
+ $\alpha$ >0
+ $\beta$ 是增益变量

越亮应该越向255的方向靠拢
### 重要的API
```c++
Mat new_image = Mat::zeros(image.size(), image.type());
```
创建一个和原画大小和类型一致的空白图像、像素值初始化为0
```c++
saturate_cast<uchar>(value)
```
确保值的大小范围为0～255
```c++
Mat.at<Ver3b>(y, x)[index]=value
```
给每个像素每个通道赋值

## 绘制形状和文字
### cv::Point和cv::Scalar
+ Point表示2D平面上一个点(x,y)
```c++
Point p;
p.x = 10;
p.y = 8;
// 或者
p = Point(10,8)
```
+ Scalar表示四个元素的向量
```c++
Scalar(a, b, c);
/* 
 * a表示blue通道
 * b表示green通道
 * c表示red通道
*/
```
### 绘制线、矩形、圆、椭圆等基本形状
+ 画线：`cv::line(LINE_4\LINE_8\LINE_AA)`
+ 画椭圆：`cv::ellipse`
+ 画矩形：`cv::rectangle`
+ 画圆：`cv::circle`
+ 画填充：`cv::fillPoly`
+ 文字：`cv::putText`



