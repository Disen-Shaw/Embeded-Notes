# Qt上新建openCV工程
## 新建工程
根据界面新建工程，尽量选择qmake的构建方式(cmake不会) ：)
## 配置路径
~~~makefile
INCLUDEPATH += /usr/local/include/opencv4/opencv2
INCLUDEPATH += /usr/local/include/opencv4/
LIBS += /usr/local/lib
~~~
第二行的包含opencv4一定要加上
有的.h文件中直接包含的是opencv2/xxx.hpp
如果不配置的话会可能提示没有包含某个文件
![[Pasted image 20210326112721.png]]
## 编程
路径配置之后就可以编程了
新建main.cpp ......
~~~c++
#include <iostream>
#include <opencv.hpp>

using namespace std;
using namespace cv;

int main(int argc,char \*\*argv)
{

 Mat src;
 src \= imread("/home/master/Pictures/背影.jpg");
 if(src.empty())
 {
 	cout<<"Model Empty\\n"<<endl;
 	return \-1;
 }
 namedWindow("show",WINDOW\_FREERATIO);
 
 imshow("show",src);

 waitKey(0);
 return \-0;
}
~~~