# opencv Mat对象

## Mat对象与IplImage对象
一个图片在人眼中是一个具体的图像，一个汽车、一个苹果等，但是在计算机中是01代码，Mat对象将图片读成是一个二维数组，里面就是一个个的像素

### IplImage
2001年 opencv 发布之后就一直存在，是c语言风格的数据结构，需要开发者自己分配与管理内存，对于大的程序它很容易导致内存泄露问题  

### Mat
Mat 对象在 opencv2.0 之后引入的图像数据结构，自动分配内存，不存在内存泄露的问题，**是面向对象的数据结构**  

分了两个部分：**头部**与**数据部分**  

## Mat对象的构造函数和常用方法
### 构造函数
```c++
Mat()
Mat(int rows, int cols, int type)
Mat(Size size, int type)
Mat(int rows, int cols, int type, const Scalar &s)
Mat(Size size, int type, const Scalar &s)
Mat(int ndims, const int *sizes, int type)
Mat(int ndims, const int *sizes, int type, const Scalar &s)
```
### 常用方法
```c++
void copyTo(Mat mat);
void convertTo(Mat dst, int type);
Mat clone();
int channels();
int depth();
bool empty();
uchar *ptr(i=0);
```

## Mat对象使用
### 部分复制
一般情况下只会复制Mat对象的头和指针部分，不会复制数据部分  
例如
```c++
Mat A = imread(imgFilePath);
Mat B(A); 
```
此时B对A为部分复制

### 完全复制
把Mat对象的头部和数据部分一起复制，可以通过下面两个API完成  
```c++
Mat F = A.clone();
Mat G;
A.copyTo(G);
```
## Mat对象使用的几个要点
+ 输出图像的内存是自动分配的
+ 使用opencv的c++借口，不需要考虑内存分配问题  
+ 赋值操作和拷贝构造函数只会复制头部分
+ 使用clone与copyTo两个API可以实现完全复制

## 定义小数组
```c++
Mat C=(Mat_<double>(3,3)<<0,-1,0,-1,5,-1,0,-1,0)
cout << "C=" <<endl<<""<C<<endl;
```
