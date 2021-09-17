# opencv 矩阵的掩模操作
## 获取像素指针
```c++
cv_Assert(myImage.depth()==CV8U);
```
+ `Mat.ptr<uchar>(int i=0)` 获取像素矩阵的指针
	+ 索引i表示第几行，从0开始计数
+ 获得当前行指针 `const uchar* current = myImage.ptr<uchar>(row);`
+ 获得当前像素点 `P(row, col)` 的像素值 `p(row, col) = current[col]`

### **像素范围处理**
```c++
saturate_cast<uchar>()
```
确保RGB的值在0～255之间  
+ `saturate_cast<uchar>(-100)`，返回0
+ `saturate_cast<uchar>(288)`，返回255
+ `saturate_cast<uchar>(100)`，返回100

### 掩模操作实现图像对比度调整
矩阵的掩模操作根据掩模重新计算每个像素的像素值，掩模(mask 也被称为Kernel)  
**通过掩模操作实现图像对比度提高**  
$$
I(i,j)=5*I(i,j)-[I(i-1,j)+I(i+1,j)+I(i,j-1)+I(i,j+1)]
$$
$$
\begin{bmatrix}
0 & -1 & 0 \\
-1 & 5 & -1 \\
0 & -1 & 0
\end{bmatrix}
$$
j表示行，j表示列
![[Pasted image 20210915023645.png]]
红色是中心像素，从上到下，从左到右对每个像素做同样的处理操作，得到的最终结果就是对比度提高之后的输出图像Mat对象

## opencv 调整图像对比度API
```c++
cv::filter2D(Mat src, Mat drt, int ddepth, InputArray kernel );
```
参数说明：
+ src：源图像
+ drt：目标图像
+ ddepth：位图深度，有32位，24位，8位等
+ kernel：类似于上面图片的矩阵
	+ `Mat kernel = (Mat_<char>(3,3) << 0, -1, 0, -1, 5, -1, 0, -1)`


## 获取执行时间API
```c++
double t = getTickCount();

double timeconsume = (getTickCount()-t)/getTickFrequency();
```