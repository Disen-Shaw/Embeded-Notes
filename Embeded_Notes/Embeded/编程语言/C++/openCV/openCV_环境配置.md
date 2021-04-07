# openCV环境配置
## 开发环境
Ubuntu 20.04
## 预装依赖库
~~~bash
sudo apt-get install build-essential  
sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev  
sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev  
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev liblapacke-dev  
sudo apt-get install libxvidcore-dev libx264-dev  
sudo apt-get install libatlas-base-dev gfortran  
sudo apt-get install ffmpeg
~~~

## 下载源码
地址：
1[openCV](https://github.com/opencv/opencv/releases)
2[openCV_contirb](https://github.com/opencv/opencv_contrib/releases)
3[OpenCV\_boostdesc\_vgg](https://gitee.com/shao_disheng/opencv-related-code-files/tree/master/OpenCV_boostdesc_vgg)
## 构建
### 完善工程文件夹
将2移动进1中，简历build文件夹
执行命令
~~~bash
sudo cmake -D CMAKE\_BUILD\_TYPE=Release -D CMAKE\_INSTALL\_PREFIX=/usr/local -D OPENCV\_EXTRA\_MODULES\_PATH=/home/omega-lee/opencv-4.2.0/opencv\_contrib-4.2.0/modules/ ..
# 文件路径按源码下载位置而定
~~~
将3中的所有文件移动进1中的2中的/modules/xfeatures2d/src/路径
完成图
![[Pasted image 20210324113722.png]]
### 构建文件
将1中的/modules/features2d复制到1中的2中的/modules/xfeatures2d/test
执行构建命令
~~~bash
sudo make -j4
# -j4加速用的，可加可不加
# 必须加sudo
~~~
等待构建完成，执行
~~~bash
sudo make install
~~~
进行安装

### 更改配置环境变量
~~~bash
sudo vim/etc/ld.so.conf.d/opencv.conf
~~~
在文件末尾添加`/usr/local/lib`

执行生效命令
~~~bash
sudo ldconfig
~~~
继续更改文件
~~~bash
sudo vim /etc/bash.bashrc
~~~
在文件末尾添加
~~~bash
export PKG\_CONFIG\_PATH=$PKG\_CONFIG\_PATH:/usr/local/lib/pkgconfig
~~~
保存退出
执行更新命令
~~~bash
source /etc/bash.bashrc  
sudo updatedb
~~~

## 测试
可以更改１里面的sample/cpp/里的文件来验证是否构建成功
